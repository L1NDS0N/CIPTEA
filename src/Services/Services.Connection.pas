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
  FireDAC.FMXUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  Configs.GLOBAL;

type
  TServiceConnection = class(TDataModule)
    LocalConnection: TFDConnection;
    procedure LocalConnectionBeforeConnect(Sender: TObject);
    private
      Config: TConfigGlobal;
    public
      { Public declarations }
  end;

var
  ServiceConnection: TServiceConnection;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

procedure TServiceConnection.LocalConnectionBeforeConnect(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  LocalConnection.Params.Values['Database'] := Config.DBDir;
  {$ENDIF}
end;

end.
