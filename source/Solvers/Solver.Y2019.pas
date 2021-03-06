unit Solver.Y2019;

interface

uses
  AoC.Types,
  IntCode.Types,
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
  TSolver2019_5_1 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  TSolver2019_5_2 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  // Day 6: Universal Orbit Map
  TSolver2019_6_1 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  TSolver2019_6_2 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  // Day 7: Amplification Circuit
  TSolver2019_7_1 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  TSolver2019_7_2 = class(TInterfacedObject, ISolver, IIO)
  private
    FInputOutput: Integer;
  private // IIO
    function Read: TAoCInt;
    procedure Write(Value: TAoCInt);
  private
    function Solve(Input: String): String;
  end;
  // Day 8: Space Image Format
  TSolver2019_8_1 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  TSolver2019_8_2 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  // Day 9: Sensor Boost
  TSolver2019_9_1 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  TSolver2019_9_2 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  // Day 10: Monitoring Station
  TSolver2019_10_1 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  TSolver2019_10_2 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  // Day 11: Space Police
  TSolver2019_11_1 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  TSolver2019_11_2 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  // Day 12: The N-Body Problem
  TSolver2019_12_1 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  TSolver2019_12_2 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  // Day 13: Care Package
  TSolver2019_13_1 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  TSolver2019_13_2 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;

implementation

uses
  SysUtils,
  InputUtils,
  Module.Fuel,
  Wiring,
  Password,
  IntCode.Processor,
  IntCode.IO,
  Orbit.Map,
  Permutation,
  Space.Image,
  Asteroid.Map,
  Robot.Painter,
  Moon.Motion,
  ArcadeGame;

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
function TSolver2019_5_1.Solve(Input: String): String;
var
  Code: TIntegerArray;
  IO: IIntCodeArrayIO;
begin
  IO := TIntCodeArrayIO.Create([
    1 // the ID for the ship's air conditioner unit.
  ]);

  with TIntCodeProcessor.Create(IO) do
  try
    Code := TInput.IntCommaSeparated(Input);
    Execute(Code);
    Result := IO.GetLastOutput.ToString;
  finally
    Free;
  end;
end;

{ TSolver2019_5_2 }

function TSolver2019_5_2.Solve(Input: String): String;
var
  Code: TIntegerArray;
  IO: IIntCodeArrayIO;
begin
  IO := TIntCodeArrayIO.Create([
    5 // the ID for the ship's thermal radiator controller
  ]);

  with TIntCodeProcessor.Create(IO) do
  try
    Code := TInput.IntCommaSeparated(Input);
    Execute(Code);
    Result := IO.GetLastOutput.ToString;
  finally
    Free;
  end;
end;

{ TSolver2019_6_1 }

function TSolver2019_6_1.Solve(Input: String): String;
var
  Orbit: String;
  TotalDepth: Integer;
begin
  TotalDepth := 0;
  with TInput.CreateOrbitMap(Input) do
  try
    for Orbit in GetBodies.Keys do
      Inc(TotalDepth, GetOrbitLevel(Orbit));
    Result := TotalDepth.ToString();
  finally
    Free;
  end;
end;

{ TSolver2019_6_2 }
function TSolver2019_6_2.Solve(Input: String): String;
begin
  with TInput.CreateOrbitMap(Input) do
  try
    Result := GetDistance('YOU', 'SAN').ToString();
  finally
    Free;
  end;
end;

{ TSolver2019_7_1 }

function TSolver2019_7_1.Solve(Input: String): String;
const
  PhaseSettings: TIntegerArray = [0,1,2,3,4];
var
  Permutations: TIntegerArrayArray;
  Permutation: TIntegerArray;
  Code: TIntegerArray;
  IO: IIntCodeArrayIO;
  Output, HighestOutput: Integer;
  PhaseSetting: Integer;
