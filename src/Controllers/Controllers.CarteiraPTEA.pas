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
  Horse.Commons,
  System.Net.Mime;

function ValidarCipteaId(num: String): Boolean;
var
  d10, d11: Integer;
  d: array [1 .. 9] of Integer;
  digitado, calculado: string;
  LService: TServiceCarteiraPTEA;
begin
  d[1] := StrToInt(num[1]);
  d[2] := StrToInt(num[2]);
  d[3] := StrToInt(num[3]);
  d[4] := StrToInt(num[4]);
  d[5] := StrToInt(num[5]);
  d[6] := StrToInt(num[6]);
  d[7] := StrToInt(num[7]);
  d[8] := StrToInt(num[8]);
  d[9] := StrToInt(num[9]);

  d10 := d[1] * 10 + d[2] * 9 + d[3] * 8 + d[4] * 7 + d[5] * 6 + d[6] * 5 + d[7] * 4 + d[8] * 3 + d[9] * 2;

  d10 := 11 - (d10 mod 11);
  if d10 >= 10 then
    d10 := 0;

  d11 := d[1] * 11 + d[2] * 10 + d[3] * 9 + d[4] * 8 + d[5] * 7 + d[6] * 6 + d[7] * 5 + d[8] * 4 + d[9] * 3 + d10 * 2;
  d11 := 11 - (d11 mod 11);
  if d11 >= 10 then
    d11 := 0;

  calculado := IntToStr(d10) + IntToStr(d11);
  digitado := num[10] + num[11];

  LService := TServiceCarteiraPTEA.Create(nil);
  try
    if (LService.GetByFieldValue('CipteaId', num).IsEmpty) then
      begin
        if calculado = digitado then
          Result := true
        else
          Result := false;
      end
    else
      Result := false;
  finally
    LService.Free;
  end;
end;

function GerarCipteaId: string;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9, d1, d2: LongInt;
begin
  randomize;
  n1 := Trunc(Random(10));
  n2 := Trunc(Random(10));
  n3 := Trunc(Random(10));
  n4 := Trunc(Random(10));
  n5 := Trunc(Random(10));
  n6 := Trunc(Random(10));
  n7 := Trunc(Random(10));
  n8 := Trunc(Random(10));
  n9 := Trunc(Random(10));

  d1 := (n9 * 2) + (n8 * 3) + (n7 * 4) + (n6 * 5) + (n5 * 6) + (n4 * 7) + (n3 * 8) + (n2 * 9) + (n1 * 10);

  d1 := 11 - (d1 mod 11);

  if (d1 >= 10) then
    d1 := 0;
  d2 := (d1 * 2) + (n9 * 3) + (n8 * 4) + (n7 * 5) + (n6 * 6) + (n5 * 7) + (n4 * 8) + (n3 * 9) + (n2 * 10) + (n1 * 11);

  d2 := 11 - (d2 mod 11);

  if (d2 >= 10) then
    d2 := 0;

  Result := IntToStr(n1) + IntToStr(n2) + IntToStr(n3) + IntToStr(n4) + IntToStr(n5) + IntToStr(n6) + IntToStr(n7) +
    IntToStr(n8) + IntToStr(n9) + IntToStr(d1) + IntToStr(d2);
end;

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
  CipteaId: string;
begin
  try
    LService := TServiceCarteiraPTEA.Create(nil);
    try
      LData := Req.Body<TJsonObject>;

      if not(LService.GetByFieldValue('CpfTitular', LData.GetValue('cpftitular').ToString).IsEmpty) then
        raise EHorseException.Create(THTTPStatus.BadRequest,
          'Não foi possível gravar estes dados devido a uma possível duplicata de cpf do titular');

      CipteaId := GerarCipteaId;
      while not(ValidarCipteaId(CipteaId)) do
        begin
          CipteaId := GerarCipteaId;
        end;
      if ValidarCipteaId(CipteaId) then
        begin
          LData.RemovePair('Cipteaid');
          LData.AddPair('CipteaId', CipteaId);
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
