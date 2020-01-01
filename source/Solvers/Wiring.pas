unit Wiring;

interface

uses
  AoC.Types;

type
  TWiring = class
  public
    class function WireToSegments(const Wire: TWire): TSegments;
    class function FindIntersection(const Segment1, Segment2: TSegment; out Intersection: TGridLocation): Boolean;
    class function FindIntersections(const Wire1, Wire2: TWire): TIntersections;
    class function ManhattanDistance(const A, B: TGridLocation): Integer;
    class function LineDistance(const Wire: TWire; Location: TGridLocation): Integer;
  end;

implementation

uses
  SysUtils, Math;

{ TWiring }

class function TWiring.FindIntersection(const Segment1, Segment2: TSegment;
  out Intersection: TGridLocation): Boolean;
var
  SX, SY: TSegment;
begin
  Result := False;

  if Segment1.Orientation = Segment2.Orientation then
    Exit;

  if Segment1.Orientation = soX then
  begin
    SX := Segment1.Normalized;
    SY := Segment2.Normalized;
  end
  else
  begin
    SY := Segment1.Normalized;
    SX := Segment2.Normalized;
  end;
  if (SX.Y1 <= SY.Y1) and (SX.Y2 >= SY.Y1) and
     (SY.X1 <= SX.X1) and (SY.X2 >= SX.X1) then
  begin
    Intersection := TGridLocation.Create(SX.X1, SY.Y1);
    Exit(True);
  end;
end;

class function TWiring.FindIntersections(const Wire1, Wire2: TWire): TIntersections;
var
  Index: Integer;
  Segments1, Segments2: TSegments;
  Segment1, Segment2: TSegment;
  Location: TGridLocation;
begin
  Index := 0;
  Segments1 := WireToSegments(Wire1);
  Segments2 := WireToSegments(Wire2);
  SetLength(Result, Max(Length(Segments1), Length(Segments2)));

  for Segment1 in Segments1 do
    for Segment2 in Segments2 do
      if FindIntersection(Segment1, Segment2, Location) then
      begin
        Result[Index] := Location;
        Inc(Index);
      end;

  SetLength(Result, Index);
end;

class function TWiring.LineDistance(const Wire: TWire;
  Location: TGridLocation): Integer;
var
  Segments: TSegments;
  Segment: TSegment;
  SegmentLength: Integer;
  Found: Boolean;
begin
  Result := 0;
  Segments := WireToSegments(Wire);
  for Segment in Segments do
  begin
    Found := Segment.LengthUntil(Location, SegmentLength);
    Inc(Result, SegmentLength);
    if Found then
      Break;
  end;
end;

class function TWiring.ManhattanDistance(const A, B: TGridLocation): Integer;
begin
  Result := Abs(A.X-B.X) + Abs(A.Y-B.Y);
end;

class function TWiring.WireToSegments(const Wire: TWire): TSegments;
var
  i: Integer;
begin
  SetLength(Result, Length(Wire) - 1);
  for i := Low(Wire) to High(Wire) - 1 do
    Result[i] := TSegment.Create(Wire[i].X, Wire[i].Y,Wire[i+1].X, Wire[i+1].Y);
end;

end.
