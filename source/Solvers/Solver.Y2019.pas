unit Solver.Y2019;

interface

uses
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

implementation

uses
  SysUtils,
  AoC.Types,
  InputUtils,
  Module.Fuel,
  IntCode.Processor;

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
  with TIntCodeProcessor.Create do
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
  with TIntCodeProcessor.Create do
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

end.
