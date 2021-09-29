unit FormMain;

interface

uses
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
  FMX.Controls.Presentation,
  Providers.PackageBuilder,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Layouts,
  System.ImageList,
  FMX.ImgList,
  FMX.Edit,
  FMX.Ani,
  FMX.Effects;

type
  TfrmMain = class(TForm)
    lytBackground: TLayout;
    rctBackground: TRectangle;
    lytPrincipal: TLayout;
    lytModalLogin: TLayout;
    rctLoginField: TRectangle;
    btnLogin: TSpeedButton;
    edtUser: TEdit;
    edtPass: TEdit;
    cbManterConectado: TCheckBox;
    rctUser: TRectangle;
    rctPass: TRectangle;
    RectAnimation1: TRectAnimation;
    rctLogin: TRectangle;
    lytIconUser: TLayout;
    IconUser: TPath;
    lytIconPass: TLayout;
    IconPass: TPath;
    imgLogo: TImage;
    lblTitulo: TLabel;
    lytTitulo: TLayout;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    PasswordEditButton1: TPasswordEditButton;
    procedure InicializarMenuPrincipal;
    procedure cbManterConectadoChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    private

    public
      { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Services.Auth;

{$R *.fmx}

procedure TfrmMain.btnLoginClick(Sender: TObject);
var
  LService: TServiceAuth;
begin
  LService := TServiceAuth.Create(nil);
  try
    LService.EfetuarLogin(edtUser.Text, edtPass.Text);
  finally
    LService.Free;
  end;
  InicializarMenuPrincipal;

end;

procedure TfrmMain.cbManterConectadoChange(Sender: TObject);
var
  LService: TServiceAuth;
begin
  LService := TServiceAuth.Create(nil);
  try
    LService.qryUsuario.Close;
    LService.qryUsuario.Open;
    if not(LService.qryUsuario.IsEmpty) then
      begin
        LService.qryUsuario.Edit;
        LService.qryUsuarioStayConected.Value := cbManterConectado.IsChecked;
        LService.qryUsuario.Post;
      end;
  finally
    LService.Free;
  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  LService: TServiceAuth;
begin
  LService := TServiceAuth.Create(nil);
  try
    LService.qryUsuario.Close;
    LService.qryUsuario.Open;
    if LService.qryUsuarioStayConected.AsBoolean then
      InicializarMenuPrincipal;
  finally
    LService.Free;
  end;

end;

procedure TfrmMain.InicializarMenuPrincipal;
begin
  CriaPacote('Pages');
  frmMain.Visible := false;
  AbreFormulario('TPagePrincipal');
  frmMain.Visible := true;
end;

end.
