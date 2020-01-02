unit Orbit.Map.Tests;

interface

uses
  AoC.Types,
  Orbit.Map,
  DUnitX.TestFramework;

type
  [TestFixture]
  TOrbitMapTests = class(TObject)
  private
    FMap: TOrbitMap;
  public
    [Setup]
    procedure Setup;
    [Teardown]
    procedure Teardown;
    [Test]
    procedure MapOrbitDepth;
  end;

implementation

procedure TOrbitMapTests.MapOrbitDepth;
begin
  Assert.AreEqual(-1, FMap.GetOrbitLevel('X')); // -1 on empty map
  FMap.AddBody('B', 'A');
  FMap.AddBody('C', 'A');
  FMap.AddBody('D', 'B');
  Assert.AreEqual(-1, FMap.GetOrbitLevel('X')); // -1 if body doesn't exist
  Assert.AreEqual(0, FMap.GetOrbitLevel('A'));  // 0 for root: A
  Assert.AreEqual(1, FMap.GetOrbitLevel('B'));  // 1 for each orbit, A)B
  Assert.AreEqual(1, FMap.GetOrbitLevel('C'));  // 1 for each orbit A)C
  Assert.AreEqual(2, FMap.GetOrbitLevel('D'));  // A)B)D
end;

procedure TOrbitMapTests.Setup;
begin
  FMap := TOrbitMap.Create;
end;

procedure TOrbitMapTests.Teardown;
begin
  FMap.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TOrbitMapTests);
end.
