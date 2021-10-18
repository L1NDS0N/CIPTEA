unit Configs.GLOBAL;

interface

type
  TConfigGlobal = record
    private
      function GetExpires: Integer;
      function GetSecret: string;
      function GetBasePort: Integer;
      function GetDBName: string;
      function GetDBPort: Integer;
      function GetDBServer: string;
      function GetDBPassword: string;
      function GetDBUsername: string;
    public
      property Expires: Integer read GetExpires;
      property Secret: string read GetSecret;
      property BasePort: Integer read GetBasePort;
      property DBName: string read GetDBName;
      property DBPort: Integer read GetDBPort;
      property DBServer: string read GetDBServer;
      property DBPassword: string read GetDBPassword;
      property DBUsername: string read GetDBUsername;

  end;

implementation

uses
  Winapi.ShellAPI,
  System.SysUtils;

function TConfigGlobal.GetDBName: string;
begin
  Result := GetEnvironmentVariable('CIPTEA_BACKEND_DATABASE_NAME');
end;

function TConfigGlobal.GetDBPassword: string;
begin
  Result := GetEnvironmentVariable('CIPTEA_BACKEND_DB_PASSWORD');
end;

function TConfigGlobal.GetDBPort: Integer;
begin
  Result := GetEnvironmentVariable('CIPTEA_BACKEND_DB_PORT').ToInteger;
end;

function TConfigGlobal.GetDBServer: string;
begin
  Result := GetEnvironmentVariable('CIPTEA_BACKEND_DB_SERVER');
end;

function TConfigGlobal.GetDBUsername: string;
begin
  Result := GetEnvironmentVariable('CIPTEA_BACKEND_DB_USERNAME');
end;

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
