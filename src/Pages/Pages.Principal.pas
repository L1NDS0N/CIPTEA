unit Pages.Principal;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Ani,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Layouts,
  Router4D.History,
  FMX.Effects,
  System.Classes;

type
  TPagePrincipal = class(TForm)
    lytBackground: TLayout;
    rctBackground: TRectangle;
    lytPrincipal: TLayout;
    rctPrincipal: TRectangle;
    lytMaster: TLayout;
    VertScrollBox: TVertScrollBox;
    ProgressBar: TProgressBar;
    lytProgress: TLayout;
    procedure FormCreate(Sender: TObject);
    private
      procedure Router;
    public
      procedure Animation(aLayout: TFMXObject);
      procedure ProgressBarAnimation(aProgressBar: TFMXObject);
  end;

var
  PagePrincipal: TPagePrincipal;

implementation

uses
  Router4D.Interfaces,
  Router4D,
  Pages.Dashboard,
  Pages.New,
  Pages.Update,
  Pages.Editor,
  Pages.Print,
  FMX.Dialogs;

{$R *.fmx}

procedure TPagePrincipal.FormCreate(Sender: TObject);
begin
  Self.Router;
  ProgressBar.Visible := false;
end;

procedure TPagePrincipal.ProgressBarAnimation(aProgressBar: TFMXObject);
begin
  with TProgressBar(aProgressBar) do
    begin
      Value := 0;
      while not(Value = Max) do
        begin
          Value := Value + 1;

        end;
    end;

end;

procedure TPagePrincipal.Router;
begin
  TRouter4D.Switch.Router('Dashboard', TPageDashboard);
  TRouter4D.Switch.Router('Update', TPageUpdate);
  TRouter4D.Switch.Router('New', TPageNew);
  TRouter4D.Switch.Router('Editor', TPageEditor);
  TRouter4D.Switch.Router('Print', TPagePrint);
  TRouter4D.Render<TPageDashboard>.SetElement(lytMaster, lytMaster);
  TRouter4D.Link.Animation(Animation);
end;

procedure TPagePrincipal.Animation(aLayout: TFMXObject);
var
  myThread: TThread;
begin
  myThread := TThread.CreateAnonymousThread(
      procedure
    begin
      with ProgressBar do
        begin
          Visible := true;
          while not(Value = Max) do
            begin
              Value := TLayout(aLayout).Opacity * 100;
            end;
          Value := 0;
          Visible := false;
        end;
    end);
  TLayout(aLayout).Opacity := 0;
  TLayout(aLayout).AnimateFloat('Opacity', 1, 0.7);
  myThread.Start;
end;

Initialization

RegisterClass(TPagePrincipal);

Finalization

UnRegisterClass(TPagePrincipal);

end.
