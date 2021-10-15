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
    edtDB: TEdit;
    ClearEditButton1: TClearEditButton;
    lblDB: TLabel;
    EllipsesEditButton1: TEllipsesEditButton;
    dlgDB: TOpenDialog;
    EditButton1: TEditButton;
    EditButton2: TEditButton;
    procedure retBtnSalvarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure EllipsesEditButton1Click(Sender: TObject);
    procedure EditButton2Click(Sender: TObject);
    procedure EditButton1Click(Sender: TObject);
    private
      Config: TConfigGlobal;
      procedure SyncInfoFromEnvironment;
      procedure EfetuarPing;

    public
      function Render: TFmxObject;
      procedure UnRender;

  end;

var
  PageNetConfig: TPageNetConfig;

implementation

uses
  Router4D,
  ToastMessage,
  Services.User;
{$R *.fmx}
{ TPageNetConfig }

procedure TPageNetConfig.btnVoltarClick(Sender: TObject);
begin
  TRouter4D.Link.&To('Config');
end;

procedure TPageNetConfig.EditButton1Click(Sender: TObject);
begin
  EfetuarPing;
end;

procedure TPageNetConfig.EditButton2Click(Sender: TObject);
begin
  EfetuarPing;
end;

procedure TPageNetConfig.EllipsesEditButton1Click(Sender: TObject);
begin
  dlgDB.InitialDir := ExtractFileDir(Config.DBDir);
  if dlgDB.Execute then
    begin
      edtDB.Text := dlgDB.FileName;
    end;
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
  if edtDB.Text <> EmptyStr then
    if FileExists(edtDB.Text) then
      SetEnvironmentVar('CIPTEA_DBDIR', edtDB.Text);
  TToastMessage.show('Feche e abra novamente o aplicativo para que as alterações tenham efeito', ttWarning);
end;

procedure TPageNetConfig.SyncInfoFromEnvironment;
begin
  edtHost.Text := Config.BaseHost;
  edtPort.Text := Config.BasePort;
  edtDB.TextPrompt := Config.DBDir;
end;

procedure TPageNetConfig.UnRender;
begin

end;

procedure TPageNetConfig.EfetuarPing;
var
  LService: TServiceUser;
begin
  LService := TServiceUser.Create(nil);
  try
    try
      if LService.EfetuarPing('http://' + edtHost.Text + ':' + edtPort.Text).StatusCode = 204 then
        TToastMessage.show('Conexão estabelecida com sucesso!', ttSuccess);
    except
      on E: Exception do
        TToastMessage.show(E.Message, ttWarning);
    end;
  finally
    LService.Free;
  end;
end;

end.
