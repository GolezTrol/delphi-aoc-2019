unit Solver.Y2019;

interface

uses
  Solver.Intf;

type
  TSolver2019_1_1 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;
  TSolver2019_1_2 = class(TInterfacedObject, ISolver)
    function Solve(Input: String): String;
  end;

implementation

uses
  SysUtils,
  InputUtils,
  Module.Fuel;

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

end.
