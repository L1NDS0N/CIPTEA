﻿unit Pages.Update;

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
  Configs.GLOBAL,
  Router4D;

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
    procedure FormCreate(Sender: TObject);
    procedure rctFotoRostoClick(Sender: TObject);
    procedure rctLaudoMedicoClick(Sender: TObject);
    procedure retBtnSalvarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnAmpliarDocumentoClick(Sender: TObject);
    private
      serviceNew: TServiceNew;
      Config: TConfigGlobal;
      procedure VerificacoesUX;
    public
      function Render: TFmxObject;
      procedure UnRender;
      [Subscribe]
      procedure Props(aValue: TProps);
  end;

var
  PageUpdate: TPageUpdate;

implementation

uses
  Utils.Tools,
  Pages.Principal,
  Pages.Dashboard,
  FireDAC.Comp.Client,
  ToastMessage;
{$R *.fmx}
{ TPageUpdate }

procedure TPageUpdate.FormCreate(Sender: TObject);
begin
  serviceNew := TServiceNew.Create(Self);
end;

procedure TPageUpdate.Props(aValue: TProps);
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
    finally
      aValue.Free;
      VerificacoesUX;
    end;
  except
    on E: Exception do
      begin
        TToastMessage.show('Erro durante transferência dos dados da carteirinha #' + aValue.PropString + ' - ' +
            E.Message, ttDanger);
        abort;
      end;
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

          imgFotoRosto.Bitmap.LoadFromFile(dlgFotoRosto.FileName);
          try
            TRouter4D.Link.&To('Editor', TProps.Create.PropString(serviceNew.mtCadastroCarteiraPTEAid.AsString)
                .Key('IdCarteiraToUpdate'));
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

procedure TPageUpdate.btnVoltarClick(Sender: TObject);
begin
  try
    TRouter4D.Link.&To('Dashboard');
  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para a página principal - ' + E.Message, ttDanger);
  end;

end;

function TPageUpdate.Render: TFmxObject;
begin
  Result := lytUpdate;
end;

procedure TPageUpdate.retBtnSalvarClick(Sender: TObject);
var
  AID: string;
begin

  AID := serviceNew.mtCadastroCarteiraPTEAid.AsString;
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
      TToastMessage.show('Alterações na carteirinha #' + AID + ' foram salvas com sucesso!', ttSuccess);
      try
        TRouter4D.Link.&To('Dashboard');
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
end;

procedure TPageUpdate.VerificacoesUX;
var
  qryResult: TFDQuery;
begin
  qryResult := serviceNew.GetFileById(serviceNew.mtCadastroCarteiraPTEAid.Value);
  if not(qryResult.IsEmpty) then
    if qryResult.FieldByName('hasDoc').AsBoolean then
      begin
        LayoutZoom.Visible := true;
        lblSelecioneLaudo.Text := 'Este registro contém um laudo salvo, clique no 👁 para visualizar no navegador';
      end;

  if imgFotoRosto.Bitmap.IsEmpty then
    lblSelecioneFOto.Visible := true
  else
    lblSelecioneFOto.Visible := false;

end;

end.
