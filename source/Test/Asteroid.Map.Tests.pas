unit Asteroid.Map.Tests;

interface

uses
  DUnitX.TestFramework,
  Asteroid.Map;

type
  [TestFixture]
  TAsteroidTrackerTests = class(TObject)
  public
    [Test]
    [TestCase('1', '1,1,3,3,4')]
    [TestCase('2', '3,3,1,1,4')]
    [TestCase('3', '1,1,3,1,2')]
    [TestCase('4', '1,3,5,6,7')]
    [TestCase('5', '1,3,5,1,6')]
    procedure TestDistance(AX, AY, BX, BY, Expected: Integer);

    [Test]
    // Test if A can see C and vice versa
    //               A   B   C  Can see
    [TestCase('1', '1,1,3,3,5,5,False')]
    [TestCase('1b', '1,1,5,5,3,3,True')]
    [TestCase('2', '1,1,3,3,5,6,True')]
    [TestCase('3', '1,2,3,6,5,10,False')]
    [TestCase('3', '1,1,3,1,5,1,False')]
    procedure TestCanSee(AX, AY, BX, BY, CX, CY: Integer; Expected: Boolean);

    [Test]
    [TestCase('Draw',
    '.#..#'#13#10+
    '.....'#13#10+
    '#####'#13#10+
    '....#'#13#10+
    '...##'#13#10'|' +
    '.#..#'#13#10+
    '.....'#13#10+
    '#####'#13#10+
    '....#'#13#10+
    '...##'#13#10, '|')]
    procedure TestDraw(Input, Expected: String);

    [Test]
    [TestCase('Draw',
    '.##.#'#13#10'|'+
    '.12.1'#13#10, '|')]
    [TestCase('Draw',
    '.#..'#13#10+
    '###.'#13#10+
    '.#.#'#13#10'|'+
    '.3..'#13#10+
    '454.'#13#10+
    '.4.4'#13#10, '|')]
    [TestCase('Draw',
    '.#..#'#13#10+
    '.....'#13#10+
    '#####'#13#10+
    '....#'#13#10+
    '...##'#13#10'|' +
    '.7..7'#13#10+
    '.....'#13#10+
    '67775'#13#10+
    '....7'#13#10+
    '...87'#13#10, '|')]
    procedure TestDrawNumber(Input, Expected: String);
  end;

implementation

uses
  SysUtils,
  InputUtils;

{ TAsteroidTrackerTests }

procedure TAsteroidTrackerTests.TestCanSee(AX, AY, BX, BY, CX, CY: Integer;
  Expected: Boolean);
var
  A, B, C: TAsteroid;
begin
  A := TAsteroid.Create(AX, AY);
  B := TAsteroid.Create(BX, BY);
  C := TAsteroid.Create(CX, CY);
  try
    Assert.AreEqual(Expected, A.CanSee(B, C), 'A->B->C');
    Assert.AreEqual(Expected, C.CanSee(B, A), 'C->B->A');
  finally
    A.Free;
    B.Free;
    C.Free;
  end;
end;

procedure TAsteroidTrackerTests.TestDistance(AX, AY, BX, BY, Expected: Integer);
var
  A, B: TAsteroid;
begin
  A := TAsteroid.Create(AX, AY);
  B := TAsteroid.Create(BX, BY);
  try
    Assert.AreEqual(Expected, A.DistanceTo(B), 'A->B');
    Assert.AreEqual(Expected, B.DistanceTo(A), 'B->A');
  finally
    A.Free;
    B.Free;
  end;
end;

procedure TAsteroidTrackerTests.TestDraw(Input, Expected: String);
var
  Map: TAsteroidMap;
begin
  Map := TInput.CreateAsteroidMap(Input);
  try
    Assert.AreEqual(Length(Expected), Length(Map.Draw()));
    Assert.AreEqual(QuotedStr(Expected), QuotedStr(Map.Draw()));
  finally
    Map.Free;
  end;
end;

procedure TAsteroidTrackerTests.TestDrawNumber(Input, Expected: String);
var
  Map: TAsteroidMap;
begin
  Map := TInput.CreateAsteroidMap(Input);
  try
    Assert.AreEqual(Expected, Map.DrawCandidates());
  finally
    Map.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TAsteroidTrackerTests);
end.
