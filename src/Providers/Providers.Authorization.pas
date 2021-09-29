unit Providers.Authorization;

interface

uses
  Horse.JWT,
  Horse.Core.RouterTree;

function Authorization: THorseCallback;

implementation

uses
  Configs.GLOBAL;

function Authorization: THorseCallback;
var
  Config: TConfigGlobal;
begin
  Result := HorseJWT(Config.Secret);
end;

end.
