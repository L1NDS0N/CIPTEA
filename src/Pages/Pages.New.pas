unit Pages.New;

interface

uses
  Services.New,
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
    Button1: TButton;
    procedure btnVoltarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure retBtnSalvarClick(Sender: TObject);
    procedure edtCpfResponsavelKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtCpfTitularKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure ValidarCampos(Sender: TObject);
    private
      serviceNew: TServiceNew;
      procedure LimparCampos;

    public
      function Render: TFmxObject;
      procedure UnRender;
  end;

var
  PageNew: TPageNew;

implementation

uses
  Utils.Tools,
  Pages.Dashboard,
  Router4D,
  ToastMessage;

{$R *.fmx}
{ TPageNew }

procedure TPageNew.btnVoltarClick(Sender: TObject);
begin
  try
    TRouter4D.Link.&To('Dashboard');
  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para a página principal - ' + E.Message, ttDanger);
  end;

end;

procedure TPageNew.Button1Click(Sender: TObject);
begin
  ValidarCampos(nil);
end;

procedure TPageNew.edtCpfResponsavelKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  TEdit(Sender).Text := FormatMaskByEditObject(Sender, '000.000.000-00', KeyChar);
end;

procedure TPageNew.edtCpfTitularKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  TEdit(Sender).Text := FormatMaskByEditObject(Sender, '000.000.000-00', KeyChar);
end;

procedure TPageNew.FormCreate(Sender: TObject);
begin
  serviceNew := TServiceNew.Create(self);
end;

procedure TPageNew.FormDestroy(Sender: TObject);
begin
  serviceNew.Free;
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
end;

procedure TPageNew.retBtnSalvarClick(Sender: TObject);
begin
  self.ValidarCampos(nil);
  try
    try

      if (serviceNew.mtCadastroCarteiraPTEAid.AsInteger > 0) then
        serviceNew.mtCadastroCarteiraPTEA.Edit
      else
        serviceNew.mtCadastroCarteiraPTEA.Append;

      serviceNew.mtCadastroCarteiraPTEANomeResponsavel.AsString := edtNomeResponsavel.Text;
      serviceNew.mtCadastroCarteiraPTEADataNascimento.Value := edtDataNascimento.Date;
      serviceNew.mtCadastroCarteiraPTEACpfResponsavel.Value := edtCpfResponsavel.Text;
      serviceNew.mtCadastroCarteiraPTEANumeroContato.Value := edtNumeroContato.Text;
      serviceNew.mtCadastroCarteiraPTEARgResponsavel.Value := edtRgResponsavel.Text;
      serviceNew.mtCadastroCarteiraPTEAEmailContato.Value := edtEmailContato.Text;
      serviceNew.mtCadastroCarteiraPTEANomeTitular.Value := edtNomeTitular.Text;
      serviceNew.mtCadastroCarteiraPTEACpfTitular.Value := edtCpfTitular.Text;
      serviceNew.mtCadastroCarteiraPTEARgTitular.Value := edtRgTitular.Text;
      serviceNew.Salvar;
    finally
      try
        TRouter4D.Link.&To('Dashboard');
      except
        on E: Exception do
          TToastMessage.show('Erro durante navegação para a página principal - ' + E.Message, ttDanger);
      end;
    end;
  except
    on E: Exception do
      TToastMessage.show('Erro durante gravação dos dados - ' + E.Message, ttDanger);
  end;

end;

procedure TPageNew.UnRender;
begin
  self.LimparCampos;
end;

procedure TPageNew.ValidarCampos(Sender: TObject);
begin
  if not(Sender = nil) then
    case IndexStr(TEdit(Sender).Name, ['edtEmailContato']) of
      0:
        begin
          if NOT(edtEmailContato.Text.IsEmpty) AND not(EmailIsValid(edtEmailContato.Text)) then
            begin
              TToastMessage.show('O valor (' + edtEmailContato.Text + ') inserido no campo de e-mail é inválido ');
              abort;
            end;
        end;

    end
  else
    begin
      if NOT(edtEmailContato.Text.IsEmpty) AND not(EmailIsValid(edtEmailContato.Text)) then
        begin
          edtEmailContato.SetFocus;
          TToastMessage.show('O valor (' + edtEmailContato.Text + ') inserido no campo de e-mail é inválido ');
          abort;
        end;

      if NOT(edtCpfResponsavel.Text.IsEmpty) AND not(CPFIsValid(edtCpfResponsavel.Text)) then
        begin
          edtCpfResponsavel.SetFocus;
          TToastMessage.show('O valor (' + edtCpfResponsavel.Text + ') inserido no campo de CPF é inválido ');
          abort;
        end;

      if NOT(edtCpfTitular.Text.IsEmpty) AND not(CPFIsValid(edtCpfTitular.Text)) then
        begin
          edtCpfTitular.SetFocus;
          TToastMessage.show('O valor (' + edtCpfTitular.Text + ') inserido no campo de CPF é inválido ');
          abort;
        end;

      Sender := nil;
    end;

end;

end.
