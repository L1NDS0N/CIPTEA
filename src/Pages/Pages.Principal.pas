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
    btnDeslogar: TRectangle;
    ColorAnimation2: TColorAnimation;
    lblBtnVoltar: TLabel;
    ColorAnimation3: TColorAnimation;
    Layout1: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure btnDeslogarClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    private
      SignToClose: Boolean;
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
  Pages.Login,
  Pages.Dashboard,
  Pages.New,
  Pages.Update,
  Pages.Editor,
  Pages.Print,
  FMX.DialogService,
  FMX.Dialogs;

{$R *.fmx}

procedure TPagePrincipal.btnDeslogarClick(Sender: TObject);
var
  CanClose: Boolean;
begin
  TDialogService.MessageDialog('Tem certeza que deseja desconectar-se?', TMsgDlgType.mtConfirmation,
    FMX.Dialogs.mbYesNo, TMsgDlgBtn.mbNo, 0,
      procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
        Self.FormCloseQuery(Sender, CanClose);
    end);

end;

procedure TPagePrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //TODO - tentar remover a gambiarra paradoxal do SignToClose;
  if Sender is TRectangle then
    begin
      SignToClose := True;
      Self.Close;
    end;

  if Sender is TForm then
    begin
      if SignToClose then
        begin
          SignToClose := False;
          Self.Close;
        end
      else
        Halt(0);
    end;
end;

procedure TPagePrincipal.FormCreate(Sender: TObject);
begin
  Self.Router;
  ProgressBar.Visible := False;
  SignToClose := False;
end;

procedure TPagePrincipal.Router;
begin
  TRouter4D.Switch.Router('Login', TPageLogin);
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
  ProgressBarThread: TThread;
begin
  ProgressBarThread := TThread.CreateAnonymousThread(
    procedure
    begin
      with ProgressBar do
        begin
          Visible := True;
          while not(Value = Max) do
            begin
              Value := TLayout(aLayout).Opacity * 100;
            end;
          Value := 0;
          Visible := False;
        end;
    end);
  TLayout(aLayout).Opacity := 0;
  TLayout(aLayout).AnimateFloat('Opacity', 1, 0.7);
  ProgressBarThread.Start;
end;

Initialization

RegisterClass(TPagePrincipal);

Finalization

UnRegisterClass(TPagePrincipal);

end.