begin
  HighestOutput := 0;

  // Try all permutations of the phase settings set.
  Permutations := TPermutation.GetPermutations(PhaseSettings);

  for Permutation in Permutations do
  begin
    Output := 0;
    // Run each permutation through each of the amplifiers.
    for PhaseSetting in Permutation do
    begin
      // Input for the program is the phase setting and the output of the previous run.
      IO := TIntCodeArrayIO.Create([PhaseSetting, Output]);

      with TIntCodeProcessor.Create(IO) do
      try
        Code := TInput.IntCommaSeparated(Input);
        Execute(Code);
        Output := IO.GetLastOutput;
      finally
        Free;
      end;
    end;
    // Save the highest output. That leads to the most successful permutation
    if Output > HighestOutput then
      HighestOutput := Output;
  end;

  Result := HighestOutput.ToString;
end;

{ TSolver2019_7_2 }

function TSolver2019_7_2.Read: TAoCInt;
begin
  Result := FInputOutput;
end;

function TSolver2019_7_2.Solve(Input: String): String;
const
  PhaseSettings: TIntegerArray = [5,6,7,8,9];
var
  Permutations: TIntegerArrayArray;
  Permutation: TIntegerArray;
  Code: TIntegerArray;
  HighestOutput: Integer;
  Processor: TIntCodeProcessor;
  Amps: Array[0..4] of TIntCodeProgram;
  a: Integer;
begin
  HighestOutput := 0;

  Processor := TIntCodeProcessor.Create(Self);
  try
    Code := TInput.IntCommaSeparated(Input);

    // Try all permutations of the phase settings set.
    Permutations := TPermutation.GetPermutations(PhaseSettings);

    for Permutation in Permutations do
    begin
      // For each permutation, initialize the programs again, let them read
      // their phase settings, and then let them run until they want their actual input
      for a := Low(Amps) to High(Amps) do
      begin
        Amps[a] := TIntCodeProgram.Create(Copy(Code, 0, Length(Code)));
        FInputOutput := Permutation[a];
        Processor.Run(Amps[a]); // Run until they want their phase setting
        Processor.Run(Amps[a]); // Run until they want their first input.
      end;

      // Set the input to 0 for the very first input of the very first amp.
      FInputOutput := 0;

      // After that, run the programs one by one. Each run should take an input
      // and provide an output using the same FInputOutput variable.
      // Keep running the programs until they are halted.
      repeat
        for a := Low(Amps) to High(Amps) do
          Processor.Run(Amps[a]);
      until Amps[4].ProgramState = psHalted;

      // The last output of the last amp is the outcome for this permutation.
      // Save the highest output. That leads to the most successful permutation,
      // that highest output is the puzzle answer.
      if FInputOutput > HighestOutput then
        HighestOutput := FInputOutput;

      // Free them all
      for a := Low(Amps) to High(Amps) do
        Amps[a].Free;
    end;
  finally
    Processor.Free;
  end;

  Result := HighestOutput.ToString;
end;

procedure TSolver2019_7_2.Write(Value: TAoCInt);
begin
  FInputOutput := Value;
end;

{ TSolver2019_8_1 }

function TSolver2019_8_1.Solve(Input: String): String;
begin
  with TSpaceImage.Create do
  try
    LoadFrom(TInput.IntDigits(Input), 25, 6);
    Result := CheckProduct(0, [1, 2]).ToString;
  finally
    Free;
  end;
end;

{ TSolver2019_8_2 }

function TSolver2019_8_2.Solve(Input: String): String;
begin
  with TSpaceImage.Create do
  try
    LoadFrom(TInput.IntDigits(Input), 25, 6);
    Result := Draw;
  finally
    Free;
  end;
end;

{ TSolver2019_9_1 }

function TSolver2019_9_1.Solve(Input: String): String;
var
  Code: TIntegerArray;
  IO: IIntCodeArrayIO;
  Output: TAoCInt;
begin
  IO := TIntCodeArrayIO.Create([
    1 // Test mode
  ]);

  with TIntCodeProcessor.Create(IO) do
  try
    Code := TInput.IntCommaSeparated(Input);
    Execute(Code);
    for Output in IO.GetOutputs do
      Result := Result + #13#10 + Output.ToString;

    Result := Result + #13#10 + Length(IO.GetOutputs).ToString + 'outputs. Last: ' + IO.GetLastOutput.ToString;
  finally
    Free;
  end;
