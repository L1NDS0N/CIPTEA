unit Services.Connection;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.ConsoleUI.Wait,
  FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL,
  Data.DB,
  FireDAC.Comp.Client,
  Configs.GLOBAL;

type
  TServiceConnection = class(TDataModule)
    FDConnection: TFDConnection;
    FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
    procedure FDConnectionBeforeConnect(Sender: TObject);
    private
      Config: TConfigGlobal;
    public
      { Public declarations }
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

procedure TServiceConnection.FDConnectionBeforeConnect(Sender: TObject);
var
  Params: TFDPhysMySQLConnectionDefParams;
begin
  {$IFDEF MSWINDOWS}

  FDPhysMySQLDriverLink.VendorLib := ExtractFileDir(ParamStr(0)) + '\lib\libmySQL.dll';

  Params := TFDPhysMySQLConnectionDefParams(FDConnection.Params);
  Params.Database := Config.DBName;
  Params.UserName := Config.DBUsername;
  Params.Password := Config.DBPassword;
  Params.Server := Config.DBServer;
  Params.Port := Config.DBPort;
  {$ENDIF}
end;

end.
