unit Services.LocalConnection;

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
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  FireDAC.VCLUI.Wait,
  Configs.GLOBAL;

type
  TServiceLocalConnection = class(TDataModule)
    LocalConnection: TFDConnection;
    procedure LocalConnectionBeforeConnect(Sender: TObject);
    private
      Config: TConfigGlobal;
    public
      { Public declarations }
  end;

var
  ServiceLocalConnection: TServiceLocalConnection;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

procedure TServiceLocalConnection.LocalConnectionBeforeConnect(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  LocalConnection.Params.Values['Database'] := Config.DbDir;
  {$ENDIF}
end;

end.
