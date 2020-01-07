unit Asteroid.Map;

interface

uses
  AoC.Types,
  Spring.Collections;

type
  TAsteroid = class
    X, Y: Integer;
    Number: Integer;
    DX, DY: Integer;
    DistanceSq: Integer;
    Quadrant: Integer;
    constructor Create(const AX, AY: Integer);
  end;

  IAsteroidList = IList<TAsteroid>;
  TAsteroidPlotter = reference to function(A: TAsteroid): Char;

  TAsteroidMap = class
  private
    FAsteroids: IAsteroidList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const X, Y: Integer);
    function GetMonitorCandidates: IAsteroidList;
    procedure GetBestOutlook(out AX, AY, ANumber: Integer);
    function Draw(AAsteroids: IAsteroidList; APlotter: TAsteroidPlotter): String; overload;
    function DrawCandidates: String; overload;
    function Draw: String; overload;
  end;

implementation

uses
  SysUtils, Classes, Math;

{ TAsteroid }

constructor TAsteroid.Create(const AX, AY: Integer);
begin
  X := AX; Y := AY;
end;

{ TAsteroidMap }

procedure TAsteroidMap.Add(const X, Y: Integer);
begin
  FAsteroids.Add(TAsteroid.Create(X, Y));
end;

constructor TAsteroidMap.Create;
begin
  FAsteroids := TCollections.CreateList<TAsteroid>;
end;

destructor TAsteroidMap.Destroy;
var
  Asteroid: TAsteroid;
begin
  for Asteroid in FAsteroids do
    Asteroid.Free;
  inherited;
end;

function TAsteroidMap.Draw(AAsteroids: IAsteroidList; APlotter: TAsteroidPlotter): String;
var
  Asteroid: TAsteroid;
  X, Y: Integer;
  sl: TStringList;
  i: Integer;
  s: String;
begin
  X := 0; Y := 0;
  for Asteroid in AAsteroids do
  begin
    X := Max(X, Asteroid.X);
    Y := Max(Y, Asteroid.Y);
  end;

  sl := TStringList.Create;
  try
    for i := 0 to Y do
      sl.Add(StringOfChar('.', X+1));

    for Asteroid in AAsteroids do
    begin
      s := sl[Asteroid.Y];
      s[Asteroid.X+1] := APlotter(Asteroid);
      sl[Asteroid.Y] := s;
    end;

    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

function TAsteroidMap.Draw: String;
begin
  Result := Draw(FAsteroids, function(A: TAsteroid): Char begin Result := '#' end);
end;

function TAsteroidMap.DrawCandidates: String;
var
  Candidates: IAsteroidList;
begin
  Candidates := GetMonitorCandidates;
  Result := Draw(Candidates,
    function(A: TAsteroid): Char
    begin
      Result := Chr(Ord('0') + A.Number);
    end);
end;

procedure TAsteroidMap.GetBestOutlook(out AX, AY, ANumber: Integer);

var
  Candidates: IAsteroidList;
begin
  Candidates := GetMonitorCandidates;

  Candidates.Sort(
    function(const A, B: TAsteroid): Integer
    begin
      Result := B.Number - A.Number;
    end);

  if Candidates.Any then
  begin
    AX := Candidates[0].X;
    AY := Candidates[0].Y;
    ANumber := Candidates[0].Number;
  end;
end;

function TAsteroidMap.GetMonitorCandidates: IAsteroidList;
var
  Candidates, Others: IAsteroidList;
  Candidate, Other: TAsteroid;
  o1, o2: Integer;
  Other1: TAsteroid;
  Other2: TAsteroid;
begin
  Candidates := TCollections.CreateList<TAsteroid>;
  Candidates.AddRange(FAsteroids);


  for Candidate in FAsteroids do
  begin
    Others := TCollections.CreateList<TAsteroid>;
    Others.AddRange(FAsteroids);

    Candidate.Number := 0;

    // Initialize each of the asteroids with a bit of data relative to Candidate.
    for Other in Others do
    begin
      Other.DX := (Other.X - Candidate.X);
      Other.DY := (Other.Y - Candidate.Y);
      Other.DistanceSq := Abs(Other.DX*Other.DX+Other.DY*Other.DY);

      Other.Quadrant := 0;
      // 0   1
      //   x
      // 2   3
      if Other.DX > 0 then
        Other.Quadrant := Other.Quadrant + 1;
      if Other.DY > 0 then
        Other.Quadrant := Other.Quadrant + 2;
    end;

    // Sort the others by quadrant and distance relative to Candidate.
    Others.Sort(
      function(const A, B: TAsteroid): Integer
      begin
        Result := A.Quadrant - B.Quadrant;
        if Result = 0 then
          Result := A.DistanceSq - B.DistanceSq;
      end);

    // Others[0] should be the candidate itself.
    // Then for each of the others, starting with the closest,
    if Others[0] <> Candidate then
      raise Exception.Create('Candidate expected to be first in list');
    o1 := 1;
    while o1 < Others.Count do
    begin
      o2 := o1 + 1;
      while o2 < Others.Count do
      begin
        Other1 := Others[o1];
        Other2 := Others[o2];
        if Other1.Quadrant <> Other2.Quadrant then
          Break;
        if (Other1.DX * Other2.DY) = (Other2.DX * Other1.DY) then
          Others.Delete(o2)
        else
          Inc(o2);
      end;
      Inc(o1);
    end;

    Candidate.Number := Others.Count - 1;
  end;

  Result := Candidates;
end;

end.
