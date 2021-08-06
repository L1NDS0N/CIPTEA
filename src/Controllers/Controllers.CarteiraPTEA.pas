unit Controllers.CarteiraPTEA;

interface

uses
  Horse,
  Horse.Commons,
  System.JSON,
  System.SysUtils,
  Dataset.Serialize;

procedure Registry;

implementation

uses
  Services.CarteiraPTEA;

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

procedure Registry;
begin
  THorse.Get('/carteiras', DoList);
  THorse.Get('/carteiras/:id', DoGet);
  THorse.Post('/carteiras', DoPost);
  THorse.Put('/carteiras/:id', DoUpdate);
  THorse.Delete('/carteiras/:id', DoDelete);
end;

end.
