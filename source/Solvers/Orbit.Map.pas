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

end.
