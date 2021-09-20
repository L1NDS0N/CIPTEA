unit Pages.Print;

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
  FMX.Objects,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.ScrollBox,
  FMX.Memo,
  Router4D.Props,
  FMX.StdCtrls,
  Router4D.Interfaces,
  Services.New,
  FMX.Ani,
  FMX.Printer,
  FMX.Effects;

type
  TPagePrint = class(TForm, iRouter4DComponent)
    lytPrincipal: TLayout;
    rect_frente: TRectangle;
    rect_costas: TRectangle;
    lblNome: TLabel;
    lblResponsavel: TLabel;
    lblDataEmissao: TLabel;
    lblDataNascimento: TLabel;
    lblRG: TLabel;
    lblCPF: TLabel;
    imgFotoRosto: TImage;
    lytHeader: TLayout;
    lblID: TLabel;
    lblTitle: TLabel;
    btnVoltar: TRectangle;
    ColorAnimation2: TColorAnimation;
    lblBtnVoltar: TLabel;
    ColorAnimation3: TColorAnimation;
    VertScrollBox: TVertScrollBox;
    lytInterno: TLayout;
    PrintDialog: TPrintDialog;
    lytButtonPrint: TLayout;
    retBtnSalvar: TRectangle;
    ColorAnimation1: TColorAnimation;
    ShadowEffect1: TShadowEffect;
    lblImprimir: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure retBtnSalvarClick(Sender: TObject);
    private
      serviceNew: TServiceNew;
      procedure LimparCampos;
    public
      function Render: TFmxObject;
      procedure UnRender;
      [Subscribe]
      procedure Props(aValue: TProps);
  end;

var
  PagePrint: TPagePrint;

implementation

uses
  ToastMessage,
  Router4D;

{$R *.fmx}
{ TPagePrint }

procedure TPagePrint.btnVoltarClick(Sender: TObject);
begin
  try
    TRouter4D.Link.&To('Dashboard');
  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para a página principal - ' + E.Message, ttDanger);
  end;

end;

procedure TPagePrint.FormCreate(Sender: TObject);
begin
  serviceNew := TServiceNew.Create(Self);
end;

procedure TPagePrint.LimparCampos;
begin
  lblNome.Text := EmptyStr;
  lblResponsavel.Text := EmptyStr;
  lblDataEmissao.Text := EmptyStr;
  lblDataNascimento.Text := EmptyStr;
  lblRG.Text := EmptyStr;
  lblCPF.Text := EmptyStr;
  lblID.Text := EmptyStr;
end;

procedure TPagePrint.Props(aValue: TProps);
begin
  try
    try
      if (aValue.PropString <> '') and (aValue.Key = 'IdCarteiraToPrint') then
        serviceNew.GetById(aValue.PropString);

      lblID.Text := '#' + aValue.PropString;

      lblNome.Text := serviceNew.mtCadastroCarteiraPTEANomeTitular.AsString;
      lblResponsavel.Text := serviceNew.mtCadastroCarteiraPTEANomeResponsavel.AsString;
      lblDataEmissao.Text := DateToStr(now);
      lblDataNascimento.Text := serviceNew.mtCadastroCarteiraPTEADataNascimento.AsString;
      lblRG.Text := serviceNew.mtCadastroCarteiraPTEARgTitular.AsString;
      lblCPF.Text := serviceNew.mtCadastroCarteiraPTEACpfTitular.AsString;

      imgFotoRosto.Bitmap.LoadFromStream(serviceNew.GetImageStreamById(aValue.PropString.ToInteger));
    finally
      aValue.Free;
    end;
  except
    on E: Exception do
      begin
        TToastMessage.show('Erro durante transferência dos dados da carteirinha #' + aValue.PropString, ttDanger);
        abort;
      end;
  end;
end;

function TPagePrint.Render: TFmxObject;
begin
  Result := lytPrincipal;

  { tempBMP.SaveToFile('c:\temp\debugme.bmp');

    RecFull := RectF(0, 0, aBMP.Width, aBMP.Height);

    RecLeft := RectF(0, 0, round(aBMP.Width / 3),
    round(aBMP.Height / 1));

    aBMP.Canvas.DrawBitmap(tempBMP, RecFull, RecLeft, 50, True);

    aBMP.Canvas.EndScene;

    aBMP.SaveToFile('c:\temp\debugme2.bmp'); }
end;

procedure TPagePrint.retBtnSalvarClick(Sender: TObject);
var
  rectPage, rectContent: TRectF;
  image1: TBitmap;
begin

  if PrintDialog.Execute then
    begin

      with Printer do
        begin
          BeginDoc;
          image1 := VertScrollBox.MakeScreenshot;
          rectPage := RectF(0, 0, 1920, 1080);
          rectContent := RectF(0, 0, round(image1.Width * 8), round(image1.Height * 4.5));
          Canvas.DrawBitmap(image1, rectPage, rectContent, 1, false);
          image1.Free;
          EndDoc;
        end;
    end;
end;

procedure TPagePrint.UnRender;
begin
  Self.LimparCampos;
  imgFotoRosto.Bitmap := nil;
end;

end.
