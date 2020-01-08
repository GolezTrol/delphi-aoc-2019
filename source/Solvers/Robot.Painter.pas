unit Robot.Painter;

interface

uses
  AoC.Types,
  IntCode.Types,
  Spring.Collections;

type
  TPanel = record
    X, Y, Color: Integer;
    constructor Create(AX, AY, AColor: Integer);
  end;

  IPanels = IDictionary<String, TPanel>;

  IRobotPainter = interface(IIO)
    function GetPanels: IPanels;
    function Draw: String;
  end;

  TRobotPainter = class(TInterfacedObject, IIO, IRobotPainter)
  private // IIO
    function Read: TAoCInt;
    procedure Write(Value: TAoCInt);
  public
    InitialColor: Integer;
    X, Y: Integer;
    State: Integer;
    Panels: IPanels;
    Direction: Integer;
    constructor Create(AInitialColor: Integer);
    destructor Destroy; override;
    function GetKey(AX, AY: Integer): String;
    function GetColor(AX, AY: Integer): Integer;
    procedure Move(ADirection: Integer);
    function GetPanels: IPanels;
    function Draw: String;
  end;

implementation

uses
  SysUtils, Math;

{ TRobotPainter }

constructor TRobotPainter.Create(AInitialColor: Integer);
begin
  inherited Create;
  Panels := TCollections.CreateDictionary<String, TPanel>;
  InitialColor := (AInitialColor);
end;

destructor TRobotPainter.Destroy;
begin
  Panels := nil;
  inherited;
end;

function TRobotPainter.Draw: String;
var
  OffX, OffY: Integer;
  MinX, MinY: Integer;
  MaxX, MaxY: Integer;
  Panel: TPanel;
  Lines: TStringArray;
  i: Integer;
  ColorChar: Char;
  Line: String;
begin
  OffX := 0; OffY := 0;
  MinX := MAXINT; MinY := MAXINT;
  MaxX := 0; MaxY := 0;

  for Panel in Panels.Values do
  begin
    MaxX := Max(MaxX, Panel.X);
    MaxY := Max(MaxY, Panel.Y);
    MinX := Min(MinX, Panel.X);
    MinY := Min(MinY, Panel.Y);
  end;
  if MinY < 0 then OffY := -MinY;
  if MinX <= 0 then OffX := -MinX+1;
  SetLength(Lines, MaxY + OffY + 1);

  for i := Low(Lines)to High(Lines) do
    Lines[i] := StringOfChar('.', MaxX + OffX);

  for Panel in Panels.Values do
  begin
    case Panel.Color of
      0: ColorChar := '.';
      1: ColorChar := '#';
    else
      ColorChar := '?';
    end;
    Lines[Panel.Y + OffY][Panel.X + OffX] := ColorChar;
  end;

  Result := '';
  for Line in Lines do
    Result := Result + Line + #13#10;

end;

function TRobotPainter.GetColor(AX, AY: Integer): Integer;
var
  Panel: TPanel;
begin
  if Panels.Count = 0 then
    Exit(InitialColor);

  // If the panel wasn't painted yet, it is still black.
  if Panels.TryGetValue(GetKey(AX, AY), Panel) then
    Exit(Panel.Color);

  Exit(0); // Black

end;

function TRobotPainter.GetKey(AX, AY: Integer): String;
begin
  Result := Format('%d,%d', [AX, AY]);
end;

function TRobotPainter.GetPanels: IPanels;
begin
  Result := Panels;
end;

procedure TRobotPainter.Move(ADirection: Integer);
begin
  // Turn (0 = left, 1 = right)
  case ADirection of
    0: Dec(Direction);
    1: Inc(Direction);
  end;
  Direction := (Direction + 4) mod 4;

  // Move (0 = up, 1 = right, 2 = down, 3 = left)
  case Direction of
    0: Dec(Y);
    1: Inc(X);
    2: Inc(Y);
    3: Dec(X);
  end;
end;

function TRobotPainter.Read: TAoCInt;
begin
  Result := GetColor(X, Y);
end;

procedure TRobotPainter.Write(Value: TAoCInt);
begin
  // Remember what command is expected (0 = paint, 1 = move)
  case State of
    0: Panels.AddOrSetValue(GetKey(X, Y), TPanel.Create(X, Y, Value));
    1: Move(Value);
  end;
  Inc(State);
  if State = 2 then
    State := 0;
end;

{ TPanel }

constructor TPanel.Create(AX, AY, AColor: Integer);
begin
  X := AX; Y := AY; Color := AColor;
end;

end.
