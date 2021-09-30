unit Controllers.Auth;

interface

uses
  Configs.GLOBAL;

procedure Registry;

var
  Config: TConfigGlobal;

implementation

uses
  Providers.Authorization,
  Utils.tools,
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
            MyTimestamp(Now)).AddPair('TokenExpires', MyTimestamp(IncMonth(Now)))).Status(THTTPStatus.Created);
      end;

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
    //valida campos
    if not(LService.GetByFieldValue('nome', nome).IsEmpty) then
      begin
        if TBCrypt.CompareHash(senha, LService.qryPesquisaUsuario.FieldByName('senha').AsString) then
          begin
            LService.qryPesquisaUsuario.FieldByName('senha').Visible := false;
            LService.qryPesquisaUsuario.FieldByName('email').Visible := false;
            LService.qryPesquisaUsuario.FieldByName('criadoem').Visible := false;
            LService.qryPesquisaUsuario.FieldByName('alteradoem').Visible := false;

            Res.Send(LService.qryPesquisaUsuario.ToJSONObject.AddPair('token',
                GenerateToken(LService.qryPesquisaUsuario.FieldByName('id').AsInteger)).AddPair('TokenCreatedAt',
                TJsonNumber.Create(MyTimestamp(Now))).AddPair('TokenExpires',
                TJsonNumber.Create(MyTimestamp(IncMonth(Now))))).Status(THTTPStatus.OK);
          end
        else
          raise EHorseException.Create(THTTPStatus.BadRequest, 'O valor fornecido no campo de Senha está incorreto');
      end
    else
      raise EHorseException.Create(THTTPStatus.BadRequest, 'O valor fornecido no campo de Usuário está incorreto');

  finally
    LService.Free;
  end;

end;

procedure DoCheck(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Status(THTTPStatus.NoContent);
end;

procedure Registry;
begin
  THorse.Post('/register', DoCreate);
  THorse.Post('/authenticate', DoAuth);
  THorse.Get('/healthcheck', Authorization(), DoCheck);
end;

end.
