unit InputUtils;

interface

uses
  AoC.Types;

type
  TInput = class
    class function IntPerLine(Input: String): TIntegerArray;
    class function IntCommaSeparated(Input: String): TIntegerArray;
  end;

implementation

uses
  Classes, SysUtils;

class function TInput.IntCommaSeparated(Input: String): TIntegerArray;
var
  i: Integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.StrictDelimiter := True;
    sl.Delimiter := ',';
    sl.DelimitedText := Input;
    SetLength(Result, sl.Count);
    for i := 0 to sl.Count - 1 do
      Result[i] := sl[i].ToInteger;
  finally
    sl.Free;
  end;
end;

class function TInput.IntPerLine(Input: String): TIntegerArray;
var
  i: Integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Text := Input;
    SetLength(Result, sl.Count);
    for i := 0 to sl.Count - 1 do
      Result[i] := sl[i].ToInteger;
  finally
    sl.Free;
  end;
end;

end.
