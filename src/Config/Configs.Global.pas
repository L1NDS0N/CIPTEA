unit Configs.GLOBAL;

interface

type
  TConfigGlobal = record
    private
      function GetExpires: Integer;
      function GetSecret: string;
      function GetBaseURL: string;
    public
      property Expires: Integer read GetExpires;
      property Secret: string read GetSecret;
      property BaseURL: string read GetBaseURL;

  end;

implementation

uses
  System.SysUtils;

function TConfigGlobal.GetBaseURL: string;
begin
  Result := GetEnvironmentVariable('CIPTEA_URL');
end;

function TConfigGlobal.GetExpires: Integer;
begin
  Result := GetEnvironmentVariable('CIPTEA_BACKEND_LOGIN_EXPIRE').ToInteger('1');
end;

function TConfigGlobal.GetSecret: string;
begin
  Result := GetEnvironmentVariable('CIPTEA_BACKEND_HASH_SECRET');
end;

end.
