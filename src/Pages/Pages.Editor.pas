unit Pages.Editor;

interface

uses
  Router4D.Interfaces,
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Filter.Effects,
  FMX.Effects,
  FMX.Layouts,
  FMX.ExtCtrls,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Ani,
  Services.Card,
  Router4D.Props,
  FireDAC.Comp.Client,
  System.UITypes,
  FMX.Edit,
  FMX.EditBox,
  FMX.ComboTrackBar,
  FMX.Printer;

type
  TPageEditor = class(TForm, iRouter4DComponent)
    layout_edit: TLayout;
    track_zoom: TTrackBar;
    rect_foto: TRectangle;
    ImageViewer1: TImageViewer;
    retBtnSalvar: TRectangle;
    ColorAnimation1: TColorAnimation;
    ShadowEffect1: TShadowEffect;
    lblSalvar: TLabel;
    LayoutEditor: TLayout;
    lytHeader: TLayout;
    lblID: TLabel;
    lblTitle: TLabel;
    btnVoltar: TRectangle;
    ColorAnimation2: TColorAnimation;
    ColorAnimation3: TColorAnimation;
    Button1: TButton;
    rect_fundo_foto: TRectangle;
    rect_fundo: TRectangle;
    ShadowEffect2: TShadowEffect;
    FloatAnimation4: TFloatAnimation;
    iconVoltar: TPath;
    procedure retBtnSalvarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure ImageViewer1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure ImageViewer1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ImageViewer1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure Button1Click(Sender: TObject);
    procedure track_zoomChange(Sender: TObject);
    procedure ImageViewer1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    private
      LServiceCard: TServiceCard;
      qryFiles: TFDQuery;
      AId: string;
      MouseIsDown: Boolean;
      PX, PY: Single;
      procedure NavegarPara(const ALocation: string; const AProps: TProps = nil);
    public
      [Subscribe]
      procedure Props(aValue: TProps);
      function Render: TFmxObject;
      procedure UnRender;
  end;

var
  PageEditor: TPageEditor;

implementation

uses
  Providers.PrivateRoute,
  ToastMessage,
  FMX.Graphics,
  FMX.Surfaces,
  System.Generics.Collections;

{$R *.fmx}

procedure TPageEditor.btnVoltarClick(Sender: TObject);
begin
  NavegarPara('Update', TProps.Create.PropString(AId).Key('IdCarteiraToUpdate'));
end;

procedure TPageEditor.Button1Click(Sender: TObject);
begin
  ImageViewer1.Bitmap.Rotate(-90);
end;

procedure TPageEditor.ImageViewer1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Button = TMouseButton(0) then
    begin
      MouseIsDown := true;
      PX := X;
      PY := Y;
    end;
end;

procedure TPageEditor.ImageViewer1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  if MouseIsDown then
    begin
      ImageViewer1.ScrollBy((X - PX) / 12, (Y - PY) / 12);
    end;
end;

procedure TPageEditor.ImageViewer1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  MouseIsDown := false;
end;

procedure TPageEditor.ImageViewer1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
  var Handled: Boolean);
begin
  track_zoom.Value := ImageViewer1.BitmapScale;
end;

procedure TPageEditor.NavegarPara(const ALocation: string; const AProps: TProps);
begin
  try
    OpenPrivateRoute(ALocation, AProps);
  except
    on E: Exception do
      TToastMessage.show(E.Message, ttDanger);
  end;
end;

procedure TPageEditor.Props(aValue: TProps);
var
  vPropValue: TDictionary<String, String>;
  vFilename: string;
begin
  try
    try
      if not(aValue.PropValue.IsEmpty) and (aValue.Key = 'DataToPhotoEdit') then
        begin
          vPropValue := aValue.PropValue.AsType<TDictionary<String, String>>;

          AId := vPropValue.Items['CardIdToEditPhoto'];
          vFilename := vPropValue.Items['Filename'];
          lblID.Text := '#' + AId;

          rect_fundo_foto.Fill.Bitmap.Bitmap.LoadFromFile(vFilename);
          ImageViewer1.Bitmap.LoadFromFile(vFilename);
        end;

    except
      on E: Exception do
        begin
          TToastMessage.show('Erro durante transferência de dados para a página de edição de fotos - ' + E.Message,
            ttDanger);
        end;
    end;
  finally
    aValue.Free;
    vPropValue.Free;
  end;
end;

function TPageEditor.Render: TFmxObject;
begin
  Result := LayoutEditor;
  LServiceCard := TServiceCard.Create(Self);
end;

procedure TPageEditor.retBtnSalvarClick(Sender: TObject);
var
  vFotoStream: TMemoryStream;
  BitSurf: TBitmapSurface;
begin
  BitSurf := TBitmapSurface.Create;
  vFotoStream := TMemoryStream.Create;
  try
    try

      BitSurf.Assign(ImageViewer1.MakeScreenshot.CreateThumbnail(354, 472));
      TBitmapCodecManager.SaveToStream(vFotoStream, BitSurf, 'jpg', nil);

      //abrir a query arquivos carteira
      qryFiles := LServiceCard.GetFileById(AId.ToInteger);

      if LServiceCard.qryArquivosCarteiraPTEA.IsEmpty then
        begin
          LServiceCard.qryArquivosCarteiraPTEA.Insert;
          LServiceCard.qryArquivosCarteiraPTEAIDCarteira.Value := AId.ToInteger;
          LServiceCard.qryArquivosCarteiraPTEAFotoStream.LoadFromStream(vFotoStream);
          LServiceCard.qryArquivosCarteiraPTEA.Post;
        end
      else
        begin
          LServiceCard.qryArquivosCarteiraPTEA.Edit;
          LServiceCard.qryArquivosCarteiraPTEAFotoStream.LoadFromStream(vFotoStream);
          LServiceCard.qryArquivosCarteiraPTEA.Post;
        end;

      LServiceCard.PostStreamFoto(AId);

      NavegarPara('Update', TProps.Create.PropString(AId).Key('IdCarteiraToUpdate'));

      TToastMessage.show('A imagem foi salva com sucesso', ttSuccess);

    except
      on E: Exception do
        TToastMessage.show('Erro durante gravação da foto - ' + E.Message, ttDanger);
    end;
  finally
    vFotoStream.Free;
    BitSurf.Free;
  end;
end;

procedure TPageEditor.track_zoomChange(Sender: TObject);
begin
  ImageViewer1.BitmapScale := track_zoom.Value;
end;

procedure TPageEditor.UnRender;
begin
  LServiceCard.Free;
  rect_fundo_foto.Fill.Bitmap.Bitmap := nil;
  ImageViewer1.Bitmap := nil;

end;

end.
