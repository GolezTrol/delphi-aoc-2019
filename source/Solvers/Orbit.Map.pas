unit Orbit.Map;

interface

uses
  AoC.Types, Spring.Collections;

type
  TOrbitMap = class
  private
    FBodies: IBodies;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddBody(const ID, Parent: String);
    function GetOrbitLevel(const ID: String): Integer;
    function GetPath(const ID: String): TStringArray;
    function GetDistance(const ID1, ID2: String): Integer;
    function GetBodies: IBodies;
  end;

implementation

{ TOrbitMap }

procedure TOrbitMap.AddBody(const ID, Parent: String);
var
  ParentBody: TBody;
  Body: TBody;
begin
  // The parent can already exist, if not create it, without a parent of its own.
  if not FBodies.TryGetValue(Parent, ParentBody) then
  begin
    ParentBody := TBody.Create;
    ParentBody.ID := Parent;
    ParentBody.Parent := nil;
    FBodies.Add(Parent, ParentBody);
  end;
  // The body itself could already be created as a parent for another body.
  if not FBodies.TryGetValue(ID, Body) then
  begin
    Body := TBody.Create;
    Body.ID := ID;
    FBodies.Add(ID, Body);
  end;
  // Whichever situation, it shouldn't have a parent yet. Set it now.
  Body.Parent := ParentBody;
end;

constructor TOrbitMap.Create;
begin
  FBodies := TCollections.CreateDictionary<String, TBody>;
end;

destructor TOrbitMap.Destroy;
var
  Body: TBody;
begin
  for Body in FBodies.Values do
    Body.Free;

  FBodies := nil;
  inherited;
end;

function TOrbitMap.GetBodies: IBodies;
begin
  Result := FBodies;
end;

function TOrbitMap.GetDistance(const ID1, ID2: String): Integer;
var
  Path1: TStringArray;
  Path2: TStringArray;
  i1, i2: Integer;
begin
  Path1 := GetPath(ID1);
  Path2 := GetPath(ID2);
  i1 := High(Path1);
  i2 := High(Path2);
  if (i1 < 0) or (i2 < 0) then
    Exit(-1); // At least one of the bodies is not found. Return -1 as error code.

  while (i1 > 0) and (i2 > 0) and (Path1[i1] = Path2[i2]) do
  begin
    Dec(i1);
    Dec(i2);
  end;
  Result := i1 + i2;
end;

function TOrbitMap.GetOrbitLevel(const ID: String): Integer;
var
  Body: TBody;
begin
  Result := -1;
  if FBodies.TryGetValue(ID, Body) then
  begin
    repeat
      Inc(Result);
      Body := Body.Parent;
    until Body = nil;
  end;
end;

function TOrbitMap.GetPath(const ID: String): TStringArray;
var
  Body: TBody;
begin
  if FBodies.TryGetValue(ID, Body) then
  repeat
    SetLength(Result, Length(Result) + 1);
    Result[High(Result)] := Body.ID;
    Body := Body.Parent;
  until Body = nil;
end;

end.
