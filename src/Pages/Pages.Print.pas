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
  Services.Card,
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
    FloatAnimation4: TFloatAnimation;
    procedure btnVoltarClick(Sender: TObject);
    procedure retBtnSalvarClick(Sender: TObject);
    private
      PropsKeyValue: string;
      LServiceCard: TServiceCard;
      procedure LimparCampos;
    public
      function Render: TFmxObject;
      procedure UnRender;
      [Subscribe]
      procedure PropsPrint(aValue: TProps);
  end;

var
  PagePrint: TPagePrint;

implementation

uses
  Providers.PrivateRoute,
  ToastMessage;

{$R *.fmx}
{ TPagePrint }

procedure TPagePrint.btnVoltarClick(Sender: TObject);
begin
  try
    OpenPrivateRoute('Dashboard');
  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para a página principal - ' + E.Message, ttDanger);
  end;
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

procedure TPagePrint.PropsPrint(aValue: TProps);
begin
  try
    try
      PropsKeyValue := aValue.Key;
      if (aValue.PropString <> '') and ((PropsKeyValue = 'IdCarteiraToPrintFromDashboard') OR
          (PropsKeyValue = 'IdCarteiraToPrintFromUpdate')) then
        LServiceCard.GetById(aValue.PropString);

      lblID.Text := '#' + aValue.PropString;

      lblNome.Text := LServiceCard.mtCadastroCarteiraPTEANomeTitular.AsString;
      lblResponsavel.Text := LServiceCard.mtCadastroCarteiraPTEANomeResponsavel.AsString;
      lblDataEmissao.Text := DateToStr(now);
      lblDataNascimento.Text := LServiceCard.mtCadastroCarteiraPTEADataNascimento.AsString;
      lblRG.Text := LServiceCard.mtCadastroCarteiraPTEARgTitular.AsString;
      lblCPF.Text := LServiceCard.mtCadastroCarteiraPTEACpfTitular.AsString;

      imgFotoRosto.Bitmap.LoadFromStream(LServiceCard.GetImageStreamById(aValue.PropString.ToInteger));

    except
      on E: Exception do
        begin
          TToastMessage.show('Erro durante transferência dos dados da carteirinha ' + E.Message, ttDanger);
        end;
    end;
  finally
    FreeAndNil(aValue);
  end;
end;

function TPagePrint.Render: TFmxObject;
begin
  Result := lytPrincipal;
  LServiceCard := TServiceCard.Create(Self);
end;

procedure TPagePrint.retBtnSalvarClick(Sender: TObject);
var
  rectPage, rectContent: TRectF;
  image1, image2: TBitmap;
begin
  try
    try
      VertScrollBox.ScrollBy(0, 1000);
      if PrintDialog.Execute then
        begin
          with Printer do
            begin
              BeginDoc;
              image1 := rect_frente.MakeScreenshot;
              image2 := rect_costas.MakeScreenshot;
              rectPage := RectF(0, 0, 1004, 591);
              rectContent := RectF(0, 0, round(image1.Width * 4), round(image1.Height * 4));
              with Canvas do
                begin
                  DrawBitmap(image1, rectPage, rectContent, 1, true);
                  DrawBitmap(image2, rectPage, RectF(0, round(image1.Height * 3.1), round(image2.Width * 4),
                      round(image2.Height * 4) + round(image1.Height * 3.1)), 1, true);
                end;
              EndDoc;
              TToastMessage.show('Carteirinha enviada para impressão.', ttSuccess);
              try
                OpenPrivateRoute('Dashboard');
              except
                on E: Exception do
                  TToastMessage.show('Erro durante navegação para a página principal - ' + E.Message, ttDanger);
              end;
            end;
        end;
    except
      on E: Exception do
        TToastMessage.show('Erro durante geração do arquivo para impressão - ' + E.Message, ttDanger);
    end;
  finally
    image1.Free;
    image2.Free;
  end;
end;

procedure TPagePrint.UnRender;
begin
  Self.LimparCampos;
  imgFotoRosto.Bitmap := nil;
  LServiceCard.Free;
end;

end.
