unit Pages.Update;

interface

uses
  Router4D.Interfaces,
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
  FMX.Ani,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.DateTimeCtrls,
  FMX.Controls.Presentation,
  FMX.Edit,
  FMX.Layouts,
  Services.New,
  Router4D.Props,
  FMX.ExtCtrls,
  FMX.Effects,
  Configs.GLOBAL;

type
  TPageUpdate = class(TForm, iRouter4DComponent)
    dlgLaudoMedico: TOpenDialog;
    lytUpdate: TLayout;
    lytInterno: TLayout;
    VertScrollBox: TVertScrollBox;
    edtCpfResponsavel: TEdit;
    edtCpfTitular: TEdit;
    edtDataNascimento: TDateEdit;
    edtEmailContato: TEdit;
    edtNomeResponsavel: TEdit;
    edtNomeTitular: TEdit;
    edtNumeroContato: TEdit;
    edtRgResponsavel: TEdit;
    edtRgTitular: TEdit;
    lblcpfResponsavel: TLabel;
    lblcpfTitular: TLabel;
    lbldataNascimento: TLabel;
    lblemailContato: TLabel;
    lblnomeResponsavel: TLabel;
    lblnomeTitular: TLabel;
    lblnumeroContato: TLabel;
    lblRgResponsavel: TLabel;
    lblrgTitular: TLabel;
    lytAnexos: TLayout;
    rctFotoRosto: TRectangle;
    rctLaudoMedico: TRectangle;
    lytHeader: TLayout;
    FloatAnimation: TFloatAnimation;
    dlgFotoRosto: TOpenDialog;
    lblID: TLabel;
    imgFotoRosto: TImage;
    lblSelecioneFOto: TLabel;
    retBtnSalvar: TRectangle;
    lblSelecioneLaudo: TLabel;
    btnAmpliarDocumento: TSpeedButton;
    LayoutZoom: TLayout;
    ColorAnimation1: TColorAnimation;
    ShadowEffect1: TShadowEffect;
    lblSalvar: TLabel;
    lblTitle: TLabel;
    btnVoltar: TRectangle;
    ColorAnimation2: TColorAnimation;
    lblBtnVoltar: TLabel;
    ColorAnimation3: TColorAnimation;
    IconLaudoMedico: TImage;
    IconFotoRosto: TImage;
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
    btnPrint: TRectangle;
    ColorAnimation4: TColorAnimation;
    ColorAnimation5: TColorAnimation;
    imgPrint: TPath;
    procedure ValidarCampos(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rctFotoRostoClick(Sender: TObject);
    procedure rctLaudoMedicoClick(Sender: TObject);
    procedure retBtnSalvarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnAmpliarDocumentoClick(Sender: TObject);
    procedure cbResponsavelChange(Sender: TObject);
    procedure cbTitularChange(Sender: TObject);
    procedure edtCpfResponsavelKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtCpfTitularKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtNumeroContatoKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtRgResponsavelKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtRgTitularKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure btnPrintClick(Sender: TObject);
    private
      serviceNew: TServiceNew;
      Config: TConfigGlobal;
      procedure VerificacoesUX;
      procedure LimparCampos;
    public
      function Render: TFmxObject;
      procedure UnRender;
      [Subscribe]
      procedure PropsUpdate(aValue: TProps);
  end;

var
  PageUpdate: TPageUpdate;

implementation

uses
  Providers.PrivateRoute,
  Utils.Tools,
  Pages.Principal,
  Pages.Dashboard,
  FireDAC.Comp.Client,
  ToastMessage,
  System.MaskUtils,
  System.StrUtils;
{$R *.fmx}
{ TPageUpdate }

procedure TPageUpdate.FormCreate(Sender: TObject);
begin
  edtEmailContato.OnExit := Self.ValidarCampos;
  edtCpfResponsavel.OnExit := Self.ValidarCampos;
  edtCpfTitular.OnExit := Self.ValidarCampos;
  edtNomeResponsavel.OnExit := Self.ValidarCampos;
  edtNomeTitular.OnExit := Self.ValidarCampos;
end;

procedure TPageUpdate.LimparCampos;
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

procedure TPageUpdate.PropsUpdate(aValue: TProps);
var
  streamImage: TMemoryStream;
begin
  try
    try
      if (aValue.PropString <> '') and (aValue.Key = 'IdCarteiraToUpdate') then
        serviceNew.GetById(aValue.PropString);

      lblID.Text := '#' + aValue.PropString;
      edtNomeResponsavel.Text := serviceNew.mtCadastroCarteiraPTEANomeResponsavel.AsString;
      edtCpfResponsavel.Text := serviceNew.mtCadastroCarteiraPTEACpfResponsavel.AsString;
      edtCpfTitular.Text := serviceNew.mtCadastroCarteiraPTEACpfTitular.AsString;
      edtDataNascimento.Date := serviceNew.mtCadastroCarteiraPTEADataNascimento.AsDateTime;
      edtEmailContato.Text := serviceNew.mtCadastroCarteiraPTEAEmailContato.AsString;
      edtNomeTitular.Text := serviceNew.mtCadastroCarteiraPTEANomeTitular.AsString;
      edtNumeroContato.Text := serviceNew.mtCadastroCarteiraPTEANumeroContato.AsString;
      edtRgResponsavel.Text := serviceNew.mtCadastroCarteiraPTEARgResponsavel.AsString;
      edtRgTitular.Text := serviceNew.mtCadastroCarteiraPTEARgTitular.AsString;
      imgFotoRosto.Bitmap.LoadFromStream(serviceNew.GetImageStreamById(aValue.PropString.ToInteger));
      serviceNew.GetFiles;

    except
      on E: Exception do
        begin
          TToastMessage.show('Erro durante transferência dos dados da carteirinha #' + aValue.PropString + ' - ' +
              E.Message, ttDanger);
          abort;
        end;
    end;
  finally
    FreeAndNil(aValue);
    VerificacoesUX;
  end;
end;

procedure TPageUpdate.rctFotoRostoClick(Sender: TObject);
begin
  try
    if dlgFotoRosto.Execute then
      if dlgFotoRosto.FileName <> EmptyStr then
        begin
          serviceNew.qryTemp.Open;
          serviceNew.qryTemp.First;
          serviceNew.qryTemp.Edit;
          serviceNew.qryTempFotoRostoPath.Value := dlgFotoRosto.FileName;
          serviceNew.qryTemp.Post;

          try
            OpenPrivateRoute('Editor', TProps.Create.PropString(serviceNew.mtCadastroCarteiraPTEAid.AsString)
                .Key('IdCarteiraToFotoEdit'));
          except
            on E: Exception do
              TToastMessage.show('Erro durante navegação para a página de edição de imagem - ' + E.Message, ttDanger);
          end;
        end;
  finally
    VerificacoesUX;
  end;
end;

procedure TPageUpdate.rctLaudoMedicoClick(Sender: TObject);
begin
  dlgLaudoMedico.FileName := EmptyStr;
  if dlgLaudoMedico.Execute then
    if dlgLaudoMedico.FileName <> EmptyStr then
      begin
        serviceNew.mtCadastroCarteiraPTEA.Edit;
        serviceNew.mtCadastroCarteiraPTEALaudoMedicoPath.Value := dlgLaudoMedico.FileName;
        serviceNew.mtCadastroCarteiraPTEA.Post;

        lblSelecioneLaudo.Text := 'Arquivo "' + Copy(dlgLaudoMedico.FileName,
          LastDelimiter('\', dlgLaudoMedico.FileName) + 1, Length(dlgLaudoMedico.FileName)) + '" selecionado';

        LayoutZoom.Visible := true;
      end
    else
      begin
        LayoutZoom.Visible := false;
        lblSelecioneLaudo.Text := 'Selecione o laudo médico em PDF';
      end;
end;

procedure TPageUpdate.btnAmpliarDocumentoClick(Sender: TObject);
begin
  if not(dlgLaudoMedico.FileName = EmptyStr) then
    AbrirLinkNavegador(dlgLaudoMedico.FileName)
  else
    begin
      AbrirLinkNavegador(Config.BaseURL + '/carteiras/' + serviceNew.mtCadastroCarteiraPTEAid.AsString + '/static/doc');
    end;
end;

procedure TPageUpdate.btnPrintClick(Sender: TObject);
var
  PropsToPrint: TProps;
begin
  PropsToPrint := TProps.Create.PropString(serviceNew.mtCadastroCarteiraPTEAid.AsString)
    .Key('IdCarteiraToPrintFromUpdate');
  try
    OpenPrivateRoute('Print', PropsToPrint);
  except
    on E: Exception do
      begin
        TToastMessage.show('Erro durante navegação para página de impressão - ' + E.Message, ttDanger);
      end;
  end;
end;

procedure TPageUpdate.btnVoltarClick(Sender: TObject);
begin
  try
    OpenPrivateRoute('Dashboard');
  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para a página principal - ' + E.Message, ttDanger);
  end;

end;

procedure TPageUpdate.cbResponsavelChange(Sender: TObject);
begin
  if cbResponsavel.IsChecked then
    edtRgResponsavel.Text := FormatMaskText('000.000.000', edtRgResponsavel.Text)
  else
    edtRgResponsavel.MaxLength := 20;
end;

procedure TPageUpdate.cbTitularChange(Sender: TObject);
begin
  if cbTitular.IsChecked then
    edtRgTitular.Text := FormatMaskText('000.000.000', edtRgTitular.Text)
  else
    edtRgTitular.MaxLength := 20;
end;

procedure TPageUpdate.edtCpfResponsavelKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  FormatMaskByEditObject(Sender, '000.000.000-00', KeyChar);
end;

procedure TPageUpdate.edtCpfTitularKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  FormatMaskByEditObject(Sender, '000.000.000-00', KeyChar);
end;

procedure TPageUpdate.edtNumeroContatoKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  FormatMaskByEditObject(Sender, '(00) 00000-0000', KeyChar);
end;

procedure TPageUpdate.edtRgResponsavelKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if cbResponsavel.IsChecked then
    FormatMaskByEditObject(Sender, '999.999.999', KeyChar);
end;

procedure TPageUpdate.edtRgTitularKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if cbTitular.IsChecked then
    FormatMaskByEditObject(Sender, '999.999.999', KeyChar);
end;

function TPageUpdate.Render: TFmxObject;
begin
  Result := lytUpdate;
  serviceNew := TServiceNew.Create(Self);
end;

procedure TPageUpdate.retBtnSalvarClick(Sender: TObject);
var
  AId: string;
begin
  Self.ValidarCampos(Sender);
  AId := serviceNew.mtCadastroCarteiraPTEAid.AsString;
  try
    try
      serviceNew.mtCadastroCarteiraPTEA.Edit;

      if not(serviceNew.mtCadastroCarteiraPTEALaudoMedicoPath.IsNull) then
        serviceNew.PostStreamDoc;

      serviceNew.mtCadastroCarteiraPTEADataNascimento.AsDateTime := edtDataNascimento.Date;
      serviceNew.mtCadastroCarteiraPTEANomeResponsavel.AsString := edtNomeResponsavel.Text;
      serviceNew.mtCadastroCarteiraPTEACpfResponsavel.AsString := edtCpfResponsavel.Text;
      serviceNew.mtCadastroCarteiraPTEANumeroContato.AsString := edtNumeroContato.Text;
      serviceNew.mtCadastroCarteiraPTEARgResponsavel.AsString := edtRgResponsavel.Text;
      serviceNew.mtCadastroCarteiraPTEAEmailContato.AsString := edtEmailContato.Text;
      serviceNew.mtCadastroCarteiraPTEANomeTitular.AsString := edtNomeTitular.Text;
      serviceNew.mtCadastroCarteiraPTEACpfTitular.AsString := edtCpfTitular.Text;
      serviceNew.mtCadastroCarteiraPTEARgTitular.AsString := edtRgTitular.Text;
      serviceNew.Salvar;
    finally
      TToastMessage.show('Alterações na carteirinha #' + AId + ' foram salvas com sucesso!', ttSuccess);
      try
        OpenPrivateRoute('Dashboard');
      except
        on E: Exception do
          TToastMessage.show('Erro durante navegação para a página principal - ' + E.Message, ttDanger);
      end;
    end;
  except
    on E: Exception do
      TToastMessage.show('Erro durante regravação dos campos da página de edição - ' + E.Message, ttDanger);
  end;
end;

procedure TPageUpdate.UnRender;
begin
  dlgLaudoMedico.FileName := EmptyStr;

  if not(imgFotoRosto.Bitmap.IsEmpty) then
    imgFotoRosto.Bitmap := nil;

  LayoutZoom.Visible := false;

  lblSelecioneLaudo.Text := 'Selecione o laudo médico em PDF';

  serviceNew.Free;
  Self.LimparCampos;
end;

procedure TPageUpdate.ValidarCampos(Sender: TObject);
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

procedure TPageUpdate.VerificacoesUX;
var
  qryResult: TFDQuery;
begin
  try
    qryResult := serviceNew.GetFileById(serviceNew.mtCadastroCarteiraPTEAid.Value);
    if not(qryResult.IsEmpty) then
      if qryResult.FieldByName('hasDoc').AsBoolean then
        begin
          LayoutZoom.Visible := true;
          lblSelecioneLaudo.Text := 'Este registro contém um laudo salvo, clique no 👁 para visualizar no navegador';
        end;
  except
    on E: Exception do
      TToastMessage.show(E.Message, ttWarning);
  end;

  if imgFotoRosto.Bitmap.IsEmpty then
    lblSelecioneFOto.Visible := true
  else
    lblSelecioneFOto.Visible := false;

end;

end.
