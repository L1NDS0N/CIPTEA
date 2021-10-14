unit Controllers.CarteiraPTEA;

interface

uses
  Services.CarteiraPTEA,
  Providers.Authorization,
  System.Classes,
  Horse,
  System.JSON,
  System.SysUtils,
  VCL.Dialogs,
  Dataset.Serialize;

procedure Registry;

implementation

uses
  Utils.ImageFormat,
  Providers.CipteaID,
  Horse.Commons,
  System.Net.Mime;

function CreateDirIfNotExists(aDirectoryString: string): string;
begin
  if not DirectoryExists(aDirectoryString) then
    CreateDir(aDirectoryString);

  Result := aDirectoryString;
end;

procedure DoList(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService: TServiceCarteiraPTEA;
begin
  LService := TServiceCarteiraPTEA.Create(nil);
  try
    Res.Send(LService.ListAll.ToJSONArray);
  finally
    LService.Free;
  end;
end;

procedure DoGet(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LId: string;
  LService: TServiceCarteiraPTEA;
begin
  LService := TServiceCarteiraPTEA.Create(nil);
  try
    LId := Req.Params.Items['id'];
    if LService.GetById(LId.ToInteger).IsEmpty then
      raise EHorseException.Create(THTTPStatus.NotFound, 'Not Found');
    //não devolver o path
    LService.qryPesquisaCarteiraPTEAfotoRostoPath.Visible := false;
    Res.Send(LService.qryPesquisaCarteiraPTEA.ToJSONObject());
  finally
    LService.Free;
  end;

end;

procedure DoPost(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService: TServiceCarteiraPTEA;
  LData: TJsonObject;
  CipteaID: string;
begin
  try
    LService := TServiceCarteiraPTEA.Create(nil);
    try
      LData := Req.Body<TJsonObject>;

      if not(LService.GetByFieldValue('CpfTitular', LData.GetValue('cpftitular').ToString).IsEmpty) then
        raise EHorseException.Create(THTTPStatus.BadRequest,
          'Não foi possível gravar estes dados devido a uma possível duplicata de cpf do titular');

      CipteaID := GerarCipteaId;
      while not(ValidarCipteaId(CipteaID)) do
        begin
          CipteaID := GerarCipteaId;
        end;
      if ValidarCipteaId(CipteaID) then
        begin
          LData.RemovePair('Cipteaid');
          LData.AddPair('CipteaId', CipteaID);
        end;

      if LService.Append(LData) then
        Res.Send(LService.qryCadastroCarteiraPTEA.ToJSONObject).Status(201);
    finally
      LService.Free;
    end;
  except
    on E: Exception do
      raise EHorseException.Create(THTTPStatus.InternalServerError, 'Erro durante a gravação do registro ' + E.Message);
  end;
end;

procedure DoUpdate(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  AID: Integer;
  LService: TServiceCarteiraPTEA;
  LData: TJsonObject;

label
  CanUpdate;
begin
  LService := TServiceCarteiraPTEA.Create(nil);
  try
    LData := Req.Body<TJsonObject>;
    AID := Req.Params.Items['id'].ToInteger;

    if not(LService.GetByFieldValue('CpfTitular', LData.GetValue('cpftitular').ToString).IsEmpty) then
      begin
        if (LService.qryPesquisaCarteiraPTEAid.AsInteger <> AID) then
          Res.Send(TJsonObject.Create.AddPair('error',
              'Não foi possível gravar estes dados devido a uma possível duplicata de cpf do titular'))
            .Status(THTTPStatus.BadRequest)
        else
          goto CanUpdate
      end
    else
      goto CanUpdate;

    CanUpdate:
    begin
      if LService.Update(LData, AID) then
        Res.Send(LService.qryCadastroCarteiraPTEA.ToJSONObject).Status(200);
    end;

  finally
    LService.Free;
  end;

end;

procedure DeleteFileById(const AID: Integer);
var
  vImgDir: string;
  vImgPath: string;
  LService: TServiceCarteiraPTEA;
begin
  LService := TServiceCarteiraPTEA.Create(nil);
  try
    vImgDir := LService.GetAFieldById('fotoRostoPath', AID);
    vImgPath := ExtractFileDir(ParamStr(0)) + vImgDir;
    if vImgDir <> EmptyStr then
      begin
        if FileExists(vImgPath) then
          DeleteFile(vImgPath);
      end;
  finally
    LService.Free;
  end;

end;

procedure DoDelete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  AID: Integer;
  LService: TServiceCarteiraPTEA;
begin
  LService := TServiceCarteiraPTEA.Create(nil);
  try
    AID := Req.Params.Items['id'].ToInteger;

    DeleteFileById(AID);

    LService.Delete(AID);
    Res.Send(LService.qryCadastroCarteiraPTEA.ToJSONObject).Status(204);
  finally
    LService.Free;
  end;
end;

procedure DoGetEtagFoto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LId: string;
  LService: TServiceCarteiraPTEA;
begin
  LService := TServiceCarteiraPTEA.Create(nil);
  try
    LId := Req.Params.Items['id'];
    if LService.GetById(LId.ToInteger).IsEmpty then
      raise EHorseException.Create(THTTPStatus.NotFound, 'Not Found');

    Res.Send(TJsonObject.Create.AddPair('AlteradoEm', LService.qryPesquisaCarteiraPTEAAlteradoEm.AsString).AddPair('ID',
        LService.qryPesquisaCarteiraPTEAid.AsString)).Status(THTTPStatus.OK);
  finally
    LService.Free;
  end;
end;

procedure DoGetStreamFoto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LStream: TFileStream;
  FullPath: string;
  aType: string;
  aKind: TMimeTypes.TKind;
  LService: TServiceCarteiraPTEA;
  vImgDir: string;
begin
  LService := TServiceCarteiraPTEA.Create(nil);
  try
    vImgDir := LService.GetAFieldById('fotoRostoPath', Req.Params['id'].ToInteger);

    FullPath := ExtractFileDir(ParamStr(0)) + vImgDir;
    try
      if FileExists(FullPath) then
        begin
          LStream := TFileStream.Create(FullPath, fmOpenRead);
          LStream.Position := 0;

          TMimeTypes.Default.GetFileInfo(FullPath, aType, aKind);
          Res.Send<TStream>(LStream).ContentType(aType).Status(THTTPStatus.OK);
        end
      else
        Res.Status(THTTPStatus.NoContent);
    except
      on E: Exception do
        raise EHorseException.Create(THTTPStatus.InternalServerError, 'Erro durante extração de imagem');
    end;
  finally
    LService.Free;
  end;

end;

procedure DoGetStreamDoc(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LStream: TFileStream;
  FullPath: string;
  aType: string;
  aKind: TMimeTypes.TKind;
begin
  FullPath := ExtractFileDir(ParamStr(0)) + '\static\' + Req.Params['id'] + '\laudomedico.pdf';

  if FileExists(FullPath) then
    begin
      LStream := TFileStream.Create(FullPath, fmOpenRead or fmShareDenyNone);
      LStream.Position := 0;

      TMimeTypes.Default.GetFileInfo(FullPath, aType, aKind);
      Res.Status(THTTPStatus.OK);
      Res.RawWebResponse.ContentType := aType;
      Res.RawWebResponse.ContentStream := LStream;
      Res.RawWebResponse.SendResponse;
    end
  else
    Res.Status(THTTPStatus.NoContent);
end;

procedure DoPutStreamFoto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LStream: TMemoryStream;
  FullPath: string;
  FileName: string;
  LService: TServiceCarteiraPTEA;
  Buffer: Word;

begin
  LService := TServiceCarteiraPTEA.Create(nil);
  try
    LStream := Req.Body<TMemoryStream>;
    if LStream.Size = 0 then
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Erro ao processar a imagem');

    //Assina a variável buffer para obter o formato do arquivo
    LStream.ReadBuffer(Buffer, 2);
    if ImageFormatFromBuffer(Buffer) = EmptyStr then
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Erro formato de imagem desconhecido');

    FileName := 'fotorosto' + ImageFormatFromBuffer(Buffer);
    FullPath := CreateDirIfNotExists(ExtractFileDir(ParamStr(0)) + '\static\' + Req.Params['id']) + '\' + FileName;
    FileName := '\static\' + Req.Params['id'] + '\' + FileName;

    try
      if LService.UpdateAField('fotoRostoPath', FileName, Req.Params['id'].ToInteger()) then
        LStream.SaveToFile(FullPath);
    except
      on E: Exception do
        raise EHorseException.Create(THTTPStatus.InternalServerError, 'Erro durante gravação de imagem - ' + E.Message);
    end;

    if FileExists(FullPath) then
      Res.Send(TJsonObject.Create.AddPair('Created', FileExists(FullPath).ToString())).Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;

end;

procedure DoPutStreamDoc(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LStream: TMemoryStream;
  FullPath: string;
begin
  try
    LStream := Req.Body<TMemoryStream>;

    if LStream.Size = 0 then
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Erro ao processar o documento');

    FullPath := CreateDirIfNotExists(ExtractFileDir(ParamStr(0)) + '\static\' + Req.Params['id']) + '\laudomedico.pdf';
    LStream.SaveToFile(FullPath);

    if FileExists(FullPath) then
      Res.Send(TJsonObject.Create.AddPair('Created', FileExists(FullPath).ToString)).Status(THTTPStatus.Created);

  except
    on E: Exception do
      raise EHorseException.Create(THTTPStatus.InternalServerError, 'Erro durante gravação do documento - ' +
          E.Message);
  end;
end;

procedure DoGetHasDoc(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if FileExists(ExtractFileDir(ParamStr(0)) + '\static\' + Req.Params['id'] + '\laudomedico.pdf') then
    Res.Send('🤔').Status(THTTPStatus.OK)
  else
    Res.Status(THTTPStatus.NoContent);
end;

procedure DoFilter(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService: TServiceCarteiraPTEA;
  FilterValue: String;
begin
  LService := TServiceCarteiraPTEA.Create(nil);
  try
    if not(Req.Query.TryGetValue('value', FilterValue)) then
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Valor para filtragem não encontrado');

    if FilterValue = EmptyStr then
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Valor para filtragem não pode estar vazio');

    LService.GetByHandleSQL('select * from carteiraptea where cpftitular LIKE ' + QuotedStr('%' + FilterValue + '%') +
        ' OR nometitular LIKE ' + QuotedStr('%' + FilterValue + '%'));

    if not(LService.qryFiltrarCarteiraPTEA.IsEmpty) then
      Res.Send(LService.qryFiltrarCarteiraPTEA.ToJSONArray).Status(THTTPStatus.OK)
    else
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure DoFilterNames(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService: TServiceCarteiraPTEA;
  FilterValue: String;
begin
  LService := TServiceCarteiraPTEA.Create(nil);
  try
    if not(Req.Query.TryGetValue('value', FilterValue)) then
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Valor para filtragem não encontrado');

    if FilterValue = EmptyStr then
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Valor para filtragem não pode estar vazio');

    LService.GetByHandleSQL('select nometitular from carteiraptea where cpftitular LIKE ' +
        QuotedStr('%' + FilterValue + '%') + ' OR nometitular LIKE ' + QuotedStr('%' + FilterValue + '%'));

    if not(LService.qryFiltrarCarteiraPTEA.IsEmpty) then
      Res.Send(TJsonObject.Create.AddPair('nomes', LService.qryFiltrarCarteiraPTEA.ToJSONArray)).Status(THTTPStatus.OK)
    else
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;

end;

procedure Registry;
begin
  THorse.Get('/carteiras', Authorization(), DoList);
  THorse.Get('/carteiras/:id', Authorization(), DoGet);
  THorse.Get('/carteiras/filter', Authorization(), DoFilter);
  THorse.Get('/nomes/filter', Authorization(), DoFilterNames);
  THorse.Post('/carteiras', Authorization(), DoPost);
  THorse.Put('/carteiras/:id', Authorization(), DoUpdate);
  THorse.Delete('/carteiras/:id', Authorization(), DoDelete);

  THorse.Get('/carteiras/:id/static/foto', Authorization(), DoGetStreamFoto);
  THorse.Put('/carteiras/:id/static/foto', Authorization(), DoPutStreamFoto);
  THorse.Get('/carteiras/:id/etag/foto', DoGetEtagFoto);

  THorse.Get('/carteiras/:id/static/doc', DoGetStreamDoc);
  THorse.Put('/carteiras/:id/static/doc', Authorization(), DoPutStreamDoc);
  THorse.Get('/carteiras/:id/has/doc', DoGetHasDoc);
end;

end.
