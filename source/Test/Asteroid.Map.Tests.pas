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
    [TestCase('Draw Number 1',
    '.##.#'#13#10'|'+
    '.12.1'#13#10, '|')]
    [TestCase('Draw Number 2',
    '.#..'#13#10+
    '###.'#13#10+
    '.#.#'#13#10'|'+
    '.3..'#13#10+
    '454.'#13#10+
    '.4.4'#13#10, '|')]
    [TestCase('Draw Number 3',
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
