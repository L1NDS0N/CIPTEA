unit Services.Auth;

interface

uses
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
  Configs.GLOBAL;

type
  TServiceAuth = class(TDataModule)
    qryUsuario: TFDQuery;
    qryUsuarioid: TIntegerField;
    qryUsuarioNome: TStringField;
    qryUsuarioToken: TStringField;
    qryUsuarioStayConected: TBooleanField;
    qryUsuarioTokenCreatedAt: TIntegerField;
    qryUsuarioTokenExpires: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    private
      config: TConfigGlobal;
    public
      function EfetuarLogin(Usuario, Senha: string; StayConected: boolean): boolean;
  end;

var
  ServiceAuth: TServiceAuth;

implementation

uses
  RestRequest4d,
  DataSet.serialize,
  Services.LocalConnection,
  System.JSON,
  System.SysUtils;

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

procedure TServiceAuth.DataModuleCreate(Sender: TObject);
begin
  qryUsuario.Connection := TServiceLocalConnection.Create(Self).LocalConnection;
end;

function TServiceAuth.EfetuarLogin(Usuario, Senha: string; StayConected: boolean): boolean;
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New.BaseURL(config.BaseURL).addbody(TJsonObject.Create.AddPair('nome', Usuario.Trim)
      .AddPair('senha', Senha)).resource('authenticate').post;
  if LResponse.StatusCode in [200, 201, 204] then
    begin
      Result := true;
      LResponse.JSONValue.AsType<TJsonObject>.AddPair('StayConected', TJSONBool.Create(StayConected));

      qryUsuario.Close;
      qryUsuario.Open;
      if qryUsuario.IsEmpty then
        qryUsuario.LoadFromJSON(LResponse.JSONValue.ToJSON)
      else
        qryUsuario.MergeFromJSONObject(LResponse.JSONValue.ToJSON);
    end
  else
    begin
      Result := false;
      raise Exception.Create(LResponse.JSONValue.GetValue<string>('error'));
    end;
end;

end.
