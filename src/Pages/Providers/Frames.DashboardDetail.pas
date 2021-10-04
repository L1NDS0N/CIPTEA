unit Frames.DashboardDetail;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Ani,
  FMX.Objects,
  FMX.Controls.Presentation,
  Providers.Types,
  FMX.Layouts,
  FMX.Effects;

type
  TFrameDashboardDetail = class(TFrame)
    retContent: TRectangle;
    lblCPFTitular: TLabel;
    lblNomeTitular: TLabel;
    crlDelete: TCircle;
    imgDelete: TPath;
    lineSeparator: TLine;
    crlEdit: TCircle;
    imgEdit: TPath;
    retTop: TRectangle;
    Imagem: TImage;
    rctImagem: TRectangle;
    lblID: TLabel;
    retRight: TRectangle;
    lytButtons: TLayout;
    lytButtonsRight: TLayout;
    lytLabels: TLayout;
    ShadowEffect1: TShadowEffect;
    ColorAnimation1: TColorAnimation;
    ColorAnimation2: TColorAnimation;
    lytLabelsCenter: TLayout;
    ShadowEffect2: TShadowEffect;
    ShadowEffect3: TShadowEffect;
    crlPrint: TCircle;
    imgPrint: TPath;
    ColorAnimation3: TColorAnimation;
    ShadowEffect4: TShadowEffect;
    procedure crlEditClick(Sender: TObject);
    procedure crlDeleteClick(Sender: TObject);
    procedure crlPrintClick(Sender: TObject);
    procedure retTopClick(Sender: TObject);
    private
      FId: string;
      FOnDelete: TEventCallBack;
      FOnUpdate: TEventCallBack;
      FOnPrint: TEventCallBack;
    public
      property Id: string read FId write FId;
      property OnDelete: TEventCallBack read FOnDelete write FOnDelete;
      property OnUpdate: TEventCallBack read FOnUpdate write FOnUpdate;
      property OnPrint: TEventCallBack read FOnPrint write FOnPrint;
  end;

implementation

{$R *.fmx}

procedure TFrameDashboardDetail.crlDeleteClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if Assigned(FOnDelete) then
    FOnDelete(Self, FId);
  {$ENDIF}
end;

procedure TFrameDashboardDetail.crlEditClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if Assigned(FOnUpdate) then
    FOnUpdate(Self, FId);
  {$ENDIF}
end;

procedure TFrameDashboardDetail.crlPrintClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if Assigned(FOnPrint) then
    FOnPrint(Self, FId);
  {$ENDIF}
end;

procedure TFrameDashboardDetail.retTopClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if Assigned(FOnUpdate) then
    FOnUpdate(Self, FId);
  {$ENDIF}
end;

end.
