unit Moon.Motion;

interface

uses
  AoC.Types;

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
