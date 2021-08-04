program ProjectCIPTEA;

uses
  System.StartUpCopy,
  FMX.Forms,
  FormMain in 'FormMain.pas' {frmMain},
  Providers.PackageBuilder in 'Providers\Providers.PackageBuilder.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
