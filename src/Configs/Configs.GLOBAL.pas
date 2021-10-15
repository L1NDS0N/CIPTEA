unit Configs.GLOBAL;

interface

type
  TConfigGlobal = record
    private
      function GetBaseURL: string;
      function GetBasePort: string;
      function GetBaseHost: string;
      function GetDBDir: string;

    public
      property BaseURL: string read GetBaseURL;
      property BasePort: string read GetBasePort;
      property BaseHost: string read GetBaseHost;
      property DBDir: string read GetDBDir;
  end;

procedure SetEnvironmentVar(aEnvVar, aValue: string);

implementation

uses
  Winapi.ShellAPI,
  Winapi.Messages,
  System.SysUtils,
  Winapi.Windows;

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

procedure SetEnvironmentVar(aEnvVar, aValue: string);
var
  cmdline: string;
begin
  cmdline := '/C setx ' + aEnvVar + ' "' + aValue + '"';
  ShellExecute(0, nil, 'cmd.exe', PWideChar(cmdline), nil, SW_HIDE);
  SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0, NativeInt(PChar('Environment')), SMTO_ABORTIFHUNG, 5000, nil);
end;

end.
