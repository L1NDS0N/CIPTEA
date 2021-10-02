unit Pages.NewUser;

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
  FMX.Effects,
  FMX.Ani,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.DateTimeCtrls,
  FMX.Edit,
  FMX.Controls.Presentation,
  FMX.Layouts,
  Router4D.Interfaces;

type
  TPageNewUser = class(TForm, iRouter4DComponent)
    lytNewUser: TLayout;
    lytInterno: TLayout;
    VertScrollBox: TVertScrollBox;
    edtSenha: TEdit;
    ClearEditButton2: TClearEditButton;
    edtConfirmarSenha: TEdit;
    ClearEditButton1: TClearEditButton;
    edtNomeUsuario: TEdit;
    ClearEditButton8: TClearEditButton;
    edtEmail: TEdit;
    ClearEditButton3: TClearEditButton;
    lblSenha: TLabel;
    lblConfirmarSenha: TLabel;
    lblNomeUsuario: TLabel;
    lblEmail: TLabel;
    lytHeader: TLayout;
    Label1: TLabel;
    btnVoltar: TRectangle;
    ColorAnimation2: TColorAnimation;
    lblBtnVoltar: TLabel;
    ColorAnimation3: TColorAnimation;
    FloatAnimation: TFloatAnimation;
    retBtnSalvar: TRectangle;
    ColorAnimation1: TColorAnimation;
    lblSalvar: TLabel;
    ShadowEffect1: TShadowEffect;
    PasswordEditButton1: TPasswordEditButton;
    PasswordEditButton2: TPasswordEditButton;
    procedure btnVoltarClick(Sender: TObject);
    procedure edtEmailExit(Sender: TObject);
    procedure retBtnSalvarClick(Sender: TObject);
    private
      procedure ValidarCampos;
    public
      function Render: TFmxObject;
      procedure UnRender;
  end;

var
  PageNewUser: TPageNewUser;

implementation

uses
  Providers.PrivateRoute,
  Utils.Tools,
  ToastMessage,
  Services.User;

{$R *.fmx}

procedure TPageNewUser.btnVoltarClick(Sender: TObject);
begin
  try
    OpenPrivateRoute('Dashboard');
  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para a página principal - ' + E.Message, ttDanger);
  end;
end;

procedure TPageNewUser.edtEmailExit(Sender: TObject);
begin
  ValidarCampos;
end;

function TPageNewUser.Render: TFmxObject;
begin
  Result := lytNewUser;
end;

procedure TPageNewUser.retBtnSalvarClick(Sender: TObject);
var
  LService: TServiceUser;
begin
  LService := TServiceUser.Create(nil);
  Self.ValidarCampos;
  try
    LService.mtUsuarionome.Value := edtNomeUsuario.Text;
    LService.mtUsuarioemail.Value := edtEmail.Text;
    LService.mtUsuariosenha.Value := edtSenha.Text;

    if LService.SalvarNovoUsuário then
      TToastMessage.show('Novo usuário salvo com sucesso!', ttSuccess);

  finally
    LService.Free;
  end;
end;

procedure TPageNewUser.UnRender;
begin

end;

procedure TPageNewUser.ValidarCampos;
begin
  with edtEmail do
    begin
      if NOT(Text.IsEmpty) AND not(EmailIsValid(Text)) then
        begin
          TToastMessage.show('O valor (' + Text + ') inserido no campo de e-mail é inválido ', ttWarning);
          abort;
        end;
    end;

  if edtSenha.Text <> edtConfirmarSenha.Text then
    begin
      TToastMessage.show('As senhas inseridas não correspondem', ttWarning);
      abort;
    end;
end;

end.
