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
  FMX.Layouts,
  Router4D.History;

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
      procedure Animation(aLayout: TFMXObject);
  end;

var
  PagePrincipal: TPagePrincipal;

implementation

uses
  Router4D.Interfaces,
  Router4D,
  Pages.Dashboard,
  Pages.New,
  Pages.Update;

{$R *.fmx}

procedure TPagePrincipal.FormCreate(Sender: TObject);
begin
  Self.Router;
end;

procedure TPagePrincipal.Router;
begin
  TRouter4D.Switch.Router('Dashboard', TPageDashboard);
  TRouter4D.Switch.Router('Update', TPageUpdate);
  TRouter4D.Switch.Router('New', TPageNew);
  TRouter4D.Render<TPageDashboard>.SetElement(lytMaster, lytMaster);
  TRouter4D.Link.Animation(Animation);
end;

procedure TPagePrincipal.Animation(aLayout: TFMXObject);
begin
  TLayout(aLayout).Opacity := 0;
  TLayout(aLayout).AnimateFloat('Opacity', 1, 0.9);
end;

Initialization

RegisterClass(TPagePrincipal);

Finalization

UnRegisterClass(TPagePrincipal);

end.
