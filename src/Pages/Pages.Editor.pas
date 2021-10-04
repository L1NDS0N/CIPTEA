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
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Filter.Effects,
  FMX.Effects,
  FMX.Layouts,
  FMX.ExtCtrls,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Ani,
  Services.New,
  Router4D.Props,
  FireDAC.Comp.Client,
  System.UITypes,
  FMX.Edit,
  FMX.EditBox,
  FMX.ComboTrackBar,
  FMX.Colors,
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
    lblBtnVoltar: TLabel;
    ColorAnimation3: TColorAnimation;
    Button1: TButton;
    rect_fundo_foto: TRectangle;
    rect_fundo: TRectangle;
    ShadowEffect2: TShadowEffect;
    FloatAnimation4: TFloatAnimation;
    procedure retBtnSalvarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure ImageViewer1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure ImageViewer1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ImageViewer1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure Button1Click(Sender: TObject);
    procedure track_zoomChange(Sender: TObject);
    procedure ImageViewer1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    private
      ServiceNew: TServiceNew;
      qryFiles: TFDQuery;
      AId: string;
      MouseIsDown: Boolean;
      PX, PY: Single;
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
  ToastMessage;

{$R *.fmx}

procedure TPageEditor.btnVoltarClick(Sender: TObject);
begin
  try
    OpenPrivateRoute('Update', TProps.Create.PropString(AId).Key('IdCarteiraToUpdate'));
  except
    on E: Exception do
      begin
        TToastMessage.show('Erro durante navegação para página de edição - ' + E.Message, ttDanger);
      end;
  end;
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

procedure TPageEditor.Props(aValue: TProps);
begin
  try
    try
      if (aValue.PropString <> '') and (aValue.Key = 'IdCarteiraToFotoEdit') then
        begin
          AId := aValue.PropString;
          lblID.Text := '#' + AId;
          //verificar se contém arquivos na nuvem.
          //ServiceNew.GetFiles;
        end;
      ServiceNew.qryTemp.Close;
      ServiceNew.qryTemp.Open;
      ServiceNew.qryTemp.First;
      rect_fundo_foto.Fill.Bitmap.Bitmap.LoadFromFile(ServiceNew.qryTempFotoRostoPath.Value);
      ImageViewer1.Bitmap.LoadFromFile(ServiceNew.qryTempFotoRostoPath.Value);
    except
      on E: Exception do
        begin
          TToastMessage.show('Erro durante transferência de dados para a página de edição - ' + E.Message, ttDanger);
        end;
    end;
  finally
    FreeAndNil(aValue);
  end;
end;

function TPageEditor.Render: TFmxObject;
begin
  Result := LayoutEditor;
  ServiceNew := TServiceNew.Create(Self);
end;

procedure TPageEditor.retBtnSalvarClick(Sender: TObject);
var
  vFotoStream: TMemoryStream;
begin
  try
    try
      vFotoStream := TMemoryStream.Create;
      ImageViewer1.MakeScreenshot.SaveToStream(vFotoStream);

      //abrir a query arquivos carteira
      qryFiles := ServiceNew.GetFileById(AId.ToInteger);

      if ServiceNew.qryArquivosCarteiraPTEA.IsEmpty then
        begin
          ServiceNew.qryArquivosCarteiraPTEA.Insert;
          ServiceNew.qryArquivosCarteiraPTEAIDCarteira.Value := AId.ToInteger;
          ServiceNew.qryArquivosCarteiraPTEAFotoStream.LoadFromStream(vFotoStream);
          ServiceNew.qryArquivosCarteiraPTEA.Post;
        end
      else
        begin
          ServiceNew.qryArquivosCarteiraPTEA.Edit;
          ServiceNew.qryArquivosCarteiraPTEAFotoStream.LoadFromStream(vFotoStream);
          ServiceNew.qryArquivosCarteiraPTEA.Post;
        end;

      ServiceNew.PostStreamFoto(AId);
      try
        OpenPrivateRoute('Update', TProps.Create.PropString(AId).Key('IdCarteiraToUpdate'));
      except
        on E: Exception do
          TToastMessage.show('Erro durante navegação para página de edição -' + E.Message, ttDanger);
      end;
      TToastMessage.show('A imagem foi salva com sucesso', ttSuccess);

    except
      on E: Exception do
        TToastMessage.show('Erro durante gravação da foto - ' + E.Message, ttDanger);
    end;
  finally
    vFotoStream.Free;
  end;
end;

procedure TPageEditor.track_zoomChange(Sender: TObject);
begin
  ImageViewer1.BitmapScale := track_zoom.Value;
end;

procedure TPageEditor.UnRender;
begin
  ServiceNew.Free;
  rect_fundo_foto.Fill.Bitmap.Bitmap := (nil);
  ImageViewer1.Bitmap := (nil);
end;

end.
