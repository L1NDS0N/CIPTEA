program CIPTEA;

uses
  System.StartUpCopy,
  FMX.Forms,
  FormMain in 'FormMain.pas' {frmMain},
  Providers.PackageBuilder in 'Providers\Providers.PackageBuilder.pas',
  Services.LocalConnection in 'Services\Services.LocalConnection.pas' {ServiceLocalConnection: TDataModule},
  Services.Auth in 'Services\Services.Auth.pas' {ServiceAuth: TDataModule},
  Configs.GLOBAL in 'Configs\Configs.GLOBAL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
