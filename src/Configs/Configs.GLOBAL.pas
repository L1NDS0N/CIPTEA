unit Configs.GLOBAL;

interface

type
  TConfigGlobal = record
    private
      function GetExpires: Integer;
      function GetSecret: string;
      function GetBaseURL: string;
      function GetBasePort: string;
      function GetBaseHost: string;
      function GetDBDir: string;

    public
      property Expires: Integer read GetExpires;
      property Secret: string read GetSecret;
      property BaseURL: string read GetBaseURL;
      property BasePort: string read GetBasePort;
      property BaseHost: string read GetBaseHost;
      property DBDir: string read GetDBDir;

  end;

implementation

uses
  System.SysUtils;

function TConfigGlobal.GetBaseHost: string;
begin
  Result := GetEnvironmentVariable('CIPTEA_HOST');
end;

function TConfigGlobal.GetBasePort: string;
begin
  Result := GetEnvironmentVariable('CIPTEA_PORT');
end;

function TConfigGlobal.GetBaseURL: string;
begin
  Result := ('http://' + GetEnvironmentVariable('CIPTEA_HOST') + ':' + BasePort);
end;

function TConfigGlobal.GetDBDir: string;
begin
  Result := GetEnvironmentVariable('CIPTEA_DBDIR');
end;

function TConfigGlobal.GetExpires: Integer;
begin
  Result := GetEnvironmentVariable('LOGIN_EXPIRE').ToInteger('1');
end;

function TConfigGlobal.GetSecret: string;
begin
  Result := GetEnvironmentVariable('LOGIN_SECRET');
end;

end.
