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
  Router4D.Interfaces,
  Router4D.Props;

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
      procedure NavegarPara(const ALocation: string; const AProps: TProps = nil);
    public
      function Render: TFmxObject;
      procedure UnRender;
  end;

var
  PageLogin: TPageLogin;

implementation

uses
  Providers.PrivateRoute,
  Services.User,
  ToastMessage;

{$R *.fmx}
{ TPageLogin }

procedure TPageLogin.btnLoginClick(Sender: TObject);
var
  LService: TServiceUser;
begin
  LService := TServiceUser.Create(nil);
  try
    if LService.EfetuarLogin(edtUser.Text, edtPass.Text, cbManterConectado.IsChecked) then
      NavegarPara('Dashboard');
  finally
    LService.Free;
  end;
end;

procedure TPageLogin.NavegarPara(const ALocation: string; const AProps: TProps);
begin
  try
    OpenPrivateRoute(ALocation, AProps);
  except
    on E: Exception do
      TToastmessage.show(E.Message, ttDanger);
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
