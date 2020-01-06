unit Asteroid.Map;

interface

uses
  AoC.Types,
  Spring.Collections;

type
  TAsteroid = class;

  TCanSee = record
    Me, Other: TAsteroid;
    DeltaBlockerX, DeltaBlockerY, NormalFactor: Integer;
    i: Integer;
    DeltaOtherX: Integer;
    DeltaOtherY: Integer;
    NormalX: Double;
    NormalY: Double;
    SignX: Integer;
    SignY: Integer;
    constructor Create(AMe, AOther: TAsteroid);
    function Past(Blocker: TAsteroid): Boolean;
  end;

  TAsteroid = class
    X, Y: Integer;
    Number: Integer;
    function DistanceTo(Other: TAsteroid): Integer;
    // True if Self can see Other. False if line of sight is blocked by Blocker.
    function CanSee(Blocker, Other: TAsteroid): Boolean; overload;
    function CanSee(Other: TAsteroid): TCanSee; overload;
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
  Classes, Math;

{ TAsteroid }

function TAsteroid.CanSee(Blocker, Other: TAsteroid): Boolean;
begin
  Result := TCanSee.Create(Self, Other).Past(Blocker);
end;

function TAsteroid.CanSee(Other: TAsteroid): TCanSee;
begin
  Result := TCanSee.Create(Self, Other);
end;

constructor TAsteroid.Create(const AX, AY: Integer);
begin
  X := AX; Y := AY;
end;

function TAsteroid.DistanceTo(Other: TAsteroid): Integer;
begin
  // Manhattan distance is good enough, it's mainly to sort asteroids
  // that are in the same line of sight. If they are not, it doesn't matter.
  Result := Abs(X - Other.X) + Abs(Y - Other.Y);
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
  Candidates: IAsteroidList;
  Candidate, Blocker, Other: TAsteroid;
  IsBlocked: Boolean;
begin
  Candidates := TCollections.CreateList<TAsteroid>;
  Candidates.AddRange(FAsteroids);

  for Candidate in FAsteroids do
    Candidate.Number := 0;

  for Candidate in FAsteroids do
    for Other in FAsteroids do
    begin
      if Candidate = Other then
        Continue;

      IsBlocked := False;

      with Candidate.CanSee(Other) do
      begin
        for Blocker in FAsteroids do
        begin
          if (Candidate = Blocker) or (Blocker = Other) then
            Continue;

          if not Past(Blocker) then
          begin
            IsBlocked := True;
            Break;
          end;
        end;
      end;

      if not IsBlocked then
        Inc(Candidate.Number);
    end;

  Result := Candidates;
end;

{ TCanSee }

constructor TCanSee.Create(AMe, AOther: TAsteroid);
var
  i: Integer;
begin
  Me := AMe;
  Other := AOther;

  DeltaOtherX := Abs(Other.X - Me.X);
  DeltaOtherY := Abs(Other.Y - Me.Y);

  for i := Max(DeltaOtherX, DeltaOtherY) downto 1 do
  begin
    if (DeltaOtherX mod i = 0) and (DeltaOtherY mod i = 0) then
    begin
      NormalFactor := i;
      Break;
    end;
  end;

  NormalX := DeltaOtherX div NormalFactor;
  NormalY := DeltaOtherY div NormalFactor;
end;

function TCanSee.Past(Blocker: TAsteroid): Boolean;
begin
  // Not all different, say true. There is no third one to block.
  if (Me = Blocker) or (Me = Other) or (Blocker = Other) then
    Exit(True);

  // Not in the same quadrant? No need to look further, they are visible.
  if ((Blocker.X < Me.X) xor (Other.X < Me.X)) or ((Blocker.Y < Me.Y) xor (Other.Y < Me.Y)) then
    Exit(True);

  DeltaBlockerX := Abs(Blocker.X - Me.X);
  DeltaBlockerY := Abs(Blocker.Y - Me.Y);

  // Further away? Can't be blocking. Visible is true.
  if (DeltaBlockerX > DeltaOtherX) or (DeltaBlockerY > DeltaOtherY) then
    Exit(True);

  Result := ((DeltaBlockerX * NormalY) <> (DeltaBlockerY * NormalX));
end;

end.
