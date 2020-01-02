unit AoC.Types;

interface

uses
  Math, Spring.Collections;

type
  TIntegerArray = TArray<Integer>;
  TIntegerArrayArray = TArray<TIntegerArray>; // For permutations
  TStringArray = TArray<String>;

  TGridLocation = record
    X, Y: Integer;
    constructor Create(AX, AY: Integer);
  end;
  TWire = array of TGridLocation;
  TIntersections = array of TGridLocation;
  TSegmentOrientation = (soX, soY);
  TSegment = record
    constructor Create(AX1, AY1, AX2, AY2: Integer);
    function Orientation: TSegmentOrientation;
    function Normalized: TSegment;
    function Length: Integer;
    function LengthUntil(Location: TGridLocation; out ALength: Integer): Boolean;
    case Integer of
      1:
      (
        Point1, Point2: TGridLocation;
      );
      2:
      (
        X1, Y1, X2, Y2: Integer;
      );
  end;
  TSegments = array of TSegment;

  TBody = class
    ID: String;
    Parent: TBody;
  end;

  IBodies = IDictionary<String, TBody>;
  IReadBodies = IReadOnlyDictionary<String, TBody>;

implementation

uses
  SysUtils;

{ TSegment }

constructor TSegment.Create(AX1, AY1, AX2, AY2: Integer);
begin
  if (AX1 = AX2) and (AY1 = AY2) then
    raise EArgumentOutOfRangeException.Create('Zero length segment');
  if (AX1 <> AX2) and (AY1 <> AY2) then
    raise EArgumentOutOfRangeException.Create('Segment does not align with grid');

  X1 := AX1;
  Y1 := AY1;
  X2 := AX2;
  Y2 := AY2;
end;

function TSegment.Length: Integer;
begin
  Result := Abs((X1-X2) + (Y1-Y2));
end;

function TSegment.LengthUntil(Location: TGridLocation;
  out ALength: Integer): Boolean;

  function Between(const P, A, B: Integer; out L: Integer): Boolean; inline;
  begin
    if (P < Min(A,B)) or (P > Max(A, B)) then
      Exit(False);

    L := Abs(P-A);
    Exit(True);
  end;
begin
  if Orientation = soX then
    Result := (Location.X = Self.X1) and Between(Location.Y, Self.Y1, Self.Y2, ALength)
  else
    Result := (Location.Y = Self.Y1) and Between(Location.X, Self.X1, Self.X2, ALength);
  if not Result then
    ALength := Self.Length;
end;

function TSegment.Normalized: TSegment;
  procedure Swap(var A, B: Integer); inline;
  var
    C: Integer;
  begin
    C := A;
    A := B;
    B := C;
  end;
begin
  Result := Self;
  if Result.X1 > Result.X2 then
    Swap(Result.X1, Result.X2);
  if Result.Y1 > Result.Y2 then
    Swap(Result.Y1, Result.Y2);
end;

function TSegment.Orientation: TSegmentOrientation;
begin
  if X1 = X2 then
    Exit(soX)
  else
    Exit(soY);
end;

{ TGridLocation }

constructor TGridLocation.Create(AX, AY: Integer);
begin
  Self.X := AX;
  Self.Y := AY;
end;

end.
