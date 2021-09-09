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
  Providers.Types;

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
    FloatAnimation1: TFloatAnimation;
    retTop: TRectangle;
    Imagem: TImage;
    rctImagem: TRectangle;
    lblID: TLabel;
    retRight: TRectangle;
    procedure crlEditClick(Sender: TObject);
    procedure retContentClick(Sender: TObject);
    procedure crlDeleteClick(Sender: TObject);
    private
      FId: string;
      FOnDelete: TEventCallBack;
      FOnUpdate: TEventCallBack;
    public
      property Id: string read FId write FId;
      property OnDelete: TEventCallBack read FOnDelete write FOnDelete;
      property OnUpdate: TEventCallBack read FOnUpdate write FOnUpdate;
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

procedure TFrameDashboardDetail.retContentClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if Assigned(FOnUpdate) then
    FOnUpdate(Self, FId);
  {$ENDIF}
end;

end.
