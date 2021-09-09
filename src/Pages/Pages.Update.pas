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
  FMX.WebBrowser,
  FMX.ExtCtrls,
  FMX.gtxClasses,
  FMX.gtxDocumentViewer,
  gtClasses;

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
    btnVoltar: TSpeedButton;
    FloatAnimation: TFloatAnimation;
    dlgFotoRosto: TOpenDialog;
    lblID: TLabel;
    imgFotoRosto: TImage;
    lblSelecioneFOto: TLabel;
    retBtnSalvar: TRectangle;
    SpeedButton1: TSpeedButton;
    lblSelecioneLaudo: TLabel;
    gtDocumentViewer: TgtDocumentViewer;
    btnAmpliarDocumento: TSpeedButton;
    LayoutZoom: TLayout;
    btnFecharDocumento: TSpeedButton;
    rctTopDocument: TRectangle;
    procedure FormCreate(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure rctFotoRostoClick(Sender: TObject);
    procedure rctLaudoMedicoClick(Sender: TObject);
    procedure retBtnSalvarClick(Sender: TObject);
    procedure btnFecharDocumentoClick(Sender: TObject);
    procedure btnAmpliarDocumentoClick(Sender: TObject);
    private
      serviceNew: TServiceNew;
      procedure CheckAndUpdateUserInterface;
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
  Router4D,
  Pages.Dashboard;
{$R *.fmx}
{ TPageUpdate }

procedure TPageUpdate.btnAmpliarDocumentoClick(Sender: TObject);
begin
  gtDocumentViewer.Size.Height := VertScrollBox.Height;
end;

procedure TPageUpdate.btnFecharDocumentoClick(Sender: TObject);
begin
  gtDocumentViewer.Size.Height := 0;
end;

procedure TPageUpdate.btnVoltarClick(Sender: TObject);
begin
  TRouter4D.Link.&To('Dashboard');
end;

procedure TPageUpdate.CheckAndUpdateUserInterface;
begin
  if imgFotoRosto.Bitmap.IsEmpty then
    lblSelecioneFOto.Visible := true
  else
    lblSelecioneFOto.Visible := false;

  if gtDocumentViewer.IsDocumentLoaded then
    lblSelecioneLaudo.Visible := false
  else
    lblSelecioneLaudo.Visible := true;
end;

procedure TPageUpdate.FormCreate(Sender: TObject);
begin
  serviceNew := TServiceNew.Create(Self);
  btnFecharDocumentoClick(nil);
end;

procedure TPageUpdate.Props(aValue: TProps);
var
  streamImage: TMemoryStream;
begin
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
    imgFotoRosto.Bitmap.LoadFromStream(serviceNew.GetFilesById(aValue.PropString.ToInteger));
  finally
    Self.CheckAndUpdateUserInterface;
    aValue.Free;
  end;
end;

procedure TPageUpdate.rctFotoRostoClick(Sender: TObject);
begin
  serviceNew.mtCadastroCarteiraPTEA.Edit;
  if dlgFotoRosto.Execute then
    serviceNew.mtCadastroCarteiraPTEAfotoRostoPath.Value := dlgFotoRosto.FileName;
  serviceNew.mtCadastroCarteiraPTEA.Post;

  if dlgFotoRosto.FileName <> EmptyStr then
    begin
      imgFotoRosto.Bitmap := nil;
      imgFotoRosto.Bitmap.LoadFromFile(dlgFotoRosto.FileName);
    end;
  Self.CheckAndUpdateUserInterface;
end;

procedure TPageUpdate.rctLaudoMedicoClick(Sender: TObject);
begin
  serviceNew.mtCadastroCarteiraPTEA.Edit;
  if dlgLaudoMedico.Execute then
    serviceNew.mtCadastroCarteiraPTEALaudoMedicoPath.Value := dlgLaudoMedico.FileName;
  serviceNew.mtCadastroCarteiraPTEA.Post;

  if dlgLaudoMedico.FileName <> EmptyStr then
    begin
      gtDocumentViewer.LoadFromFile(dlgLaudoMedico.FileName);
      lblSelecioneLaudo.Text := 'Arquivo "' + Copy(dlgLaudoMedico.FileName, LastDelimiter('\', dlgLaudoMedico.FileName)
          + 1, Length(dlgLaudoMedico.FileName)) + '" selecionado';
      LayoutZoom.Visible := true;
    end
  else
    begin
      LayoutZoom.Visible := false;
      lblSelecioneLaudo.Text := 'Selecione o laudo m�dico em PDF';
    end;

  Self.CheckAndUpdateUserInterface;
end;

function TPageUpdate.Render: TFmxObject;
begin
  Result := lytUpdate;
  imgFotoRosto.Bitmap := nil;
  gtDocumentViewer.LoadFromStream(nil);
end;

procedure TPageUpdate.retBtnSalvarClick(Sender: TObject);
begin
  serviceNew.mtCadastroCarteiraPTEA.Edit;
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

  serviceNew.StreamFiles;
  TRouter4D.Link.&To('Dashboard');
end;

procedure TPageUpdate.UnRender;
begin
  //
end;

end.
