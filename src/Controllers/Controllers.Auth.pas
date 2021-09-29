unit Controllers.Auth;

interface

uses
  Configs.GLOBAL;

procedure Registry;

var
  Config: TConfigGlobal;

implementation

uses
  Jose.Core.JWT,
  Jose.Core.Builder,
  System.SysUtils,
  Horse.HTTP,
  Horse,
  bcrypt,
  Dataset.Serialize,
  Services.User,
  Jose.Types.JSON;

function GenerateToken(Aid: integer): string;
var
  LToken: TJWT;
  LCompactToken: string;
begin
  LToken := TJWT.Create;
  try
    //Token claims
    LToken.Claims.Subject := Aid.ToString;
    LToken.Claims.Expiration := IncMonth(Now);

    //Signing and Compact format creation
    LCompactToken := TJOSE.SHA256CompactToken(Config.Secret, LToken);
    Result := LCompactToken;
  finally
    LToken.Free;
  end;

end;

procedure DoCreate(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService: TServiceUser;
  LData: TJsonObject;
  email: string;
  nome: string;
  LHash: string;
begin
  LService := TServiceUser.Create(nil);
  try
    LData := Req.Body<TJsonObject>;

    email := LData.GetValue<string>('email').Trim;
    nome := LData.GetValue<string>('nome').Trim;
    LHash := TBCrypt.GenerateHash(LData.GetValue<string>('senha'));

    LData.RemovePair('nome');
    LData.RemovePair('email');
    LData.RemovePair('senha');

    LData.AddPair('nome', nome);
    LData.AddPair('email', email);
    LData.AddPair('senha', LHash);

    if NOT(LService.GetByFieldValue('nome', nome).IsEmpty) then
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Usuário com esse nome já existe ');

    if NOT(LService.GetByFieldValue('email', email).IsEmpty) then
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Usuário com esse e-mail já existe');

    if LService.Append(LData) then
      begin
        LService.qryCadastroUsuario.FieldByName('senha').Visible := false;

        Res.Send(LService.qryCadastroUsuario.ToJSONObject.AddPair('Token',
            GenerateToken(LService.qryCadastroUsuario.FieldByName('id').AsInteger)).AddPair('TokenCreatedAt',
            DateTimeToStr(Now)).AddPair('TokenExpires', DateTimeToStr(IncMonth(Now)))).Status(THTTPStatus.Created);
      end;

  finally
    LService.Free;
  end;
end;

function UserIsValid(Username, Password: string): boolean;
var
  LService: TServiceUser;
begin
  LService := TServiceUser.Create(nil);
  try
    if not(LService.GetByFieldValue('nome', Username).IsEmpty) then
      begin
        Result := TBCrypt.CompareHash(Password, LService.qryPesquisaUsuario.FieldByName('senha').AsString);
      end
    else
      Result := false;
  finally
    LService.Free;
  end;
end;

procedure DoAuth(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService: TServiceUser;
  LData: TJsonObject;
  nome: string;
  senha: string;
begin
  LService := TServiceUser.Create(nil);
  try
    LData := Req.Body<TJsonObject>;

    nome := LData.GetValue<string>('nome').Trim;
    senha := LData.GetValue<string>('senha');

    if UserIsValid(nome, senha) then
      Res.Send(TJsonObject.Create.AddPair('nome', nome).AddPair('token',
          GenerateToken(LService.qryPesquisaUsuario.FieldByName('id').AsInteger)).AddPair('TokenCreatedAt',
          DateTimeToStr(Now)).AddPair('TokenExpires', DateTimeToStr(IncMonth(Now)))).Status(THTTPStatus.Created)
    else
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Usuário ou senha incorreto');
  finally
    LService.Free;
  end;

end;

procedure Registry;
begin
  THorse.Post('/register', DoCreate);
  THorse.Post('/authenticate', DoAuth);
end;

end.
