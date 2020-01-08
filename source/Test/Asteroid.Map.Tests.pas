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

    const
      Field =
        '.#..##.###...#######'#13+
        '##.############..##.'#13+
        '.#.######.########.#'#13+
        '.###.#######.####.#.'#13+
        '#####.##.#.##.###.##'#13+
        '..#####..#.#########'#13+
        '####################'#13+
        '#.####....###.#.#.##'#13+
        '##.#################'#13+
        '#####.##.###..####..'#13+
        '..######..##.#######'#13+
        '####.##.####...##..#'#13+
        '.#####..#.######.###'#13+
        '##...#.##########...'#13+
        '#.##########.#######'#13+
        '.####.#.###.###.#.##'#13+
        '....##.##.###..#####'#13+
        '.#.#.###########.###'#13+
        '#.#.#.#####.####.###'#13+
        '###.##.####.##.#..##';

    [Test]
    [TestCase('1', '1,11,12')]
    [TestCase('2', '2,12,1')]
    [TestCase('3', '3,12,2')]
    [TestCase('10', '10,12,8')]
    [TestCase('20', '20,16,0')]
    [TestCase('50', '50,16,9')]
    [TestCase('100', '100,10,16')]
    [TestCase('199', '199,9,6')]
    [TestCase('200', '200,8,2')]
    [TestCase('201', '201,10,9')]
    [TestCase('299', '299,11,1')]
    procedure TestZapp(const Nr, X, Y: Integer);
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

procedure TAsteroidTrackerTests.TestZapp(const Nr, X, Y: Integer);
var
  AsteroidMap: TAsteroidMap;
  Asteroid: TAsteroid;
  ZappList: IAsteroidList;

  procedure Check(Nr, X, Y: Integer);
  begin
    Dec(Nr); // 0 based
    Assert.AreEqual(Format('%d,%d', [X, Y]), Format('%d,%d', [ZappList[Nr].X, ZappList[Nr].Y]), Format('Nr %d', [Nr]));
  end;
begin
  AsteroidMap := TInput.CreateAsteroidMap(Field);
  Asteroid := AsteroidMap.GetAsteroid(11,13);
  ZappList := AsteroidMap.GetZappList(Asteroid);
  Check(Nr, X, Y);
end;

initialization
  TDUnitX.RegisterTestFixture(TAsteroidTrackerTests);
end.
