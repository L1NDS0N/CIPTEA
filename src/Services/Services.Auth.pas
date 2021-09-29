unit Services.Auth;

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
  Configs.GLOBAL;

type
  TServiceAuth = class(TDataModule)
    qryUsuario: TFDQuery;
    qryUsuarioId: TIntegerField;
    qryUsuarioNome: TStringField;
    qryUsuarioToken: TStringField;
    qryUsuarioRefreshToken: TStringField;
    qryUsuarioTokenExpires: TSQLTimeStampField;
    qryUsuarioStayConected: TBooleanField;
    procedure DataModuleCreate(Sender: TObject);
    private
      config: TConfigGlobal;
    public
      function EfetuarLogin(Usuario, Senha: string): boolean;
  end;

var
  ServiceAuth: TServiceAuth;

implementation

uses
  RestRequest4d,
  Services.LocalConnection,
  System.JSON,
  FMX.Dialogs;

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

procedure TServiceAuth.DataModuleCreate(Sender: TObject);
begin
  qryUsuario.Connection := TServiceLocalConnection.Create(Self).LocalConnection;
end;

function TServiceAuth.EfetuarLogin(Usuario, Senha: string): boolean;
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New.BaseURL(config.BaseURL).addbody(TJsonObject.Create.AddPair('nome', Usuario.Trim)
      .AddPair('senha', Senha)).resource('authenticate').post;
  ShowMessage(LResponse.Content);
end;

end.
