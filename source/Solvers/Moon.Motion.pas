unit Moon.Motion;

interface

uses
  AoC.Types,
  SysUtils,
  System.TypInfo;

type
  TDimension = (X, Y, Z);
  TVector = array[TDimension] of Integer;

  TMoon = record
    Position, Velocity: TVector;
    function GetEnergy: Integer;
  end;

  TMoons = TArray<TMoon>;

  TMoonMotion = class
  public
    class procedure StepGravity(var Moons: TMoons);
    class function GetMoonsEnergy(const Moons: TMoons): Integer;
    class function StepsUntilRepeat(const Moons: TMoons): TAoCInt;
  end;

implementation

uses
  Math;

{ TMoonMotion }

class function TMoonMotion.GetMoonsEnergy(const Moons: TMoons): Integer;
var
  Moon: TMoon;
begin
  Result := 0;
  for Moon in Moons do
    Inc(Result, Moon.GetEnergy);
end;

class procedure TMoonMotion.StepGravity(var Moons: TMoons);
var
  i, j: Integer;
  d: TDimension;
  Diff: Integer;
begin
  for i := 0 to High(Moons) - 1 do
    for j := i + 1 to High(Moons) do
      for d := Low(TDimension) to High(TDimension) do
      begin
        Diff := Sign(Moons[j].Position[d] - Moons[i].Position[d]);
        Inc(Moons[i].Velocity[d], Diff);
        Dec(Moons[j].Velocity[d], Diff);
      end;

  for i := 0 to High(Moons) do
    for d := Low(TDimension) to High(TDimension) do
      Inc(Moons[i].Position[d], Moons[i].Velocity[d]);

end;

class function TMoonMotion.StepsUntilRepeat(const Moons: TMoons): TAoCInt;
var
  Count: array[TDimension] of Int64;
  States: array of TMoons;
  Index: Integer;
  i: Integer;
  m: Integer;
  d: TDimension;
  Ok: Integer;
  LCM: array[TDimension] of Int64;
begin
  Count[X] := 0; Count[Y] := 0; Count[Z] := 0;

  SetLength(States, 10000);
  States[0] := Moons;

  Index := 0;
  repeat
    if Length(States) = Index + 1 then
      SetLength(States, Length(States) * 2);

    Inc(Index);
    States[Index] := Copy(States[Index-1], 0, Length(Moons));
    TMoonMotion.StepGravity(States[Index]);

    for i := 0 to 0{Index - 1} do
    begin
      for d := Low(TDimension) to High(TDimension) do
      begin
        if (Count[d] = 0) then
        begin
          Ok := 0;
          for m := Low(Moons) to High(Moons) do
            if (States[i][m].Position[d] = States[Index][m].Position[d]) and
             (States[i][m].Velocity[d] = States[Index][m].Velocity[d]) then
              Inc(Ok)
            else
              Break;
          if OK = Length(Moons) then
            Count[d] := Index;
        end;
      end;
    end;

  until (Count[X] > 0) and (Count[Y] > 0) and (Count[Z] > 0);

  // Find lowest common multiple.
  // This is the slowest part for a huge number like the puzzle input.
  // Took about 15 seconds to run.
  LCM[X] := Count[X];
  LCM[Y] := Count[Y];
  LCM[Z] := Count[Z];
  repeat
    while LCM[X] < LCM[Z] do Inc(LCM[X], Count[X]);
    while LCM[Y] < LCM[X] do Inc(LCM[Y], Count[Y]);
    while LCM[Z] < LCM[Y] do Inc(LCM[Z], Count[Z]);
  until (LCM[X] = LCM[Y]) and (LCM[X] = LCM[Z]);

  Result := LCM[X];
end;

{ TMoon }

function TMoon.GetEnergy: Integer;
var
  pot, kin: Integer;
  d: TDimension;
begin
  pot := 0; kin := 0;
  for d := Low(TDimension) to High(TDimension) do
  begin
    Inc(pot, Abs(Position[d]));
    Inc(kin, Abs(Velocity[d]));
  end;
  Result := pot * kin;
end;

end.
