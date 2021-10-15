unit Services.User;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Configs.GLOBAL,
  Services.Connection,
  RESTRequest4D;

type
  TServiceUser = class(TDataModule)
    qryUsuarioLocal: TFDQuery;
    qryUsuarioLocalid: TIntegerField;
    qryUsuarioLocalNome: TStringField;
    qryUsuarioLocalToken: TStringField;
    qryUsuarioLocalStayConected: TBooleanField;
    qryUsuarioLocalTokenCreatedAt: TIntegerField;
    qryUsuarioLocalTokenExpires: TIntegerField;
    mtUsuario: TFDMemTable;
    mtUsuarioid: TIntegerField;
    mtUsuarionome: TStringField;
    mtUsuarioemail: TStringField;
    mtUsuariosenha: TStringField;
    qryUsuarioLocalEmail: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    private
      Config: TConfigGlobal;
    public
      function SalvarNovoUsuario: boolean;
      function EfetuarLogin(Usuario, Senha: string; StayConected: boolean): boolean;
      function EfetuarPing(aURL: string): IResponse;
      procedure DownloadDatabase;
  end;

implementation

uses
  DataSet.serialize,
  System.JSON,
  FMX.Dialogs;

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

procedure TServiceUser.DataModuleCreate(Sender: TObject);
var
  Connection: TServiceConnection;
begin
  Connection := TServiceConnection.Create(Self);
  qryUsuarioLocal.Connection := Connection.LocalConnection;
end;

function TServiceUser.SalvarNovoUsuario: boolean;
var
  LRequest: IRequest;
  LResponse: IResponse;
begin
  try
    qryUsuarioLocal.Close;
    qryUsuarioLocal.Open;

    LRequest := TRequest.New.BaseURL(Config.BaseURL).TokenBearer(qryUsuarioLocalToken.Value).Resource('register')
      .addbody(mtUsuario.ToJSONObject);

    if (mtUsuarioid.AsInteger > 0) then
      begin
        LResponse := LRequest.ResourceSuffix(mtUsuarioid.AsString).Put;
        qryUsuarioLocal.MergeFromJSONObject(LResponse.JSONValue.ToJSON);
      end
    else
      LResponse := LRequest.Post;
  finally
    if LResponse.StatusCode in [200, 201, 204] then
      begin
        Result := true;
      end
    else if LResponse.StatusCode = 401 then
      begin
        Result := false;
        raise Exception.Create('Atualmente voc� n�o possui autoriza��o para gravar os dados.')
      end
    else
      begin
        Result := false;
        raise Exception.Create('Erro durante grava��o dos dados do usu�rio - Erro #' + LResponse.StatusCode.ToString +
            ', ' + LResponse.JSONValue.GetValue<string>('error'));
      end;
  end;

end;

procedure TServiceUser.DownloadDatabase;
var
  LResponse: IResponse;
  LStream: TMemoryStream;
  err: string;
  fileExistsName: string;
  counter: integer;
begin
  counter := 1;
  LStream := TMemoryStream.Create;
  try
    try

      LResponse := TRequest.New.BaseURL(Config.BaseURL).RaiseExceptionOn500(true).Resource('downloads/db').Get;
      if LResponse.StatusCode = 200 then
        begin
          LStream.LoadFromStream(LResponse.ContentStream);

          fileExistsName := ExtractFileDir(ParamStr(0)) + '\db\CIPTEA.db3';
          while FileExists(fileExistsName) do
            begin
              counter := counter + 1;
              fileExistsName := ExtractFileDir(ParamStr(0)) + '\db\CIPTEA' + counter.ToString + '.db3';
            end;

          LStream.SaveToFile(fileExistsName);
          if FileExists(fileExistsName) then
            begin
              showmessage(fileExistsName);
              SetEnvironmentVar('CIPTEA_DBDIR', fileExistsName);
            end;
        end
      else
        begin
          if LResponse.JSONValue.TryGetValue('error', err) then
            raise Exception.Create(err);
        end;
    except
      on E: Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    LStream.Free;
  end;
end;

function TServiceUser.EfetuarLogin(Usuario, Senha: string; StayConected: boolean): boolean;
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New.BaseURL(Config.BaseURL).addbody(TJsonObject.Create.AddPair('nome', Usuario.Trim)
      .AddPair('senha', Senha)).Resource('authenticate').Post;
  if LResponse.StatusCode in [200, 201, 204] then
    begin
      Result := true;
      LResponse.JSONValue.AsType<TJsonObject>.AddPair('StayConected', TJSONBool.Create(StayConected));

      qryUsuarioLocal.Close;
      qryUsuarioLocal.Open;
      if qryUsuarioLocal.IsEmpty then
        qryUsuarioLocal.LoadFromJSON(LResponse.JSONValue.ToJSON)
      else
        qryUsuarioLocal.MergeFromJSONObject(LResponse.JSONValue.ToJSON);
    end
  else
    begin
      Result := false;
      raise Exception.Create(LResponse.JSONValue.GetValue<string>('error'));
    end;

end;

function TServiceUser.EfetuarPing(aURL: string): IResponse;
begin
  try
    Result := TRequest.New.BaseURL(aURL).Resource('connectivity').RaiseExceptionOn500(true).Get;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

end.
