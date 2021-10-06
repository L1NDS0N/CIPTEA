unit Pages.Config;

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
  FMX.Layouts,
  FMX.Objects,
  FMX.Effects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  Router4D.Interfaces,
  FMX.Ani;

type
  TPageConfig = class(TForm, iRouter4dcomponent)
    rect_novousuario: TRectangle;
    HorzScrollBox: THorzScrollBox;
    lytModal: TLayout;
    Line1: TLine;
    ShadowEffect1: TShadowEffect;
    rect_modal: TRectangle;
    IconUser: TPath;
    lblNovoUsuario: TLabel;
    lytPageConfig: TLayout;
    ColorAnimation1: TColorAnimation;
    rect_atualizarusuario: TRectangle;
    Line2: TLine;
    IconAtualizarUsuario: TPath;
    ShadowEffect3: TShadowEffect;
    lblAtualizarUsuario: TLabel;
    ColorAnimation2: TColorAnimation;
    lytHeader: TLayout;
    Label1: TLabel;
    btnVoltar: TRectangle;
    ColorAnimation3: TColorAnimation;
    lblBtnVoltar: TLabel;
    ColorAnimation4: TColorAnimation;
    rect_configlocal: TRectangle;
    Line3: TLine;
    Path1: TPath;
    ShadowEffect2: TShadowEffect;
    Label2: TLabel;
    ColorAnimation5: TColorAnimation;
    FloatAnimation1: TFloatAnimation;
    FloatAnimation2: TFloatAnimation;
    FloatAnimation3: TFloatAnimation;
    FloatAnimation4: TFloatAnimation;
    procedure rect_novousuarioClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure rect_atualizarusuarioClick(Sender: TObject);
    private
      { Private declarations }
    public
      function Render: TFmxObject;
      procedure Unrender;
  end;

var
  PageConfig: TPageConfig;

implementation

uses
  Router4D.Props,
  Providers.PrivateRoute,
  ToastMessage,
  Router4D;

{$R *.fmx}
{ TPageConfig }

procedure TPageConfig.btnVoltarClick(Sender: TObject);
begin
  try
    TRouter4D.Link.&To('Dashboard');
  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para a página principal - ' + E.Message, ttDanger);
  end;
end;

procedure TPageConfig.rect_atualizarusuarioClick(Sender: TObject);
begin
  try
    OpenPrivateRoute('NewUser', TProps.create.PropString('edit').Key('IdUserToUpdate'));
  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para a página de edição de usuário - ' + E.Message, ttDanger);
  end;
end;

procedure TPageConfig.rect_novousuarioClick(Sender: TObject);
begin
  try
    OpenPrivateRoute('NewUser');
  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para a página de novo usuário - ' + E.Message, ttDanger);
  end;
end;

function TPageConfig.Render: TFmxObject;
begin
  Result := lytPageConfig;
end;

procedure TPageConfig.Unrender;
begin

end;

end.
