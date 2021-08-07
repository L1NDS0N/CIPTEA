unit Providers.PackageBuilder;

interface

uses
  System.SysUtils,
  FMX.Forms,
  System.Classes,
  FMX.Dialogs;

procedure AbreFormulario(ClasseForm: String);
procedure CriaPacote(Pacote: String);

implementation

{ TPackageBuilder }

procedure AbreFormulario(ClasseForm: String);

var
  APersistentClass: TPersistentClass;
  AForm: TForm;
begin
  APersistentClass := GetClass(ClasseForm);
  if APersistentClass = nil then
    ShowMessage('Formulario não localizado!')
  else
  begin
    AForm := TComponentClass(APersistentClass).Create(Application) as TForm;
    AForm.ShowModal;
  end;
end;

procedure CriaPacote(Pacote: String);
var
  APackage: array of Cardinal;
  sFile: String;
  _hnd: THandle;
begin
  SetLength(APackage, 0);

  sFile := ExtractFilePath(ParamStr(0)) + Pacote + '\bin\' + Pacote + '.bpl';

  if FileExists(sFile) then
  begin
    SetLength(APackage, Length(APackage) + 1);
    APackage[Length(APackage) - 1] := LoadPackage(sFile);
  end
  else
    ShowMessage('Package não encontrado ' + sFile);
end;

end.
