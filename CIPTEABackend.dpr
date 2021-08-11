program CIPTEABackend;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  Horse.ETag,
  Horse.Jhonson,
  Horse.Compression,
  Horse.HandleException,
  System.SysUtils,
  Controllers.CarteiraPTEA in 'src\Controllers\Controllers.CarteiraPTEA.pas',
  Services.CarteiraPTEA in 'src\Services\Services.CarteiraPTEA.pas' {ServiceCarteiraPTEA: TDataModule} ,
  Services.Connection in 'src\Services\Services.Connection.pas' {ServiceConnection: TDataModule};

begin
  THorse
  .Use(Compression())
  .Use(Jhonson)
  .Use(ETag)
  .Use(HandleException);

  Controllers.CarteiraPTEA.Registry;

  THorse.Listen(9000);
end.
