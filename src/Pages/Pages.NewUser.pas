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
  Router4D.Interfaces,
  Router4D.Props,
  Services.User;

type
  TPageNewUser = class(TForm, iRouter4DComponent)
    lytNewUser: TLayout;
    lytInterno: TLayout;
    VertScrollBox: TVertScrollBox;
    edtNovaSenha: TEdit;
    ClearEditButton2: TClearEditButton;
    edtConfirmarNovaSenha: TEdit;
    ClearEditButton1: TClearEditButton;
    edtNomeUsuario: TEdit;
    ClearEditButton8: TClearEditButton;
    edtEmail: TEdit;
    ClearEditButton3: TClearEditButton;
    lblNovaSenha: TLabel;
    lblConfirmarNovaSenha: TLabel;
    lblNomeUsuario: TLabel;
    lblEmail: TLabel;
    lytHeader: TLayout;
    lblTitle: TLabel;
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
    FloatAnimation4: TFloatAnimation;
    edtSenhaAtual: TEdit;
    ClearEditButton4: TClearEditButton;
    PasswordEditButton3: TPasswordEditButton;
    lblSenhaAtual: TLabel;
    cbAlterarSenha: TCheckBox;
    lytNovasSenhas: TLayout;
    lytSenhaAtual: TLayout;
    procedure btnVoltarClick(Sender: TObject);
    procedure edtEmailExit(Sender: TObject);
    procedure retBtnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbAlterarSenhaChange(Sender: TObject);
    private
      ServiceUser: TServiceUser;
      procedure ValidarCampos;
      procedure LimparCampos;
    public
      function Render: TFmxObject;
      procedure UnRender;
      [Subscribe]
      procedure Props(aValue: TProps);
  end;

var
  PageNewUser: TPageNewUser;

implementation

uses
  Providers.PrivateRoute,
  Utils.Tools,
  ToastMessage;

{$R *.fmx}

procedure TPageNewUser.btnVoltarClick(Sender: TObject);
begin
  try
    OpenPrivateRoute('Config');
  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para a página principal - ' + E.Message, ttDanger);
  end;
end;

procedure TPageNewUser.cbAlterarSenhaChange(Sender: TObject);
begin
  lytNovasSenhas.Visible := cbAlterarSenha.IsChecked;
end;

procedure TPageNewUser.edtEmailExit(Sender: TObject);
begin
  ValidarCampos;
end;

procedure TPageNewUser.FormCreate(Sender: TObject);
begin
  lytSenhaAtual.Visible := false;
end;

procedure TPageNewUser.LimparCampos;
begin
  cbAlterarSenha.IsChecked := false;
  edtNovaSenha.Text := EmptyStr;
  edtConfirmarNovaSenha.Text := EmptyStr;
  edtNomeUsuario.Text := EmptyStr;
  edtEmail.Text := EmptyStr;
  edtSenhaAtual.Text := EmptyStr;
  lblTitle.Text := 'Novo usuário';
  lytSenhaAtual.Visible := false;
  lytNovasSenhas.Visible := true;
  lblNovaSenha.Text := 'Senha';
  lblConfirmarNovaSenha.Text := 'Confirmar Senha';
end;

procedure TPageNewUser.Props(aValue: TProps);
begin
  if (aValue.PropString <> EmptyStr) AND (aValue.Key = 'IdUserToUpdate') then
    begin
      lblNovaSenha.Text := 'Nova Senha';
      lblConfirmarNovaSenha.Text := 'Confirmar nova senha';
      lytSenhaAtual.Visible := true;
      lytNovasSenhas.Visible := false;

      ServiceUser.qryUsuarioLocal.Open;
      lblTitle.Text := 'Editar usuário #' + ServiceUser.qryUsuarioLocalid.AsString;
      edtNomeUsuario.Text := ServiceUser.qryUsuarioLocalNome.Value;
      edtEmail.Text := ServiceUser.qryUsuarioLocalEmail.Value;
    end;

end;

function TPageNewUser.Render: TFmxObject;
begin
  Result := lytNewUser;
  ServiceUser := TServiceUser.Create(nil);
end;

procedure TPageNewUser.UnRender;
begin
  ServiceUser.Free;
  Self.LimparCampos;
end;

procedure TPageNewUser.retBtnSalvarClick(Sender: TObject);
begin
  Self.ValidarCampos;

  if cbAlterarSenha.IsChecked then
    begin
      if not(ServiceUser.EfetuarLogin(ServiceUser.qryUsuarioLocalNome.Value, edtSenhaAtual.Text, true)) then
        abort;
      ServiceUser.mtUsuarioid.Value := ServiceUser.qryUsuarioLocalid.Value;
    end;

  ServiceUser.mtUsuarionome.Value := edtNomeUsuario.Text;
  ServiceUser.mtUsuarioemail.Value := edtEmail.Text;
  ServiceUser.mtUsuariosenha.Value := edtNovaSenha.Text;

  if ServiceUser.SalvarNovoUsuario then
    TToastMessage.show('Novo usuário salvo com sucesso!', ttSuccess);

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

  if edtNovaSenha.Text <> edtConfirmarNovaSenha.Text then
    begin
      TToastMessage.show('As senhas inseridas não correspondem', ttWarning);
      abort;
    end;
end;

end.
