unit Controllers.Downloads;

interface

uses
  System.SysUtils;

procedure Registry;

implementation

uses
  Horse,
  System.Net.Mime,
  System.Classes;

procedure DoDownloadDB(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LStream: TFileStream;
  FullPath: string;
  aType: string;
  aKind: TMimeTypes.TKind;
begin

  FullPath := ExtractFileDir(ParamStr(0)) + '\static\downloads\CIPTEA_CLIENT_DATABASE.db3';
  try
    if FileExists(FullPath) then
      begin
        LStream := TFileStream.Create(FullPath, fmOpenRead);
        LStream.Position := 0;

        TMimeTypes.Default.GetFileInfo(FullPath, aType, aKind);
        Res.Send<TStream>(LStream).ContentType(aType).Status(THTTPStatus.OK);
      end
    else
      Res.Status(THTTPStatus.NoContent);
  except
    on E: Exception do
      raise EHorseException.Create(THTTPStatus.InternalServerError, 'Erro desconhecido no servidor');
  end;

end;

procedure DoGetConnection(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Status(THTTPStatus.NoContent);
end;

procedure Registry;
begin
  THorse.Get('/downloads/db', DoDownloadDB);
  THorse.Get('/connectivity', DoGetConnection);
end;

end.
