unit Wiring.Tests;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TWiringTests = class(TObject)
  public
    [Test]
    procedure Segments_WhenNotIntersecting_ReturnsFalse;
    [Test]
    procedure Segments_WhenIntersecting_ReturnsTheLocation;
    [Test]
    procedure Wires_WhenNotIntersecting_ReturnsEmptyArray;
    [Test]
    procedure Wires_WhenIntersecting_ReturnsAllLocations;
    [Test]
    procedure Manhattan_Distance;
    [Test]
    procedure Line_Distance;
    [Test]
    procedure Segment_Distance;

  end;

implementation

uses
  AoC.Types,
  Wiring;

procedure TWiringTests.Line_Distance;
  procedure Check(Expected: Integer; Wire: TWire; Location: TGridLocation);
  begin
    Assert.AreEqual(Expected, TWiring.LineDistance(Wire, Location));
  end;
begin
  Check(
    10, [
      TGridLocation.Create(3,3),
      TGridLocation.Create(10,3), // 7
      TGridLocation.Create(10,8) // 12
    ],
    TGridLocation.Create(10, 6) // Third-last position, expect length-2 = 10
  );
end;

procedure TWiringTests.Manhattan_Distance;
  procedure Check(Expected, X1, Y1, X2, Y2: Integer);
  begin
    Assert.AreEqual(
      Expected,
      TWiring.ManhattanDistance(
        TGridLocation.Create(X1, Y1),
        TGridLocation.Create(X2, Y2)));
  end;
begin
  Check(0, 3,3, 3,3);
  Check(5, 0,0, 2,3);
  Check(6, 0,0, -2,4);
  Check(7, 0,0, -2,-5);
  Check(13, 9,9, 2,3);
  Check(17, 9,9, -2,3);
end;

procedure TWiringTests.Segments_WhenIntersecting_ReturnsTheLocation;
  procedure Check(Expected: TGridLocation; Segment1, Segment2: TSegment);
  var
    Location: TGridLocation;
  begin
    Assert.IsTrue(
      TWiring.FindIntersection(
        Segment1,
        Segment2,
        Location
      ));
    Assert.AreEqual(Expected, Location);
  end;
begin
  // Happy path, two normalized segments.
  Check(TGridLocation.Create(2, 1), TSegment.Create(1,1, 5,1), TSegment.Create(2,0, 2,9));
  // Segments passed in different order
  Check(TGridLocation.Create(2, 1), TSegment.Create(2,0, 2,9), TSegment.Create(1,1, 5,1));
  // One segment denormalized
  Check(TGridLocation.Create(2, 1), TSegment.Create(5,1, 1,1), TSegment.Create(2,0, 2,9));
  // Both segments denormalized
  Check(TGridLocation.Create(2, 1), TSegment.Create(5,1, 1,1), TSegment.Create(2,9, 2,0));
  // Intersection at and of one segment
  Check(TGridLocation.Create(1, 1), TSegment.Create(1,1, 5,1), TSegment.Create(1,0, 1,9));
  // Intersection at end of both segments
  Check(TGridLocation.Create(1, 9), TSegment.Create(1,9, 5,9), TSegment.Create(1,1, 1,9));
end;

procedure TWiringTests.Segments_WhenNotIntersecting_ReturnsFalse;
var
  Location: TGridLocation;
