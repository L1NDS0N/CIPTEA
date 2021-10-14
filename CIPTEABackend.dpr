program CIPTEABackend;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  Horse.JWT,
  Horse.ETag,
  Horse.Jhonson,
  Horse.Paginate,
  Horse.Compression,
  Horse.OctetStream,
  Horse.HandleException,
  System.SysUtils,
  Controllers.CarteiraPTEA in 'src\Controllers\Controllers.CarteiraPTEA.pas',
  Services.CarteiraPTEA in 'src\Services\Services.CarteiraPTEA.pas' {ServiceCarteiraPTEA: TDataModule} ,
  Services.Connection in 'src\Services\Services.Connection.pas' {ServiceConnection: TDataModule} ,
  Utils.ImageFormat in 'src\Utils\Utils.ImageFormat.pas',
  Services.User in 'src\Services\Services.User.pas' {ServiceUser: TDataModule} ,
  Controllers.Auth in 'src\Controllers\Controllers.Auth.pas',
  Providers.Authorization in 'src\Providers\Providers.Authorization.pas',
  Configs.Global in 'src\Config\Configs.Global.pas',
  Utils.Tools in 'src\Utils\Utils.Tools.pas',
  Providers.CipteaID in 'src\Providers\Providers.CipteaID.pas',
  Controllers.Downloads in 'src\Controllers\Controllers.Downloads.pas';

begin
  ReportMemoryLeaksOnShutdown := True;

  THorse.Use(Compression()).Use(OctetStream).Use(Paginate).Use(Jhonson).Use(ETag).Use(HandleException);

  Controllers.CarteiraPTEA.Registry;
  Controllers.Auth.Registry;
  Controllers.Downloads.Registry;

  THorse.Listen(9000,
      procedure(Horse: THorse)
    begin
      Writeln('O Servidor está rodando na porta ' + THorse.Port.ToString);
      Write('Pressione enter para parar...');
      ReadLn;
      THorse.StopListen;
    end);

end.
