unit InputUtils;

interface

uses
  AoC.Types;

type
  TInput = class
    class function IntPerLine(Input: String): TIntegerArray;
    class function IntCommaSeparated(Input: String): TIntegerArray;
    class function StringPerLine(Input: String): TStringArray;
    class function StringCommaSeparated(Input: String): TStringArray;
    class function Wire(Input: String): TWire;
    class procedure Range(Input: String; out A, B: Integer);
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

class procedure TInput.Range(Input: String; out A, B: Integer);
var
  p: Integer;
begin
  p := Pos('-', Input);
  A := Copy(Input, 1, p-1).ToInteger;
  B := Copy(Input, p+1, Length(Input)).ToInteger;
end;

class function TInput.StringCommaSeparated(Input: String): TStringArray;
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
      Result[i] := sl[i];
  finally
    sl.Free;
  end;
end;

class function TInput.StringPerLine(Input: String): TStringArray;
var
  i: Integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Text := Input;
    SetLength(Result, sl.Count);
    for i := 0 to sl.Count - 1 do
      Result[i] := sl[i];
  finally
    sl.Free;
  end;
end;

class function TInput.Wire(Input: String): TWire;
var
  Directions: TStringArray;
  Location: TGridLocation;
  Index: Integer;
  Direction: String;
  Delta: Integer;
begin
  Index := 1;
  Directions := StringCommaSeparated(Input);
  SetLength(Result, Length(Directions)+1);
  Location := TGridLocation.Create(0, 0);
  Result[0] := Location;
  for Direction in Directions do
  begin
    Delta := Copy(Direction, 2, Length(Direction)).ToInteger();
    case Direction[1] of
      'R': Inc(Location.X, Delta);
      'L': Dec(Location.X, Delta);
      'D': Inc(Location.Y, Delta);
      'U': Dec(Location.Y, Delta);
    end;
    Result[Index] := Location;
    Inc(Index);
  end;
end;

end.
