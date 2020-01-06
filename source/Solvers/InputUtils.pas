unit InputUtils;

interface

uses
  AoC.Types,
  Orbit.Map,
  Asteroid.Map;

type
  TInput = class
    class function IntPerLine(Input: String): TIntegerArray;
    class function IntCommaSeparated(Input: String): TIntegerArray;
    class function IntDigits(Input: String): TIntegerArray;
    class function StringPerLine(Input: String): TStringArray;
    class function StringCommaSeparated(Input: String): TStringArray;
    class function Wire(Input: String): TWire;
    class procedure Range(Input: String; out A, B: Integer);
    class procedure Orbit(Input: String; out Parent, Body: String);
    class function CreateOrbitMap(Input: String): TOrbitMap;
    class function CreateAsteroidMap(Input: String): TAsteroidMap;
  end;

implementation

uses
  Classes, SysUtils;

class function TInput.CreateAsteroidMap(Input: String): TAsteroidMap;
var
  Line: String;
  X, Y: Integer;
  Loc: Char;
begin
  Result := TAsteroidMap.Create;
  try
    Y:= 0;
    for Line in StringPerLine(Input) do
    begin
      X := 0;
      for Loc in Line do
      begin
        if Loc = '#'  then
          Result.Add(X, Y);
        Inc(X);
      end;
      Inc(Y);
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TInput.CreateOrbitMap(Input: String): TOrbitMap;
var
  Orbits: TStringArray;
  Map: TOrbitMap;
  Orbit, Parent, Body: String;
begin
  Orbits := TInput.StringPerLine(Input);
  Map := TOrbitMap.Create;
  try
    for Orbit in Orbits do
    begin
      TInput.Orbit(Orbit, Parent, Body);
      Map.AddBody(Body, Parent);
    end;
  except
    Map.Free;
    raise;
  end;
  Result := Map;
end;

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
      Result[i] := sl[i].ToInt64;
  finally
    sl.Free;
  end;
end;

class function TInput.IntDigits(Input: String): TIntegerArray;
var
  i: Integer;
begin
  SetLength(Result, Length(Input));
  for i := Low(Result) to High(Result) do
    Result[i] := Ord(Input[i+1]) - Ord('0');
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
      Result[i] := sl[i].ToInt64;
  finally
    sl.Free;
  end;
end;

class procedure TInput.Orbit(Input: STring; out Parent, Body: String);
var
  p: Integer;
begin
  p := Pos(')', Input);
  Parent := Copy(Input, 1, p-1);
  Body := Copy(Input, p+1, Length(Input));
end;

class procedure TInput.Range(Input: String; out A, B: Integer);
var
  p: Integer;
begin
  p := Pos('-', Input);
  A := Copy(Input, 1, p-1).ToInt64;
  B := Copy(Input, p+1, Length(Input)).ToInt64;
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
    Delta := Copy(Direction, 2, Length(Direction)).ToInt64();
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
