unit Moon.Motion.Tests;

interface

uses
  DUnitX.TestFramework,
  SysUtils,
  Moon.Motion;

type

  [TestFixture]
  TMoonMotionTests = class(TObject)
  private
    function MoonToString(const Moon: TMoon): String;
    function MoonsToString(const Moons: TMoons): String;
  public
    [Test]
    procedure TestVelocity;
    [Test]
    procedure TestEnergy;
  end;

implementation

uses
  InputUtils;

{ TMoonMotionTests }

function TMoonMotionTests.MoonsToString(const Moons: TMoons): String;
var
  Moon: TMoon;
begin
  for Moon in Moons do
    Result := Result + MoonToString(Moon) + #13
end;

function TMoonMotionTests.MoonToString(const Moon: TMoon): String;
begin
  Result := Format(
    'pos=<x=%d, y=%d, z=%d>, vel=<x=%d, y=%d, z=%d>',
    [
      Moon.Position[X], Moon.Position[Y], Moon.Position[Z],
      Moon.Velocity[X], Moon.Velocity[Y], Moon.Velocity[Z]
    ]);
end;

procedure TMoonMotionTests.TestEnergy;
var
  Moons: TMoons;
  procedure AddMoon(px, py, pz, vx, vy, vz: Integer);
  begin
    SetLength(Moons, Length(Moons)+1);
    with Moons[High(Moons)] do
    begin
      Position[X] := px; Position[Y] := py; Position[Z] := pz;
      Velocity[X] := vx; Velocity[Y] := vy; Velocity[Z] := vz;
    end;

  end;
begin
  AddMoon(8, 12, 9 {29}, 7, 3, 0 {10}); // = 290
  Assert.AreEqual(290, TMoonMotion.GetMoonsEnergy(Moons));
  AddMoon(13, 16, 3 {32}, 3, 11, 5 {19}); // = 608, 898 cumulative
  Assert.AreEqual(898, TMoonMotion.GetMoonsEnergy(Moons));
end;

procedure TMoonMotionTests.TestVelocity;
var
  Moons: TMoons;
  TimeStep: Integer;

  procedure Test(ResultStep: Integer; Output: String);
  begin
    while TimeStep < ResultStep do
    begin
      Inc(TimeStep);
      TMoonMotion.StepGravity(Moons);
    end;
    Assert.AreEqual(Output, MoonsToString(Moons), Format('TimeStep %d', [TimeStep]));
  end;

