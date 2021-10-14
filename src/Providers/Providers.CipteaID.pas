unit Providers.CipteaID;

interface

function GerarCipteaId: string;
function ValidarCipteaId(num: String): Boolean;

implementation

uses
  Services.CarteiraPTEA,
  System.SysUtils;

function ValidarCipteaId(num: String): Boolean;
var
  d10, d11: Integer;
  d: array [1 .. 9] of Integer;
  digitado, calculado: string;
  LService: TServiceCarteiraPTEA;
begin
  d[1] := StrToInt(num[1]);
  d[2] := StrToInt(num[2]);
  d[3] := StrToInt(num[3]);
  d[4] := StrToInt(num[4]);
  d[5] := StrToInt(num[5]);
  d[6] := StrToInt(num[6]);
  d[7] := StrToInt(num[7]);
  d[8] := StrToInt(num[8]);
  d[9] := StrToInt(num[9]);

  d10 := d[1] * 10 + d[2] * 9 + d[3] * 8 + d[4] * 7 + d[5] * 6 + d[6] * 5 + d[7] * 4 + d[8] * 3 + d[9] * 2;

  d10 := 11 - (d10 mod 11);
  if d10 >= 10 then
    d10 := 0;

  d11 := d[1] * 11 + d[2] * 10 + d[3] * 9 + d[4] * 8 + d[5] * 7 + d[6] * 6 + d[7] * 5 + d[8] * 4 + d[9] * 3 + d10 * 2;
  d11 := 11 - (d11 mod 11);
  if d11 >= 10 then
    d11 := 0;

  calculado := IntToStr(d10) + IntToStr(d11);
  digitado := num[10] + num[11];

  LService := TServiceCarteiraPTEA.Create(nil);
  try
    if (LService.GetByFieldValue('CipteaId', num).IsEmpty) then
      begin
        if calculado = digitado then
          Result := true
        else
          Result := false;
      end
    else
      Result := false;
  finally
    LService.Free;
  end;
end;

function GerarCipteaId: string;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9, d1, d2: LongInt;
begin
  randomize;
  n1 := Trunc(Random(10));
  n2 := Trunc(Random(10));
  n3 := Trunc(Random(10));
  n4 := Trunc(Random(10));
  n5 := Trunc(Random(10));
  n6 := Trunc(Random(10));
  n7 := Trunc(Random(10));
  n8 := Trunc(Random(10));
  n9 := Trunc(Random(10));

  d1 := (n9 * 2) + (n8 * 3) + (n7 * 4) + (n6 * 5) + (n5 * 6) + (n4 * 7) + (n3 * 8) + (n2 * 9) + (n1 * 10);

  d1 := 11 - (d1 mod 11);

  if (d1 >= 10) then
    d1 := 0;
  d2 := (d1 * 2) + (n9 * 3) + (n8 * 4) + (n7 * 5) + (n6 * 6) + (n5 * 7) + (n4 * 8) + (n3 * 9) + (n2 * 10) + (n1 * 11);

  d2 := 11 - (d2 mod 11);

  if (d2 >= 10) then
    d2 := 0;

  Result := IntToStr(n1) + IntToStr(n2) + IntToStr(n3) + IntToStr(n4) + IntToStr(n5) + IntToStr(n6) + IntToStr(n7) +
    IntToStr(n8) + IntToStr(n9) + IntToStr(d1) + IntToStr(d2);
end;

end.
