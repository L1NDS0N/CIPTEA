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
  Router4D,
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
    procedure retBtnSalvarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure ImageViewer1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure ImageViewer1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ImageViewer1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure Button1Click(Sender: TObject);
    procedure track_zoomChange(Sender: TObject);
    procedure ImageViewer1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
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

{$R *.fmx}

procedure TPageEditor.btnVoltarClick(Sender: TObject);
begin
  TRouter4D.Link.&To('Update', TProps.Create.PropString(AId).Key('IdCarteiraToUpdate'));
end;

procedure TPageEditor.Button1Click(Sender: TObject);
begin
  ImageViewer1.Bitmap.Rotate(-90);
end;

procedure TPageEditor.FormCreate(Sender: TObject);
begin
  ServiceNew := TServiceNew.Create(Self);
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
  AId := aValue.PropString;
  lblID.Text := '#' + AId;
  if (aValue.PropString <> '') and (aValue.Key = 'IdCarteiraToUpdate') then
    qryFiles := ServiceNew.GetFileById(aValue.PropString.ToInteger());

  ServiceNew.qryTemp.Close;
  ServiceNew.qryTemp.Open;
  ServiceNew.qryTemp.First;
  ImageViewer1.Bitmap.LoadFromFile(ServiceNew.qryTempFotoRostoPath.Value);
end;

function TPageEditor.Render: TFmxObject;
begin
  Result := LayoutEditor;

end;

procedure TPageEditor.retBtnSalvarClick(Sender: TObject);
var
  vFotoStream: TMemoryStream;
begin
  try
    vFotoStream := TMemoryStream.Create;
    ImageViewer1.MakeScreenshot.SaveToStream(vFotoStream);

    ServiceNew.qryArquivosCarteiraPTEA.Edit;
    ServiceNew.qryArquivosCarteiraPTEAFotoStream.LoadFromStream(vFotoStream);
    ServiceNew.qryArquivosCarteiraPTEA.Post;

    ServiceNew.PostStreamFoto(AId);

    TRouter4D.Link.&To('Update', TProps.Create.PropString(AId).Key('IdCarteiraToUpdate'));
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
  ImageViewer1.Bitmap := nil;
end;

end.
