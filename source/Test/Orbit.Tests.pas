unit Orbit.Tests;

interface

uses
  AoC.Types,
  Orbit.Map,
  DUnitX.TestFramework;

type
  [TestFixture]
  TOrbitTests = class(TObject) 
  public
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Atribute to supply parameters.
    [Test]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

procedure TOrbitTests.Test1;
begin
end;

procedure TOrbitTests.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TOrbitTests);
end.
