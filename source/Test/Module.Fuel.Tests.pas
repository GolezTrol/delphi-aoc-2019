unit Module.Fuel.Tests;

interface

uses
  DUnitX.TestFramework,
  Module.Fuel;

type
  [TestFixture]
  TModuleFuelTests = class(TObject)
  private
    FFuelRequirements: TFuelRequirements;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    // For a mass of _12_, divide by 3 and round down to get 4, then subtract 2 to get _2_.
    [TestCase('A', '12, 2')]
    [TestCase('B', '14, 2')]
    [TestCase('C', '1969, 654')]
    [TestCase('D', '100756, 33583')]
    procedure TestRequirement(const Mass: Integer; const Fuel: Integer);
  end;

implementation

procedure TModuleFuelTests.Setup;
begin
  FFuelRequirements := TFuelRequirements.Create;
end;

procedure TModuleFuelTests.TearDown;
begin
  FFuelRequirements.Free;
end;

procedure TModuleFuelTests.TestRequirement(const Mass, Fuel: Integer);
begin
  Assert.AreEqual(Fuel, FFuelRequirements.CalculateRequiredFuel(Mass));
end;

initialization
  TDUnitX.RegisterTestFixture(TModuleFuelTests);
end.