end;

{ TSolver2019_9_2 }

function TSolver2019_9_2.Solve(Input: String): String;
var
  Code: TIntegerArray;
  IO: IIntCodeArrayIO;
begin
  IO := TIntCodeArrayIO.Create([
    2 // Sensor boost mode
  ]);

  with TIntCodeProcessor.Create(IO) do
  try
    Code := TInput.IntCommaSeparated(Input);
    Execute(Code);
    Result := Length(IO.GetOutputs).ToString + 'outputs. Last: ' + IO.GetLastOutput.ToString;
  finally
    Free;
  end;
end;

{ TSolver2019_10_1 }

function TSolver2019_10_1.Solve(Input: String): String;
var
  Map: TAsteroidMap;
  X, Y, Number: Integer;
begin
  Map := TInput.CreateAsteroidMap(Input);
  Map.GetBestOutlook(X, Y, Number);
  Result := Format('(%d,%d):%d', [X, Y, Number]);
end;

{ TSolver2019_10_2 }

function TSolver2019_10_2.Solve(Input: String): String;
const
  Index = 200; // We need the 200th.
var
  Map: TAsteroidMap;
  Asteroid: TAsteroid; // The asteroid of the answer
  X, Y, Number: Integer;
begin
  Map := TInput.CreateAsteroidMap(Input);
  // The GetBestOutlook call is slow, but needed here to make this puzzle
  // work for different inputs, and independent of the other solvers.
  Map.GetBestOutlook(X, Y, Number);
  Asteroid := Map.GetZappList(Map.GetAsteroid(X, Y))[Index -1];
  Result := Format('(%d,%d):%d', [Asteroid.X, Asteroid.Y, Asteroid.X*100+Asteroid.Y]);
end;

{ TSolver2019_11_1 }

function TSolver2019_11_1.Solve(Input: String): String;
var
  Code: TIntegerArray;
  IO: IRobotPainter;
begin
  IO := TRobotPainter.Create(0 {Black});

  with TIntCodeProcessor.Create(IO) do
  try
    Code := TInput.IntCommaSeparated(Input);
    Execute(Code);
    Result := IO.GetPanels.Count.ToString();
  finally
    Free;
  end;
end;

{ TSolver2019_11_2 }

function TSolver2019_11_2.Solve(Input: String): String;
var
  Code: TIntegerArray;
  IO: IRobotPainter;
begin
  IO := TRobotPainter.Create(1 {White});

  with TIntCodeProcessor.Create(IO) do
  try
    Code := TInput.IntCommaSeparated(Input);
    Execute(Code);
    Result := IO.Draw;
  finally
    Free;
  end;
end;

{ TSolver2019_12_1 }

function TSolver2019_12_1.Solve(Input: String): String;
var
  Moons: TMoons;
  i: Integer;
begin
  Moons := TInput.Moons(Input);
  for i := 1 to 1000 do
    TMoonMotion.StepGravity(Moons);

  Result := TMoonMotion.GetMoonsEnergy(Moons).ToString();
end;

{ TSolver2019_12_2 }

function TSolver2019_12_2.Solve(Input: String): String;
var
  Moons: TMoons;
begin
  Moons := TInput.Moons(Input);
  Result := TMoonMotion.StepsUntilRepeat(Moons).ToString();
end;

{ TSolver2019_13_1 }

function TSolver2019_13_1.Solve(Input: String): String;
var
  Game: IArcadeGame;
  Code: TIntegerArray;
  Obj: TGameObject;
  Count: Integer;
begin
  Count := 0;
  Game := TArcadeGame.Create;
  with TIntCodeProcessor.Create(Game) do
  try
    Code := TInput.IntCommaSeparated(Input);
    Execute(Code);

    for Obj in Game.GetGrid.Values do
      if Obj = Block then
        Inc(Count);

    Result := Count.ToString;
  finally
    Free;
  end;
end;

{ TSolver2019_13_2 }

function TSolver2019_13_2.Solve(Input: String): String;
begin

end;

end.
