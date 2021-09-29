program CIPTEABackend;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  Horse.JWT,
  Horse.ETag,
  Horse.Jhonson,
  Horse.Compression,
  Horse.OctetStream,
  Horse.HandleException,
  System.SysUtils,
  Controllers.CarteiraPTEA in 'src\Controllers\Controllers.CarteiraPTEA.pas',
  Services.CarteiraPTEA in 'src\Services\Services.CarteiraPTEA.pas' {ServiceCarteiraPTEA: TDataModule},
  Services.Connection in 'src\Services\Services.Connection.pas' {ServiceConnection: TDataModule},
  Utils.ImageFormat in 'src\Utils\Utils.ImageFormat.pas',
  Services.User in 'src\Services\Services.User.pas' {ServiceUser: TDataModule},
  Controllers.Auth in 'src\Controllers\Controllers.Auth.pas',
  Providers.Authorization in 'src\Providers\Providers.Authorization.pas';

begin
  ReportMemoryLeaksOnShutdown := True;

  THorse.Use(Compression()).Use(OctetStream).Use(Jhonson).Use(ETag)
    .Use(HandleException);

  Controllers.CarteiraPTEA.Registry;
  Controllers.Auth.Registry;

  THorse.Listen(9000);

end.
