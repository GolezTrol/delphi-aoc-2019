unit InputUtils;

interface

type
  TIntegerArray = TArray<Integer>;
  TStringArray = TArray<String>;

  TInput = class
    class function IntPerLine(Input: String): TIntegerArray;
  end;

implementation

uses
  Classes, SysUtils;

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
