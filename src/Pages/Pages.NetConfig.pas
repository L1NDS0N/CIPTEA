unit Pages.NetConfig;

interface

uses
  Configs.GLOBAL,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Effects,
  FMX.Objects,
  FMX.Ani,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.Controls.Presentation,
  FMX.Layouts,
  Router4D.Interfaces;

type
  TPageNetConfig = class(TForm, iRouter4DComponent)
    lytNetConfig: TLayout;
    lytInterno: TLayout;
    VertScrollBox: TVertScrollBox;
    edtHost: TEdit;
    ClearEditButton8: TClearEditButton;
    edtPort: TEdit;
    ClearEditButton3: TClearEditButton;
    lblHost: TLabel;
    lblPort: TLabel;
    lytHeader: TLayout;
    lblTitle: TLabel;
    btnVoltar: TRectangle;
    ColorAnimation2: TColorAnimation;
    ColorAnimation3: TColorAnimation;
    FloatAnimation4: TFloatAnimation;
    iconVoltar: TPath;
    retBtnSalvar: TRectangle;
    ColorAnimation1: TColorAnimation;
    lblSalvar: TLabel;
    ShadowEffect1: TShadowEffect;
    procedure retBtnSalvarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    private
      Config: TConfigGlobal;
      procedure SyncInfoFromEnvironment;
      procedure SetEnvironmentVar(aEnvVar, aValue: string);

    public
      function Render: TFmxObject;
      procedure UnRender;

  end;

var
  PageNetConfig: TPageNetConfig;

implementation

uses
  Winapi.ShellAPI,
  Winapi.Windows,
  Router4D,
  Winapi.Messages, ToastMessage;
{$R *.fmx}
{ TPageNetConfig }

procedure TPageNetConfig.btnVoltarClick(Sender: TObject);
begin
  TRouter4D.Link.&To('Config');
end;

function TPageNetConfig.Render: TFmxObject;
begin
  Result := lytNetConfig;

  Self.SyncInfoFromEnvironment;
end;

procedure TPageNetConfig.retBtnSalvarClick(Sender: TObject);
begin
  SetEnvironmentVar('CIPTEA_HOST', edtHost.Text);
  SetEnvironmentVar('CIPTEA_PORT', edtPort.Text);
end;

procedure TPageNetConfig.SetEnvironmentVar(aEnvVar, aValue: string);
var
  cmdline: string;
begin
  cmdline := '/C setx ' + aEnvVar + ' ' + aValue;
  ShellExecute(0, nil, 'cmd.exe', PChar(cmdline), nil, SW_HIDE);
  SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0, NativeInt(PChar('Environment')), SMTO_ABORTIFHUNG, 5000, nil);
  TToastmessage.show('Feche e abra novamente o aplicativo para que as alterações tenham efeito', ttWarning);
end;

procedure TPageNetConfig.SyncInfoFromEnvironment;
begin
  edtHost.Text := Config.BaseHost;
  edtPort.Text := Config.BasePort;
end;

procedure TPageNetConfig.UnRender;
begin

end;

end.