begin
  TimeStep := 0;
  Moons := TInput.Moons(
    '<x=-1, y=0, z=2>'#13 +
    '<x=2, y=-10, z=-7>'#13 +
    '<x=4, y=-8, z=8>'#13 +
    '<x=3, y=5, z=-1>'#13);

  Test(0,
    'pos=<x=-1, y=0, z=2>, vel=<x=0, y=0, z=0>'#13 +
    'pos=<x=2, y=-10, z=-7>, vel=<x=0, y=0, z=0>'#13 +
    'pos=<x=4, y=-8, z=8>, vel=<x=0, y=0, z=0>'#13 +
    'pos=<x=3, y=5, z=-1>, vel=<x=0, y=0, z=0>'#13);

  Test(1,
    'pos=<x=2, y=-1, z=1>, vel=<x=3, y=-1, z=-1>'#13 +
    'pos=<x=3, y=-7, z=-4>, vel=<x=1, y=3, z=3>'#13 +
    'pos=<x=1, y=-7, z=5>, vel=<x=-3, y=1, z=-3>'#13 +
    'pos=<x=2, y=2, z=0>, vel=<x=-1, y=-3, z=1>'#13);

  Test(2,
    'pos=<x=5, y=-3, z=-1>, vel=<x=3, y=-2, z=-2>'#13 +
    'pos=<x=1, y=-2, z=2>, vel=<x=-2, y=5, z=6>'#13 +
    'pos=<x=1, y=-4, z=-1>, vel=<x=0, y=3, z=-6>'#13 +
    'pos=<x=1, y=-4, z=2>, vel=<x=-1, y=-6, z=2>'#13);

  Test(3,
    'pos=<x=5, y=-6, z=-1>, vel=<x=0, y=-3, z=0>'#13 +
    'pos=<x=0, y=0, z=6>, vel=<x=-1, y=2, z=4>'#13 +
    'pos=<x=2, y=1, z=-5>, vel=<x=1, y=5, z=-4>'#13 +
    'pos=<x=1, y=-8, z=2>, vel=<x=0, y=-4, z=0>'#13);

  Test(4,
    'pos=<x=2, y=-8, z=0>, vel=<x=-3, y=-2, z=1>'#13 +
    'pos=<x=2, y=1, z=7>, vel=<x=2, y=1, z=1>'#13 +
    'pos=<x=2, y=3, z=-6>, vel=<x=0, y=2, z=-1>'#13 +
    'pos=<x=2, y=-9, z=1>, vel=<x=1, y=-1, z=-1>'#13);

  Test(5,
    'pos=<x=-1, y=-9, z=2>, vel=<x=-3, y=-1, z=2>'#13 +
    'pos=<x=4, y=1, z=5>, vel=<x=2, y=0, z=-2>'#13 +
    'pos=<x=2, y=2, z=-4>, vel=<x=0, y=-1, z=2>'#13 +
    'pos=<x=3, y=-7, z=-1>, vel=<x=1, y=2, z=-2>'#13);

  Test(6,
    'pos=<x=-1, y=-7, z=3>, vel=<x=0, y=2, z=1>'#13 +
    'pos=<x=3, y=0, z=0>, vel=<x=-1, y=-1, z=-5>'#13 +
    'pos=<x=3, y=-2, z=1>, vel=<x=1, y=-4, z=5>'#13 +
    'pos=<x=3, y=-4, z=-2>, vel=<x=0, y=3, z=-1>'#13);

  Test(7,
    'pos=<x=2, y=-2, z=1>, vel=<x=3, y=5, z=-2>'#13 +
    'pos=<x=1, y=-4, z=-4>, vel=<x=-2, y=-4, z=-4>'#13 +
    'pos=<x=3, y=-7, z=5>, vel=<x=0, y=-5, z=4>'#13 +
    'pos=<x=2, y=0, z=0>, vel=<x=-1, y=4, z=2>'#13);

  Test(8,
    'pos=<x=5, y=2, z=-2>, vel=<x=3, y=4, z=-3>'#13 +
    'pos=<x=2, y=-7, z=-5>, vel=<x=1, y=-3, z=-1>'#13 +
    'pos=<x=0, y=-9, z=6>, vel=<x=-3, y=-2, z=1>'#13 +
    'pos=<x=1, y=1, z=3>, vel=<x=-1, y=1, z=3>'#13);

  Test(9,
    'pos=<x=5, y=3, z=-4>, vel=<x=0, y=1, z=-2>'#13 +
    'pos=<x=2, y=-9, z=-3>, vel=<x=0, y=-2, z=2>'#13 +
    'pos=<x=0, y=-8, z=4>, vel=<x=0, y=1, z=-2>'#13 +
    'pos=<x=1, y=1, z=5>, vel=<x=0, y=0, z=2>'#13);

  Test(10,
    'pos=<x=2, y=1, z=-3>, vel=<x=-3, y=-2, z=1>'#13 +
    'pos=<x=1, y=-8, z=0>, vel=<x=-1, y=1, z=3>'#13 +
    'pos=<x=3, y=-6, z=1>, vel=<x=3, y=2, z=-3>'#13 +
    'pos=<x=2, y=0, z=4>, vel=<x=1, y=-1, z=-1>'#13);
 end;

initialization
  TDUnitX.RegisterTestFixture(TMoonMotionTests);
end.
