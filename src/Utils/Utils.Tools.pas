unit Utils.Tools;

interface

procedure AbrirLinkNavegador(aUrl: string);

implementation

uses
  Winapi.ShellAPI;

procedure AbrirLinkNavegador(aUrl: string);
begin
  ShellExecute(0, 'open', PChar(aUrl), nil, nil, 3);
end;

end.
