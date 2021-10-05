unit Pages.New;

interface

uses
  Services.Card,
  MaskUtils,
  Router4D.Interfaces,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.StrUtils,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.DateTimeCtrls,
  FMX.Ani,
  FMX.Effects;

type
  TPageNew = class(TForm, iRouter4DComponent)
    lytNew: TLayout;
    edtEmailContato: TEdit;
    lblemailContato: TLabel;
    lytInterno: TLayout;
    lblrgTitular: TLabel;
    edtNomeTitular: TEdit;
    lblcpfResponsavel: TLabel;
    edtCpfResponsavel: TEdit;
    lblRgResponsavel: TLabel;
    edtNomeResponsavel: TEdit;
    lblnomeTitular: TLabel;
    edtRgResponsavel: TEdit;
    lblnomeResponsavel: TLabel;
    edtCpfTitular: TEdit;
    lblcpfTitular: TLabel;
    edtRgTitular: TEdit;
    lbldataNascimento: TLabel;
    edtDataNascimento: TDateEdit;
    edtNumeroContato: TEdit;
    lblnumeroContato: TLabel;
    VertScrollBox: TVertScrollBox;
    lytHeader: TLayout;
    FloatAnimation: TFloatAnimation;
    retBtnSalvar: TRectangle;
    ColorAnimation1: TColorAnimation;
    lblSalvar: TLabel;
    ShadowEffect1: TShadowEffect;
    Label1: TLabel;
    btnVoltar: TRectangle;
    ColorAnimation2: TColorAnimation;
    lblBtnVoltar: TLabel;
    ColorAnimation3: TColorAnimation;
    ClearEditButton1: TClearEditButton;
    ClearEditButton2: TClearEditButton;
    ClearEditButton3: TClearEditButton;
    ClearEditButton4: TClearEditButton;
    ClearEditButton5: TClearEditButton;
    ClearEditButton6: TClearEditButton;
    ClearEditButton7: TClearEditButton;
    ClearEditButton8: TClearEditButton;
    cbTitular: TCheckBox;
    cbResponsavel: TCheckBox;
    FloatAnimation4: TFloatAnimation;
    procedure ValidarCampos(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure retBtnSalvarClick(Sender: TObject);
    procedure edtCpfResponsavelKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtCpfTitularKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtRgTitularKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtNumeroContatoKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtRgResponsavelKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure cbTitularChange(Sender: TObject);
    procedure cbResponsavelChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    private
      LServiceCard: TServiceCard;
      procedure LimparCampos;

    public
      function Render: TFmxObject;
      procedure UnRender;
  end;

var
  PageNew: TPageNew;

implementation

uses
  Providers.PrivateRoute,
  Utils.Tools,
  Pages.Dashboard,
  ToastMessage,
  Router4D.Props;

{$R *.fmx}
{ TPageNew }

procedure TPageNew.btnVoltarClick(Sender: TObject);
begin
  try
    OpenPrivateRoute('Dashboard');
  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para a página principal - ' + E.Message, ttDanger);
  end;

end;

procedure TPageNew.cbResponsavelChange(Sender: TObject);
begin
  if cbResponsavel.IsChecked then
    edtRgResponsavel.Text := FormatMaskText('000.000.000', edtRgResponsavel.Text)
  else
    edtRgResponsavel.MaxLength := 20;
end;

procedure TPageNew.cbTitularChange(Sender: TObject);
begin
  if cbTitular.IsChecked then
    edtRgTitular.Text := FormatMaskText('000.000.000', edtRgTitular.Text)
  else
    edtRgTitular.MaxLength := 20;
end;

procedure TPageNew.edtCpfResponsavelKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  FormatMaskByEditObject(Sender, '000.000.000-00', KeyChar);
end;

procedure TPageNew.edtCpfTitularKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  FormatMaskByEditObject(Sender, '000.000.000-00', KeyChar);
end;

procedure TPageNew.edtNumeroContatoKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  FormatMaskByEditObject(Sender, '(00) 00000-0000', KeyChar);
end;

procedure TPageNew.edtRgResponsavelKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if cbResponsavel.IsChecked then
    FormatMaskByEditObject(Sender, '999.999.999', KeyChar);
end;

procedure TPageNew.edtRgTitularKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if cbTitular.IsChecked then
    FormatMaskByEditObject(Sender, '999.999.999', KeyChar);
end;

procedure TPageNew.FormCreate(Sender: TObject);
begin
  edtEmailContato.OnExit := Self.ValidarCampos;
  edtCpfResponsavel.OnExit := Self.ValidarCampos;
  edtCpfTitular.OnExit := Self.ValidarCampos;
  edtNomeResponsavel.OnExit := Self.ValidarCampos;
  edtNomeTitular.OnExit := Self.ValidarCampos;
end;

procedure TPageNew.LimparCampos;
begin
  edtEmailContato.Text := EmptyStr;
  edtNomeTitular.Text := EmptyStr;
  edtCpfResponsavel.Text := EmptyStr;
  edtNomeResponsavel.Text := EmptyStr;
  edtRgResponsavel.Text := EmptyStr;
  edtCpfTitular.Text := EmptyStr;
  edtRgTitular.Text := EmptyStr;
  edtDataNascimento.Date := Now;
  edtNumeroContato.Text := EmptyStr;
end;

function TPageNew.Render: TFmxObject;
begin
  Result := lytNew;
  LServiceCard := TServiceCard.Create(Self);
end;

procedure TPageNew.retBtnSalvarClick(Sender: TObject);
begin
  Self.ValidarCampos(Sender);
  try
    try
      if (LServiceCard.mtCadastroCarteiraPTEAid.AsInteger > 0) then
        LServiceCard.mtCadastroCarteiraPTEA.Edit
      else
        LServiceCard.mtCadastroCarteiraPTEA.Append;

      LServiceCard.mtCadastroCarteiraPTEANomeResponsavel.AsString := edtNomeResponsavel.Text;
      LServiceCard.mtCadastroCarteiraPTEADataNascimento.Value := edtDataNascimento.Date;
      LServiceCard.mtCadastroCarteiraPTEACpfResponsavel.Value := edtCpfResponsavel.Text;
      LServiceCard.mtCadastroCarteiraPTEANumeroContato.Value := edtNumeroContato.Text;
      LServiceCard.mtCadastroCarteiraPTEARgResponsavel.Value := edtRgResponsavel.Text;
      LServiceCard.mtCadastroCarteiraPTEAEmailContato.Value := edtEmailContato.Text;
      LServiceCard.mtCadastroCarteiraPTEANomeTitular.Value := edtNomeTitular.Text;
      LServiceCard.mtCadastroCarteiraPTEACpfTitular.Value := edtCpfTitular.Text;
      LServiceCard.mtCadastroCarteiraPTEARgTitular.Value := edtRgTitular.Text;
      LServiceCard.Salvar;
    finally
      try
        if not(LServiceCard.mtCadastroCarteiraPTEAid.IsNull) then
          OpenPrivateRoute('Update', TProps.Create.PropString(LServiceCard.mtCadastroCarteiraPTEAid.AsString)
              .Key('IdCarteiraToUpdate'));
      except
        on E: Exception do
          TToastMessage.show('Erro durante navegação para a página de edição - ' + E.Message, ttDanger);
      end;
    end;
  except
    on E: Exception do
      TToastMessage.show(E.Message, ttDanger);
  end;

end;

procedure TPageNew.UnRender;
begin
  Self.LimparCampos;
  LServiceCard.Free;
end;

procedure TPageNew.ValidarCampos(Sender: TObject);
begin
  if screen.ActiveForm <> nil then
    with TEdit(Sender) do
      begin
        if Sender <> nil then
          case IndexStr(Name, ['retBtnSalvar', 'edtEmailContato', 'edtCpfResponsavel', 'edtCpfTitular',
              'edtNomeTitular', 'edtNomeResponsavel']) of
            0:
              begin
                Self.ValidarCampos(edtEmailContato);
                Self.ValidarCampos(edtCpfResponsavel);
                Self.ValidarCampos(edtCpfTitular);
                Self.ValidarCampos(edtNomeTitular);
                Self.ValidarCampos(edtNomeResponsavel);
              end;
            1:
              begin
                if NOT(Text.IsEmpty) AND not(EmailIsValid(Text)) then
                  begin
                    TToastMessage.show('O valor (' + Text + ') inserido no campo de e-mail é inválido ');
                    abort;
                  end;
              end;
            2:
              begin
                if NOT(Text.IsEmpty) AND not(CPFIsValid(Text)) then
                  begin
                    TToastMessage.show('O valor (' + Text + ') inserido no campo de CPF é inválido ');
                    abort;
                  end;
              end;
            3:
              begin
                if NOT(Text.IsEmpty) AND not(CPFIsValid(Text)) then
                  begin
                    TToastMessage.show('O valor (' + Text + ') inserido no campo de CPF é inválido ');
                    abort;
                  end;
              end;
            4:
              begin
                if NOT(Text.IsEmpty) AND not(NameFieldIsValid(Text)) then
                  begin
                    TToastMessage.show('O valor (' + Text + ') inserido no campo de nome é inválido ');
                    abort;
                  end;
              end;
            5:
              begin
                if NOT(Text.IsEmpty) AND not(NameFieldIsValid(Text)) then
                  begin
                    TToastMessage.show('O valor (' + Text + ') inserido no campo de nome é inválido ');
                    abort;
                  end;
              end;

          end;
      end;
end;

end.
