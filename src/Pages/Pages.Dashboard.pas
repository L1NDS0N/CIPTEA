unit Pages.Dashboard;

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
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.StdCtrls;

type
  TPageDashboard = class(TForm, iRouter4DComponent)
    lytDashboard: TLayout;
    Layout1: TLayout;
    btnNew: TButton;
    Label1: TLabel;
    procedure btnNewClick(Sender: TObject);
    private
      { Private declarations }
    public
      function Render: TFMXObject;
      procedure UnRender;
  end;

var
  PageDashboard: TPageDashboard;

implementation

{$R *.fmx}

{ TfrmDashboard }
uses
  Router4D;

procedure TPageDashboard.btnNewClick(Sender: TObject);
begin
  TRouter4D.Link.&To('New');
end;

function TPageDashboard.Render: TFMXObject;
begin
  Result := lytDashboard;
end;

procedure TPageDashboard.UnRender;
begin

end;

end.
