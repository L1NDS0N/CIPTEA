unit Controllers.CarteiraPTEA;

interface

uses
  Services.CarteiraPTEA,
  System.Classes,
  Horse,
  System.JSON,
  System.SysUtils,
  Dataset.Serialize;

procedure Registry;

implementation

uses
  Utils.ImageFormat,
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
    if LService.GetById(LId).IsEmpty then
      raise EHorseException.Create(THTTPStatus.NotFound, 'Not Found');
    Res.Send(LService.qryCadastroCarteiraPTEA.ToJSONObject());
  finally
    LService.Free;
  end;

end;

procedure DoPost(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService: TServiceCarteiraPTEA;
  LData: TJsonObject;
begin
  LService := TServiceCarteiraPTEA.Create(nil);
  try
    LData := Req.Body<TJsonObject>;
    if LService.Append(LData) then
      Res.Send(LService.qryCadastroCarteiraPTEA.ToJSONObject).Status(201);
  finally
    LService.Free;
  end;

end;

procedure DoUpdate(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  AID: Integer;
  LService: TServiceCarteiraPTEA;
  LData: TJsonObject;
begin
  LService := TServiceCarteiraPTEA.Create(nil);
  try
    LData := Req.Body<TJsonObject>;
    AID := Req.Params.Items['id'].ToInteger;
    if LService.Update(LData, AID) then
      Res.Send(LService.qryCadastroCarteiraPTEA.ToJSONObject).Status(200);
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
    LService.Delete(AID);
    Res.Send(LService.qryCadastroCarteiraPTEA.ToJSONObject).Status(204);
  finally
    LService.Free;
  end;

end;

procedure DoGetStreamFoto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LStream: TFileStream;
  FullPath: string;
  Extension: string;
  aType: string;
  aKind: TMimeTypes.TKind;
  LService: TServiceCarteiraPTEA;
  vImgDir: string;
begin
  try
    LService := TServiceCarteiraPTEA.Create(nil);
    vImgDir := LService.GetAFieldById('fotoRostoPath', Req.Params['id']);

    FullPath := ExtractFileDir(ParamStr(0)) + vImgDir;
    try
      LStream := TFileStream.Create(FullPath, fmOpenRead);
      LStream.Position := 0;

      TMimeTypes.Default.GetFileInfo(FullPath, aType, aKind);
      Res.Send<TStream>(LStream).ContentType(aType).Status(THTTPStatus.OK);
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
  Extension: string;
  aType: string;
  aKind: TMimeTypes.TKind;
begin
  //Extension := ExtractFileExt(Req.RawWebRequest.PathInfo);
  //if not Extension.IsEmpty then
  //begin
  FullPath := ExtractFileDir(ParamStr(0)) + '\static\' + Req.Params['id'] + '\fotorosto.jpg';

  LStream := TFileStream.Create(FullPath, fmOpenRead);
  LStream.Position := 0;

  TMimeTypes.Default.GetFileInfo(FullPath, aType, aKind);
  Res.Send<TStream>(LStream).ContentType(aType).Status(THTTPStatus.OK);
  //end;
end;

procedure DoPutStreamFoto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LStream: TMemoryStream;
  FullPath: string;
  FileName: string;
  LService: TServiceCarteiraPTEA;
  Buffer: Word;
begin
  try
    LService := TServiceCarteiraPTEA.Create(nil);
    LStream := Req.Body<TMemoryStream>;

    //Assina a variável buffer para obter o formato do arquivo
    LStream.ReadBuffer(Buffer, 2);
    FileName := 'fotorosto' + ImageFormatFromBuffer(Buffer);

    FullPath := CreateDirIfNotExists(ExtractFileDir(ParamStr(0)) + '\static\' + Req.Params['id']) + '\' + FileName;
    FileName := '\static\' + Req.Params['id'] + '\' + FileName;

    try
      LStream.SaveToFile(FullPath);
      LService.UpdateAField('fotoRostoPath', FileName, Req.Params['id'].ToInteger);
    except
      on E: Exception do
        raise EHorseException.Create(THTTPStatus.InternalServerError, 'Erro durante gravação de imagem');
    end;

    Res.Send(TJsonObject.Create.AddPair('message', 'Ok').ToJSON).Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;

end;

procedure DoPutStreamDoc(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LStream: TMemoryStream;
  FullPath: string;
begin

  FullPath := CreateDirIfNotExists(ExtractFileDir(ParamStr(0)) + '\static\' + Req.Params['id']);
  LStream := Req.Body<TMemoryStream>;
  LStream.SaveToFile(FullPath + '\fotorosto.jpg');
  Res.Send(TJsonObject.Create.AddPair('message', 'Ok').ToJSON).Status(THTTPStatus.Created);

end;

procedure Registry;
begin
  THorse.Get('/carteiras', DoList);
  THorse.Get('/carteiras/:id', DoGet);
  THorse.Post('/carteiras', DoPost);
  THorse.Put('/carteiras/:id', DoUpdate);
  THorse.Delete('/carteiras/:id', DoDelete);
  THorse.Get('/carteiras/:id/static/foto', DoGetStreamFoto);
  THorse.Put('/carteiras/:id/static/foto', DoPutStreamFoto);
  //precisa ser implementado, atualmente é a cópia da foto
  THorse.Get('/carteiras/:id/static/doc', DoGetStreamDoc);
  THorse.Put('/carteiras/:id/static/doc', DoPutStreamDoc);
end;

end.