begin
  Assert.IsFalse(TWiring.FindIntersection(
      TSegment.Create(1,1, 5,1), TSegment.Create(6,0, 6,9), Location));
  Assert.IsFalse(TWiring.FindIntersection(
      TSegment.Create(1,1, 5,1), TSegment.Create(0,0, 0,9), Location));
  Assert.IsFalse(TWiring.FindIntersection(
      TSegment.Create(1,0, 5,0), TSegment.Create(3,1, 3,9), Location));
  Assert.IsFalse(TWiring.FindIntersection(
      TSegment.Create(1,10, 5,10), TSegment.Create(3,1, 3,9), Location));
  // Aligned/parallel and overlapping segments are considered not intersecting.
  Assert.IsFalse(TWiring.FindIntersection(
      TSegment.Create(1,10, 5,10), TSegment.Create(1,10, 5,10), Location));
  Assert.IsFalse(TWiring.FindIntersection(
      TSegment.Create(1,10, 5,10), TSegment.Create(1,10, 3,10), Location));
  Assert.IsFalse(TWiring.FindIntersection(
      TSegment.Create(1,10, 5,10), TSegment.Create(3,10, 4,10), Location));
  Assert.IsFalse(TWiring.FindIntersection(
      TSegment.Create(1,10, 1,2), TSegment.Create(1,1, 1,3), Location));
  // Parallel but not overlapping obviously is false too.
  Assert.IsFalse(TWiring.FindIntersection(
      TSegment.Create(1,10, 5,10), TSegment.Create(1,8, 5,8), Location));
end;

procedure TWiringTests.Segment_Distance;
var
  Segment: TSegment;
  procedure CheckUntil(Test: String; ExpectedResult: Boolean; ExpectedLength: Integer; Location: TGridLocation);
  var
    ActualLength: Integer;
  begin
    Assert.AreEqual(ExpectedResult, Segment.LengthUntil(Location, ActualLength), Test);
    Assert.AreEqual(ExpectedLength, ActualLength, Test);
  end;
begin
  Segment := TSegment.Create(5,5, 15,5);
  // Basic length
  Assert.AreEqual(10, Segment.Length);
  // Full length if no match
  CheckUntil('None', False, 10, TGridLocation.Create(8,4));
  // Full length if on end
  CheckUntil('End', True, 10, TGridLocation.Create(15,5));
  // Zero length if on start
  CheckUntil('Start', True, 0, TGridLocation.Create(5,5));
  // length if halfway
  CheckUntil('Halfway', True, 2, TGridLocation.Create(7,5));
end;

procedure TWiringTests.Wires_WhenIntersecting_ReturnsAllLocations;
  procedure Check(Description: String; Expected: TIntersections; Wire1, Wire2: TWire);
  var
    Actual: TIntersections;
    Location: TGridLocation;
  begin
    Actual := TWiring.FindIntersections(Wire1, Wire2);
    Assert.AreEqual(Length(Expected), Length(Actual), Description + ', length of result');

    for Location in Expected do
      Assert.Contains(Actual, Location);
  end;
begin
  Check(
    'Simple',
    [TGridLocation.Create(2,4)],
    [TGridLocation.Create(0,4),TGridLocation.Create(6,4)],
    [TGridLocation.Create(2,1),TGridLocation.Create(2,7)]
  );
  Check(
    'Zig-zag',
    [TGridLocation.Create(2,4),TGridLocation.Create(4,4),TGridLocation.Create(5,4)],
    // One segment
    [TGridLocation.Create(0,4),TGridLocation.Create(6,4)],
    // Zig-zagging wire
    [ TGridLocation.Create(2,1),
      TGridLocation.Create(2,7), // Intersecting at 2,4
      TGridLocation.Create(4,7),
      TGridLocation.Create(4,0), // Insersecting at 4,4
      TGridLocation.Create(5,0),
      TGridLocation.Create(5,4)  // Intersecting at 5,4
    ]
  );
end;

procedure TWiringTests.Wires_WhenNotIntersecting_ReturnsEmptyArray;
var
  Actual: TIntersections;
begin
  Actual := TWiring.FindIntersections(
    [TGridLocation.Create(0,4),TGridLocation.Create(6,4)],
    [TGridLocation.Create(2,5),TGridLocation.Create(2,7)]
  );
  Assert.AreEqual(0, Length(Actual));
end;

initialization
  TDUnitX.RegisterTestFixture(TWiringTests);
end.
