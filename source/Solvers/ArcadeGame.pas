unit ArcadeGame;

interface

uses
  AoC.Types,
  IntCode.Types,
  Spring,
  Spring.Collections;

type
  TCoordinates = record
    X, Y: Integer;
    constructor Create(const AX, AY: TAoCInt);
  end;
  TGameObject = (Empty, Wall, Block, HorizontalPaddle, Ball);
  TGrid = IDictionary<TCoordinates, TGameObject>;
  TOutput = (Xpos, Ypos, Obj);

  IArcadeGame = interface(IIO)
    function GetGrid: TGrid;
  end;

  TArcadeGame = class(TInterfacedObject, IIO, IArcadeGame)
  private
    Output: TOutput;
    Outputs: array[TOutput] of TAocInt;
    Grid: TGrid;
    function Read: TAoCInt;
    procedure Write(Value: TAoCInt);
    function GetGrid: TGrid;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TArcadeGame }

constructor TArcadeGame.Create;
begin
  Grid := TCollections.CreateDictionary<TCoordinates, TGameObject>;
end;

destructor TArcadeGame.Destroy;
begin
  Grid := nil;
  inherited;
end;

function TArcadeGame.GetGrid: TGrid;
begin
  Result := Grid;
end;

function TArcadeGame.Read: TAoCInt;
begin
  Result := 0;
end;

procedure TArcadeGame.Write(Value: TAoCInt);
begin
  Outputs[Output] := Value;
  if Output = Obj then
  begin
    Output := Xpos;
    Grid.AddOrSetValue(TCoordinates.Create(Outputs[Xpos], Outputs[Ypos]), TGameObject(Outputs[Obj]));
  end
  else
    Inc(Output);
end;

{ TCoordinates }

constructor TCoordinates.Create(const AX, AY: TAoCInt);
begin
  X := AX;
  Y := AY;
end;

end.
