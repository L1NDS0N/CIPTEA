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
  Services.Card,
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
    FloatAnimation4: TFloatAnimation;
    procedure ValidarCampos(Sender: TObject);
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
    procedure FormCreate(Sender: TObject);
    private
      LServiceCard: TServiceCard;
      Config: TConfigGlobal;
      procedure VerificacoesUX;
      procedure LimparCampos;
      procedure NavegarPara(const ALocation: string; const AProps: TProps = nil);
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
  FireDAC.Comp.Client,
  ToastMessage,
  System.MaskUtils,
  System.StrUtils;
{$R *.fmx}
{ TPageUpdate }

function TPageUpdate.Render: TFmxObject;
begin
  Result := lytUpdate;

  LServiceCard := TServiceCard.Create(Self);
end;

procedure TPageUpdate.UnRender;
begin
  Self.LimparCampos;
  LServiceCard.Free;
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
  LayoutZoom.Visible := false;
  dlgLaudoMedico.FileName := EmptyStr;
  if not(imgFotoRosto.Bitmap.IsEmpty) then
    imgFotoRosto.Bitmap := nil;
  lblSelecioneLaudo.Text := 'Selecione o laudo médico em PDF';
end;

procedure TPageUpdate.PropsUpdate(aValue: TProps);
begin
  try
    try
      if (aValue.PropString <> '') and (aValue.Key = 'IdCarteiraToUpdate') then
        LServiceCard.GetById(aValue.PropString);

      lblID.Text := '#' + aValue.PropString;
      edtNomeResponsavel.Text := LServiceCard.mtCadastroCarteiraPTEANomeResponsavel.AsString;
      edtCpfResponsavel.Text := LServiceCard.mtCadastroCarteiraPTEACpfResponsavel.AsString;
      edtCpfTitular.Text := LServiceCard.mtCadastroCarteiraPTEACpfTitular.AsString;
      edtDataNascimento.Date := LServiceCard.mtCadastroCarteiraPTEADataNascimento.AsDateTime;
      edtEmailContato.Text := LServiceCard.mtCadastroCarteiraPTEAEmailContato.AsString;
      edtNomeTitular.Text := LServiceCard.mtCadastroCarteiraPTEANomeTitular.AsString;
      edtNumeroContato.Text := LServiceCard.mtCadastroCarteiraPTEANumeroContato.AsString;
      edtRgResponsavel.Text := LServiceCard.mtCadastroCarteiraPTEARgResponsavel.AsString;
      edtRgTitular.Text := LServiceCard.mtCadastroCarteiraPTEARgTitular.AsString;
      imgFotoRosto.Bitmap.LoadFromStream(LServiceCard.GetImageStreamById(aValue.PropString.ToInteger));
      LServiceCard.GetFiles;

    except
      on E: Exception do
        begin
          TToastMessage.show('Erro durante transferência dos dados da carteirinha #' + aValue.PropString +
              ' na página de edição - ' + E.Message, ttDanger);
        end;
    end;
  finally
    VerificacoesUX;
    aValue.Free;
  end;
end;

procedure TPageUpdate.NavegarPara(const ALocation: string; const AProps: TProps);
begin
  try
    OpenPrivateRoute(ALocation, AProps);
  except
    on E: Exception do
      TToastMessage.show(E.Message, ttDanger);
  end;
end;

procedure TPageUpdate.rctFotoRostoClick(Sender: TObject);
begin
  try
    if dlgFotoRosto.Execute then
      if dlgFotoRosto.FileName <> EmptyStr then
        begin
          LServiceCard.qryTemp.Open;
          LServiceCard.qryTemp.First;
          LServiceCard.qryTemp.Edit;
          LServiceCard.qryTempFotoRostoPath.Value := dlgFotoRosto.FileName;
          LServiceCard.qryTemp.Post;

          NavegarPara('Editor', TProps.Create.PropString(LServiceCard.mtCadastroCarteiraPTEAid.AsString)
              .Key('IdCarteiraToFotoEdit'));
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
        LServiceCard.mtCadastroCarteiraPTEA.Edit;
        LServiceCard.mtCadastroCarteiraPTEALaudoMedicoPath.Value := dlgLaudoMedico.FileName;
        LServiceCard.mtCadastroCarteiraPTEA.Post;

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
      AbrirLinkNavegador(Config.BaseURL + '/carteiras/' + LServiceCard.mtCadastroCarteiraPTEAid.AsString +
          '/static/doc');
    end;
end;

procedure TPageUpdate.btnPrintClick(Sender: TObject);
begin
  NavegarPara('Print', TProps.Create.PropString(LServiceCard.mtCadastroCarteiraPTEAid.AsString)
      .Key('IdCarteiraToPrintFromUpdate'));
end;

procedure TPageUpdate.btnVoltarClick(Sender: TObject);
begin
  NavegarPara('Dashboard');
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

procedure TPageUpdate.FormCreate(Sender: TObject);
begin
  edtEmailContato.OnExit := Self.ValidarCampos;
  edtCpfResponsavel.OnExit := Self.ValidarCampos;
  edtCpfTitular.OnExit := Self.ValidarCampos;
  edtNomeResponsavel.OnExit := Self.ValidarCampos;
  edtNomeTitular.OnExit := Self.ValidarCampos;
end;

procedure TPageUpdate.retBtnSalvarClick(Sender: TObject);
var
  AId: string;
begin
  Self.ValidarCampos(Sender);
  AId := LServiceCard.mtCadastroCarteiraPTEAid.AsString;
  try
    try
      LServiceCard.mtCadastroCarteiraPTEA.Edit;

      if not(LServiceCard.mtCadastroCarteiraPTEALaudoMedicoPath.IsNull) then
        LServiceCard.PostStreamDoc;

      LServiceCard.mtCadastroCarteiraPTEADataNascimento.AsDateTime := edtDataNascimento.Date;
      LServiceCard.mtCadastroCarteiraPTEANomeResponsavel.AsString := edtNomeResponsavel.Text;
      LServiceCard.mtCadastroCarteiraPTEACpfResponsavel.AsString := edtCpfResponsavel.Text;
      LServiceCard.mtCadastroCarteiraPTEANumeroContato.AsString := edtNumeroContato.Text;
      LServiceCard.mtCadastroCarteiraPTEARgResponsavel.AsString := edtRgResponsavel.Text;
      LServiceCard.mtCadastroCarteiraPTEAEmailContato.AsString := edtEmailContato.Text;
      LServiceCard.mtCadastroCarteiraPTEANomeTitular.AsString := edtNomeTitular.Text;
      LServiceCard.mtCadastroCarteiraPTEACpfTitular.AsString := edtCpfTitular.Text;
      LServiceCard.mtCadastroCarteiraPTEARgTitular.AsString := edtRgTitular.Text;
      LServiceCard.Salvar;
    finally
      TToastMessage.show('Alterações na carteirinha #' + AId + ' foram salvas com sucesso!', ttSuccess);
      NavegarPara('Dashboard');
    end;
  except
    on E: Exception do
      TToastMessage.show('Erro durante regravação dos campos da página de edição - ' + E.Message, ttDanger);
  end;
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
    qryResult := LServiceCard.GetFileById(LServiceCard.mtCadastroCarteiraPTEAid.Value);
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
