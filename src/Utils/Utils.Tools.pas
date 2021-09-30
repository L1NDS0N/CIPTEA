unit Utils.Tools;

interface

function MyTimestamp(ADateTime: TDateTime): string;

implementation

uses
  System.DateUtils,
  System.SysUtils;

function MyTimestamp(ADateTime: TDateTime): string;
begin
  Result := IntToStr(DateTimeToUnix(ADateTime) + 10800);
end;

end.
