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
  FMX.Ani, FMX.Effects;

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
    procedure InicializarMenuPrincipal;
    procedure btnLoginClick(Sender: TObject);
    private
      { Private declarations }
    public
      { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.btnLoginClick(Sender: TObject);
begin
  InicializarMenuPrincipal;
end;

procedure TfrmMain.InicializarMenuPrincipal;
begin
  CriaPacote('Pages');
  frmMain.Visible := false;
  AbreFormulario('TPagePrincipal');
  frmMain.Visible := true;
end;

end.
