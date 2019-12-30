unit Module.Fuel;

interface

type
  TFuelRequirements = class(TInterfacedObject)
  public
    function CalculateRequiredFuel(Mass: Integer): Integer;
    function CalculateRequiredFuelEx(Mass: Integer): Integer;
  end;

implementation

function TFuelRequirements.CalculateRequiredFuel(Mass: Integer): Integer;
begin
  Result := Mass div 3 - 2;
  if Result < 0 then
    Result := 0;
end;

function TFuelRequirements.CalculateRequiredFuelEx(Mass: Integer): Integer;
begin
  Result := 0;
  repeat
    Mass := CalculateRequiredFuel(Mass);
    Result := Result + Mass;
  until Mass = 0;
end;

end.
