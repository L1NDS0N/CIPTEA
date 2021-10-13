unit Controllers.Auth;

interface

uses
  Configs.GLOBAL, Data.DB;

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
  senha: string;
begin
  LService := TServiceUser.Create(nil);
  try
    LData := Req.Body<TJsonObject>;

    email := LData.GetValue<string>('email').Trim;

    if LData.TryGetValue('nome', nome) then
      begin
        nome := nome.Trim;

        if nome = EmptyStr then
          raise EHorseException.Create(THTTPStatus.BadRequest, 'Nome não encontrado');

        if (Length(nome) < 3) then
          raise EHorseException.Create(THTTPStatus.BadRequest, 'Nome muito curto, mínimo 3 caracteres');
      end
    else
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Nome não encontrado');

    if LData.TryGetValue('senha', senha) then
      begin
        if senha = EmptyStr then
          raise EHorseException.Create(THTTPStatus.BadRequest, 'Senha não encontrada');

        if (Length(senha) < 5) then
          raise EHorseException.Create(THTTPStatus.BadRequest, 'Senha muito curta, mínimo 5 caracteres');

        LHash := TBCrypt.GenerateHash(senha);
        LData.RemovePair('senha');
        LData.AddPair('senha', LHash);
      end
    else
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Senha não encontrada');

    if NOT(LService.GetByFieldValue('nome', nome).IsEmpty) then
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Usuário com esse nome já existe ');

    LData.RemovePair('nome');
    LData.RemovePair('email');
    LData.RemovePair('senha');

    LData.AddPair('nome', nome);
    LData.AddPair('email', email);
    LData.AddPair('senha', LHash);

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

procedure DoUpdate(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService: TServiceUser;
  LData: TJsonObject;
  Aid: integer;
  nome: string;
  LHash: string;
  senha: string;
label
  CanUpdate;
begin
  LService := TServiceUser.Create(nil);
  try
    LData := Req.Body<TJsonObject>;
    Aid := Req.Params.Items['id'].ToInteger;

    if LData.TryGetValue('nome', nome) then
      begin
        nome := nome.Trim;

        if nome = EmptyStr then
          raise EHorseException.Create(THTTPStatus.BadRequest, 'Nome não encontrado');

        if (Length(nome) < 3) then
          raise EHorseException.Create(THTTPStatus.BadRequest, 'Nome muito curto, mínimo 3 caracteres');
      end
    else
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Nome não encontrado');

    if LData.TryGetValue('senha', senha) then
      begin
        if senha = EmptyStr then
          raise EHorseException.Create(THTTPStatus.BadRequest, 'Senha não encontrada');

        if (Length(senha) < 5) then
          raise EHorseException.Create(THTTPStatus.BadRequest, 'Senha muito curta, mínimo 5 caracteres');

        LHash := TBCrypt.GenerateHash(senha);
        LData.RemovePair('senha');
        LData.AddPair('senha', LHash);
      end
    else
      raise EHorseException.Create(THTTPStatus.BadRequest, 'Senha não encontrada');

    if not(LService.GetByFieldValue('nome', nome).IsEmpty) then
      begin
        if (LService.qryPesquisaUsuario.FieldByName('id').AsInteger <> Aid) then
          raise EHorseException.Create(THTTPStatus.BadRequest, 'Este nome de usuário já existe')
        else
          goto CanUpdate;
      end
    else
      goto CanUpdate;

    CanUpdate:
    begin
      if LService.Update(LData, Aid) then
        Res.Send(LService.qryCadastroUsuario.ToJSONObject).Status(THTTPStatus.OK);
    end;

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
  THorse.Put('/register/:id', Authorization(), DoUpdate);
  THorse.Post('/authenticate', DoAuth);
  THorse.Get('/healthcheck', Authorization(), DoCheck);
end;

end.
