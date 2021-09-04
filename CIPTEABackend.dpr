program CIPTEABackend;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  Horse.ETag,
  Horse.Jhonson,
  Horse.Compression,
  Horse.OctetStream,
  Horse.HandleException,
  System.SysUtils,
  Controllers.CarteiraPTEA in 'src\Controllers\Controllers.CarteiraPTEA.pas',
  Services.CarteiraPTEA in 'src\Services\Services.CarteiraPTEA.pas' {ServiceCarteiraPTEA: TDataModule},
  Services.Connection in 'src\Services\Services.Connection.pas' {ServiceConnection: TDataModule},
  Utils.ImageFormat in 'src\Utils\Utils.ImageFormat.pas';

begin
  THorse.Use(Compression()).Use(OctetStream).Use(Jhonson).Use(ETag).Use(HandleException);

  Controllers.CarteiraPTEA.Registry;

  THorse.Listen(9000);

end.
