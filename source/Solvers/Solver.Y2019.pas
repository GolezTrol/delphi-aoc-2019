unit Solver.Y2019;

interface

uses
  IntCode.Processor,
  Solver.Intf;

type
  // Day 1: The Tyranny of the Rocket Equation
  TSolver2019_1_1 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  TSolver2019_1_2 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  // Day 2: 1202 Program Alarm
  TSolver2019_2_1 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  TSolver2019_2_2 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  // Day 3: Crossed wires
  TSolver2019_3_1 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  TSolver2019_3_2 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  // Day 4: Secure Container
  TSolver2019_4_1 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  TSolver2019_4_2 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  // Day 5: Sunny with a Chance of Asteroids
  TSolver2019_5_1 = class(TInterfacedObject, ISolver, IIO)
    function Solve(Input: String): String;
  private // IIO
    FValue: Integer;
    FOutputCount: Integer;
    function Read: Integer;
    procedure Write(Value: Integer);
  end;
  TSolver2019_5_2 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;

implementation

uses
  SysUtils,
  AoC.Types,
  InputUtils,
  Module.Fuel,
  Wiring,
  Password;

{ TSolver2019_1_1 }

function TSolver2019_1_1.Solve(Input: String): String;
var
  Inputs: TIntegerArray;
  Total: Integer;
  i: Integer;
begin
  Total := 0;
  with TFuelRequirements.Create do
  begin
    Inputs := TInput.IntPerLine(Input);
    for i in Inputs do
      Total := Total + CalculateRequiredFuel(i);
  end;
  Result := Total.ToString;
end;

{ TSolver2019_1_2 }

function TSolver2019_1_2.Solve(Input: String): String;
var
  Inputs: TIntegerArray;
  Total: Integer;
  i: Integer;
begin
  Total := 0;
  with TFuelRequirements.Create do
  begin
    Inputs := TInput.IntPerLine(Input);
    for i in Inputs do
      Total := Total + CalculateRequiredFuelEx(i);
  end;
  Result := Total.ToString;
end;

{ TSolver2019_2_1 }

function TSolver2019_2_1.Solve(Input: String): String;
var
  Code: TIntegerArray;
begin
  with TIntCodeProcessor.Create(nil) do
  try
    Code := TInput.IntCommaSeparated(Input);
    Code[1] := 12;
    Code[2] := 2;
    Result := ExecuteScalar(Code).ToString;
  finally
    Free;
  end;
end;

{ TSolver2019_2_2 }

function TSolver2019_2_2.Solve(Input: String): String;
const
  ExpectedResult: Integer = 19690720;
var
  Code: TIntegerArray;
  Noun, Verb: Integer;
begin
  with TIntCodeProcessor.Create(nil) do
  try
    Code := TInput.IntCommaSeparated(Input);
    for Noun := 0 to 99 do
      for Verb := 0 to 99 do
      begin
        Code[1] := Noun;
        Code[2] := Verb;
        // ExecuteScalar doesn't modify Code, so no need to copy Code here.
        if ExecuteScalar(Code) = ExpectedResult then
          Exit((100 * Noun + Verb).ToString());
      end;
  finally
    Free;
  end;

  Result := '';
end;

{ TSolver2019_3_1 }

function TSolver2019_3_1.Solve(Input: String): String;
var
  Wires: TStringArray;
  Wire1, Wire2: TWire;
  Intersections: TIntersections;
  MinDistance: Integer;
  Distance: Integer;
  Intersection: TGridLocation;
  Origin: TGridLocation;
begin
  MinDistance := MaxInt;
  Origin := TGridLocation.Create(0, 0);
  Wires := TInput.StringPerLine(Input);
  Wire1 := TInput.Wire(Wires[0]);
  Wire2 := TInput.Wire(Wires[1]);
  Intersections := TWiring.FindIntersections(Wire1, Wire2);
  for Intersection in Intersections do
  begin
    Distance := TWiring.ManhattanDistance(Origin, Intersection);
    if (Distance > 0) and (Distance < MinDistance) then
      MinDistance := Distance;
  end;
  Result := MinDistance.ToString();
end;

{ TSolver2019_3_2 }

function TSolver2019_3_2.Solve(Input: String): String;
var
  Wires: TStringArray;
  Wire1, Wire2: TWire;
  Intersections: TIntersections;
  Steps, MinSteps: Integer;
  Distance: Integer;
  Intersection: TGridLocation;
  Origin: TGridLocation;
begin
  MinSteps := MaxInt;
  Origin := TGridLocation.Create(0, 0);
  Wires := TInput.StringPerLine(Input);
  Wire1 := TInput.Wire(Wires[0]);
  Wire2 := TInput.Wire(Wires[1]);
  Intersections := TWiring.FindIntersections(Wire1, Wire2);
  for Intersection in Intersections do
  begin
    Distance := TWiring.ManhattanDistance(Origin, Intersection);
    if Distance > 0 then
    begin
      Steps := TWiring.LineDistance(Wire1, Intersection) + TWiring.LineDistance(Wire2, Intersection);
      if Steps < MinSteps then
        MinSteps := Steps;
    end;
  end;
  Result := MinSteps.ToString();
end;

{ TSolver2019_4_1 }

function TSolver2019_4_1.Solve(Input: String): String;
var
  A, B: Integer;
  i: Integer;
  Count: Integer;
begin
  TInput.Range(Input, A, B);
  Count := 0;
  for i := A to B do
    if TPassword.Validate1(i.ToString) then
      Inc(Count);
  Result := Count.ToString;
end;

{ TSolver2019_4_2 }

function TSolver2019_4_2.Solve(Input: String): String;
var
  A, B: Integer;
  i: Integer;
  Count: Integer;
begin
  TInput.Range(Input, A, B);
  Count := 0;
  for i := A to B do
    if TPassword.Validate2(i.ToString) then
      Inc(Count);
  Result := Count.ToString;
end;

{ TSolver2019_5_1 }

function TSolver2019_5_1.Read: Integer;
begin
  Result := 1; // the ID for the ship's air conditioner unit.
end;

function TSolver2019_5_1.Solve(Input: String): String;
var
  Code: TIntegerArray;
begin
  with TIntCodeProcessor.Create(Self) do
  try
    Code := TInput.IntCommaSeparated(Input);
    Execute(Code);
    Result := FValue.ToString;
  finally
    Free;
  end;
end;

procedure TSolver2019_5_1.Write(Value: Integer);
begin
  FValue := Value;
  Inc(FOutputCount);
end;

{ TSolver2019_5_2 }

function TSolver2019_5_2.Solve(Input: String): String;
begin

end;

end.
