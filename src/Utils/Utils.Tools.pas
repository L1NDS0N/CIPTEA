unit Utils.Tools;

interface

procedure AbrirLinkNavegador(aUrl: string);
function FormatMaskByEditObject(Sender: TObject; const EditMask: string; const KeyChar: char): string;
function EmailIsValid(aEmail: string): boolean;
function CPFIsValid(aCPF: string): boolean;
function RemoveCaracteresEspeciais(aTexto: string; aLimExt: boolean): string;

implementation

uses
  Winapi.ShellAPI,
  System.SysUtils,
  System.Character,
  System.MaskUtils,
  System.StrUtils,
  System.RegularExpressions,
  FMX.Edit;

procedure AbrirLinkNavegador(aUrl: string);
begin
  ShellExecute(0, 'open', PChar(aUrl), nil, nil, 3);
end;

function RemoveCaracteresEspeciais(aTexto: string; aLimExt: boolean): string;
const
  //xCarEsp: array [1 .. 38] of String = ('á', 'à', 'ã', 'â', 'ä', 'Á', 'À', 'Ã', 'Â', 'Ä', 'é', 'è', 'É', 'È', 'í', 'ì',
  //'Í', 'Ì', 'ó', 'ò', 'ö', 'õ', 'ô', 'Ó', 'Ò', 'Ö', 'Õ', 'Ô', 'ú', 'ù', 'ü', 'Ú', 'Ù', 'Ü', 'ç', 'Ç', 'ñ', 'Ñ');
  //
  //xCarTro: array [1 .. 38] of String = ('a', 'a', 'a', 'a', 'a', 'A', 'A', 'A', 'A', 'A', 'e', 'e', 'E', 'E', 'i', 'i',
  //'I', 'I', 'o', 'o', 'o', 'o', 'o', 'O', 'O', 'O', 'O', 'O', 'u', 'u', 'u', 'u', 'u', 'u', 'c', 'C', 'n', 'N');

  xCarExt: array [1 .. 50] of string = ('.', '-', '<', '>', '!', '@', '#', '$', '%', '¨', '&', '*', '(', ')', '_', '+',
    '=', '{', '}', '[', ']', '?', ';', ':', ',', '|', '*', '"', '~', '^', '´', '`', '¨', 'æ', 'Æ', 'ø', '£', 'Ø', 'ƒ',
    'ª', 'º', '¿', '®', '½', '¼', 'ß', 'µ', 'þ', 'ý', 'Ý');
var
  xTexto: string;
  i: integer;
begin
  xTexto := aTexto;

  //for i := 1 to 38 do
  //xTexto := StringReplace(xTexto, xCarEsp[i], xCarTro[i], [rfReplaceAll]);
  if (aLimExt) then
    for i := 1 to 50 do
      xTexto := StringReplace(xTexto, xCarExt[i], '', [rfReplaceAll]);
  Result := xTexto;
end;

function FormatMaskByEditObject(Sender: TObject; const EditMask: string; const KeyChar: char): string;
begin
  with TEdit(Sender) do
    begin
      Result := Text;
      if (Copy(EditMask, SelStart + 1, 1) = Copy(Text, SelStart + 1, 1)) AND Not(TCharacter.IsControl(KeyChar)) then
        begin
          SelStart := SelStart + 1;
          SelectWord;
        end;

      if TCharacter.IsNumber(KeyChar) then
        begin
          Text.Remove(SelStart);
          Text := Text.Insert(SelStart, KeyChar);
          Result := FormatMaskText(EditMask, Text);
          SelStart := SelStart + 1;
        end;

    end;
end;

function EmailIsValid(aEmail: string): boolean;
const
  EmailRegex = '^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]*[a-zA-Z0-9]+$';
begin
  Result := TRegex.IsMatch(aEmail, EmailRegex);
end;

function CPFIsValid(aCPF: string): boolean;
var
  dig10, dig11: string;
  s, i, r, peso: integer;
begin
  aCPF := RemoveCaracteresEspeciais(aCPF, true);
  //length - retorna o tamanho da string (aCPF é um número formado por 11 dígitos)
  if ((aCPF = '00000000000') or (aCPF = '11111111111') or (aCPF = '22222222222') or (aCPF = '33333333333') or
      (aCPF = '44444444444') or (aCPF = '55555555555') or (aCPF = '66666666666') or (aCPF = '77777777777') or
      (aCPF = '88888888888') or (aCPF = '99999999999') or (length(aCPF) <> 11)) then
    begin
      Result := false;
      exit;
    end;

  //try - protege o código para eventuais erros de conversão de tipo na função StrToInt
  try
    { *-- Cálculo do 1o. Digito Verificador --* }
    s := 0;
    peso := 10;
    for i := 1 to 9 do
      begin
        //StrToInt converte o i-ésimo caractere do aCPF em um número
        s := s + (StrToInt(aCPF[i]) * peso);
        peso := peso - 1;
      end;
    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11)) then
      dig10 := '0'
    else
      str(r: 1, dig10); //converte um número no respectivo caractere numérico

    { *-- Cálculo do 2o. Digito Verificador --* }
    s := 0;
    peso := 11;
    for i := 1 to 10 do
      begin
        s := s + (StrToInt(aCPF[i]) * peso);
        peso := peso - 1;
      end;
    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11)) then
      dig11 := '0'
    else
      str(r: 1, dig11);

    { Verifica se os digitos calculados conferem com os digitos informados. }
    if ((dig10 = aCPF[10]) and (dig11 = aCPF[11])) then
      Result := true
    else
      Result := false;
  except
    Result := false
  end;
end;

end.
