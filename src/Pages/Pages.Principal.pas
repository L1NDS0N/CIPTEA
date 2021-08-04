unit Pages.Principal;

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
  FMX.Ani,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Layouts;

type
  TPagePrincipal = class(TForm)
    lytBackground: TLayout;
    rctBackground: TRectangle;
    lytPrincipal: TLayout;
    rctPrincipal: TRectangle;
    lytMaster: TLayout;
    VertScrollBox: TVertScrollBox;
    procedure FormCreate(Sender: TObject);
    private
      procedure Router;
    public
      { Public declarations }
  end;

var
  PagePrincipal: TPagePrincipal;

implementation

uses
  Router4D.Interfaces,
  Router4D,
  Pages.Dashboard,
  Pages.New;

{$R *.fmx}

procedure TPagePrincipal.FormCreate(Sender: TObject);
begin
  Self.Router;
end;

procedure TPagePrincipal.Router;
begin
  TRouter4D.Switch.Router('Dashboard', TPageDashboard);
  TRouter4D.Switch.Router('New', TPageNew);

  TRouter4D.Render<TPageDashboard>.SetElement(lytMaster, lytMaster);
end;

Initialization

RegisterClass(TPagePrincipal);

Finalization

UnRegisterClass(TPagePrincipal);

end.
