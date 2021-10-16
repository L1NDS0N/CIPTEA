unit Configs.GLOBAL;

interface

type
  TConfigGlobal = record
    private
      function GetExpires: Integer;
      function GetSecret: string;
      function GetBasePort: Integer;
    public
      property Expires: Integer read GetExpires;
      property Secret: string read GetSecret;
      property BasePort: Integer read GetBasePort;

  end;

implementation

uses
  System.SysUtils;

function TConfigGlobal.GetExpires: Integer;
begin
  Result := GetEnvironmentVariable('CIPTEA_BACKEND_LOGIN_EXPIRE').ToInteger('1');
end;

function TConfigGlobal.GetBasePort: Integer;
begin
  Result := GetEnvironmentVariable('CIPTEA_BACKEND_PORT').ToInteger;
end;

function TConfigGlobal.GetSecret: string;
begin
  Result := GetEnvironmentVariable('CIPTEA_BACKEND_HASH_SECRET');
end;

end.
