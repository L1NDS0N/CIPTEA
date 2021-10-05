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
    procedure retBtnSalvarClick(Sender: TObject);
    procedure cbAlterarSenhaChange(Sender: TObject);
    private
      LServiceUser: TServiceUser;
      procedure ValidarCampos;
      procedure LimparCampos;
      procedure NavegarPara(const ALocation: string; const AProps: TProps = nil);
    public
      function Render: TFmxObject;
      procedure UnRender;
      [Subscribe]
      procedure PropsNewUser(aValue: TProps);
  end;

var
  PageNewUser: TPageNewUser;

implementation

uses
  Providers.PrivateRoute,
  Utils.Tools,
  ToastMessage;

{$R *.fmx}

function TPageNewUser.Render: TFmxObject;
begin
  Result := lytNewUser;
  lytSenhaAtual.Visible := false;
  LServiceUser := TServiceUser.Create(Self);
end;

procedure TPageNewUser.UnRender;
begin
  Self.LimparCampos;
  LServiceUser.Free;
end;

procedure TPageNewUser.btnVoltarClick(Sender: TObject);
begin
  NavegarPara('Config');
end;

procedure TPageNewUser.cbAlterarSenhaChange(Sender: TObject);
begin
  lytNovasSenhas.Visible := cbAlterarSenha.IsChecked;
  lblNovaSenha.Text := 'Nova Senha';
  lblConfirmarNovaSenha.Text := 'Confirmar nova senha';
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

procedure TPageNewUser.NavegarPara(const ALocation: string; const AProps: TProps);
begin
  try
    OpenPrivateRoute(ALocation, AProps);
  except
    on E: Exception do
      TToastMessage.show(E.Message, ttDanger);
  end;
end;

procedure TPageNewUser.PropsNewUser(aValue: TProps);
begin
  try
    try
      if (aValue.PropString <> EmptyStr) AND (aValue.Key = 'IdUserToUpdate') then
        begin
          lytSenhaAtual.Visible := true;
          lytNovasSenhas.Visible := false;

          LServiceUser.qryUsuarioLocal.Open;
          LServiceUser.mtUsuario.Open;
          LServiceUser.mtUsuario.Edit;
          LServiceUser.mtUsuarioid.Value := LServiceUser.qryUsuarioLocalid.Value;
          lblTitle.Text := 'Editar usuário #' + LServiceUser.qryUsuarioLocalid.AsString;
          edtNomeUsuario.Text := LServiceUser.qryUsuarioLocalNome.Value;
          edtEmail.Text := LServiceUser.qryUsuarioLocalEmail.Value;
        end;
    except
      on E: Exception do
        TToastMessage.show('Erro durante a transferência de dados para a página de edição de usuário ' + E.Message,
          ttDanger);
    end;
  finally
    aValue.Free;
  end;

end;

procedure TPageNewUser.retBtnSalvarClick(Sender: TObject);
begin
  try
    Self.ValidarCampos;
    LServiceUser.mtUsuario.Open;

    if LServiceUser.mtUsuarioid.AsInteger > 0 then
      begin
        LServiceUser.mtUsuario.Edit;
        LServiceUser.mtUsuarionome.Value := edtNomeUsuario.Text;
        LServiceUser.mtUsuarioemail.Value := edtEmail.Text;
        if cbAlterarSenha.IsChecked then
          LServiceUser.mtUsuariosenha.Value := edtNovaSenha.Text
        else
          LServiceUser.mtUsuariosenha.Value := edtSenhaAtual.Text;

        if LServiceUser.EfetuarLogin(LServiceUser.qryUsuarioLocalNome.Value, edtSenhaAtual.Text, true) then
          begin
            if LServiceUser.SalvarNovoUsuario then
              begin
                TToastMessage.show('Usuário salvo com sucesso!', ttSuccess);
                NavegarPara('Config');
              end;
          end
        else
          abort;
      end
    else
      begin
        LServiceUser.mtUsuario.Append;
        LServiceUser.mtUsuarionome.Value := edtNomeUsuario.Text;
        LServiceUser.mtUsuarioemail.Value := edtEmail.Text;
        LServiceUser.mtUsuariosenha.Value := edtNovaSenha.Text;
        if LServiceUser.SalvarNovoUsuario then
          begin
            TToastMessage.show('Usuário salvo com sucesso!', ttSuccess);
            NavegarPara('Config');
          end;
      end;
  except
    on E: Exception do
      TToastMessage.show(E.Message, ttWarning);
  end;
end;

procedure TPageNewUser.ValidarCampos;
begin
  with edtEmail do
    begin
      if NOT(Text.IsEmpty) AND not(EmailIsValid(Text)) then
        raise Exception.Create('O valor (' + Text + ') inserido no campo de e-mail é inválido ');
    end;

  if not(edtNovaSenha.Text.IsEmpty) AND not(edtConfirmarNovaSenha.Text.IsEmpty) AND
    (edtNovaSenha.Text <> edtConfirmarNovaSenha.Text) then
    raise Exception.Create('As senhas inseridas não correspondem');
end;

end.
