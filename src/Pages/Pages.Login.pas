unit Pages.Login;

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
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Layouts,
  System.ImageList,
  FMX.ImgList,
  FMX.Edit,
  FMX.Ani,
  FMX.Effects,
  Router4D.Interfaces;

type
  TPageLogin = class(TForm, iRouter4DComponent)
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
    procedure btnLoginClick(Sender: TObject);
    private

    public
      function Render: TFmxObject;
      procedure UnRender;
  end;

var
  PageLogin: TPageLogin;

implementation

uses
  Services.User,
  Router4D;

{$R *.fmx}
{ TPageLogin }

procedure TPageLogin.btnLoginClick(Sender: TObject);
var
  LService: TServiceUser;
begin
  LService := TServiceUser.Create(nil);
  try
    if LService.EfetuarLogin(edtUser.Text, edtPass.Text, cbManterConectado.IsChecked) then
      TRouter4d.Link.&To('Dashboard');
  finally
    LService.Free;
  end;
end;

function TPageLogin.Render: TFmxObject;
begin
  Result := lytBackground;
end;

procedure TPageLogin.UnRender;
begin

end;

end.
