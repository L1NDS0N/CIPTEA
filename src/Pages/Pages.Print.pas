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
    lblTitle: TLabel;
    btnVoltar: TRectangle;
    ColorAnimation2: TColorAnimation;
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
    iconVoltar: TPath;
    lblCipteaId: TLabel;
    lblID: TLabel;
    btnCopy: TRectangle;
    ColorAnimation7: TColorAnimation;
    ColorAnimation8: TColorAnimation;
    FloatAnimation1: TFloatAnimation;
    iconCopy: TPath;
    procedure btnVoltarClick(Sender: TObject);
    procedure retBtnSalvarClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    private
      PropsKeyValue: string;
      PropsValue: string;
      LServiceCard: TServiceCard;
      procedure LimparCampos;
      procedure NavegarPara(const ALocation: string; const AProps: TProps = nil);
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
  ToastMessage,
  FMX.Platform;

{$R *.fmx}
{ TPagePrint }

function TPagePrint.Render: TFmxObject;
begin
  Result := lytPrincipal;
  LServiceCard := TServiceCard.Create(Self);
end;

procedure TPagePrint.UnRender;
begin
  Self.LimparCampos;
  LServiceCard.Free;
end;

procedure TPagePrint.btnCopyClick(Sender: TObject);
var
  Svc: IFMXClipboardService;
  CipteaId: string;
begin
  if not(LServiceCard.mtCadastroCarteiraPTEACipteaId.IsNull) then
    begin
      CipteaId := LServiceCard.mtCadastroCarteiraPTEACipteaId.AsString;
      if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, Svc) then
        begin
          Svc.SetClipboard(CipteaId);
          TToastMessage.show('Identificador de registro da CIPTEA (' + CipteaId +
              ') copiado para a área de transferência');
        end;
    end;
end;

procedure TPagePrint.btnVoltarClick(Sender: TObject);
begin
  if PropsKeyValue = 'IdCarteiraToPrintFromDashboard' then
    NavegarPara('Dashboard');

  if PropsKeyValue = 'IdCarteiraToPrintFromUpdate' then
    NavegarPara('Update', TProps.Create.Key('IdCarteiraToUpdate').PropString(PropsValue));
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
  if not(imgFotoRosto.Bitmap.IsEmpty) then
    imgFotoRosto.Bitmap := nil;
end;

procedure TPagePrint.NavegarPara(const ALocation: string; const AProps: TProps);
begin
  try
    OpenPrivateRoute(ALocation, AProps);
  except
    on E: Exception do
      TToastMessage.show(E.Message, ttDanger);
  end;
end;

procedure TPagePrint.PropsPrint(aValue: TProps);
begin
  try
    try
      PropsKeyValue := aValue.Key;
      PropsValue := aValue.PropString;
      if (aValue.PropString <> '') and ((PropsKeyValue = 'IdCarteiraToPrintFromDashboard') OR
          (PropsKeyValue = 'IdCarteiraToPrintFromUpdate')) then
        LServiceCard.GetById(aValue.PropString);

      lblID.Text := '#' + LServiceCard.mtCadastroCarteiraPTEACipteaId.AsString;

      lblNome.Text := LServiceCard.mtCadastroCarteiraPTEANomeTitular.AsString;
      lblResponsavel.Text := LServiceCard.mtCadastroCarteiraPTEANomeResponsavel.AsString;
      lblDataEmissao.Text := DateToStr(now);
      lblDataNascimento.Text := LServiceCard.mtCadastroCarteiraPTEADataNascimento.AsString;
      lblRG.Text := LServiceCard.mtCadastroCarteiraPTEARgTitular.AsString;
      lblCPF.Text := LServiceCard.mtCadastroCarteiraPTEACpfTitular.AsString;
      lblCipteaId.Text := LServiceCard.mtCadastroCarteiraPTEACipteaId.AsString;

      imgFotoRosto.Bitmap.LoadFromStream(LServiceCard.GetImageStreamById(aValue.PropString));

    except
      on E: Exception do
        begin
          TToastMessage.show('Erro durante transferência dos dados da carteirinha ' + E.Message, ttDanger);
        end;
    end;
  finally
    aValue.Free;
  end;
end;

procedure TPagePrint.retBtnSalvarClick(Sender: TObject);
var
  rectPage, rectContent: TRectF;
  image1, image2: TBitmap;
begin
  image1 := TBitmap.Create;
  image2 := TBitmap.Create;
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
              NavegarPara('Dashboard');
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

end.
