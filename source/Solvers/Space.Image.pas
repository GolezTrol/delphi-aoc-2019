unit Space.Image;

interface

uses
  AoC.Types;

type
  TSpaceImage = class
  private
    FData: TIntegerArray;
    FWidth, FHeight: Integer;
  public
    procedure LoadFrom(Data: TIntegerArray; AWidth, AHeight: Integer);
    function GetLayerCount: Integer;
    function GetLayerData(Index: Integer): TIntegerArray;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    function CheckProduct(FewestOf: Integer; Digits: TIntegerArray): Integer;
    function Flatten: TIntegerArray;
    function Draw: String;
  end;

implementation

uses
  SysUtils;

{ TSpaceImage }

function TSpaceImage.CheckProduct(FewestOf: Integer; Digits: TIntegerArray): Integer;
var
  LayerIndex, Pixel: Integer;
  Layer, LowestLayer: TIntegerArray;
  Count, LowestCount: Integer;
  Counts: TIntegerArray;
  DigitIndex: Integer;
begin
  LowestCount := MAXINT;
  for LayerIndex := 0 to GetLayerCount - 1 do
  begin
    Layer := GetLayerData(LayerIndex);
    Count := 0;
    for Pixel in Layer do
      if Pixel = FewestOf then
        Inc(Count);
    if LowestCount >= Count then
    begin
      LowestLayer := Layer;
      LowestCount := Count;
    end;
  end;
  SetLength(Counts, Length(Digits));
  for Pixel in LowestLayer do
    for DigitIndex := Low(Digits) to High(Digits) do
      if Pixel = Digits[DigitIndex] then
        Inc(Counts[DigitIndex]);
  Result := 1;
  for DigitIndex in Counts do
    Result := Result * DigitIndex;
end;

function TSpaceImage.Draw: String;
var
  Data: TIntegerArray;
  Pixel, Index: Integer;
begin
  Data := Flatten;
  SetLength(Result, Length(Data) + Height);
  Index := 1;
  for Pixel in Data do
  begin
    if ((Index - 1) mod (Width+1)) = 0 then
    begin
      Result[Index] := #10;
      Inc(Index);
    end;
    case Pixel of
      0: Result[Index] := '?';
      1: Result[Index] := '?';
      2: Result[Index] := ' ';
    end;
    Inc(Index);
  end;

  Result := AdjustLineBreaks(Result);
end;

function TSpaceImage.Flatten: TIntegerArray;
var
  Layer: TIntegerArray;
  l: Integer;
  p: Integer;
begin
  Result := GetLayerData(0);
  for l := 1 to GetLayerCount - 1 do
  begin
    Layer := GetLayerData(l);
    for p := Low(Layer) to High(Layer) do
      if Result[p] = 2 then
        Result[p] := Layer[p];
  end;
end;

function TSpaceImage.GetLayerCount: Integer;
begin
  Result := Length(FData) div (FWidth * FHeight);
end;

function TSpaceImage.GetLayerData(Index: Integer): TIntegerArray;
var
  Size: Integer;
begin
  Size := FWidth * FHeight;
  Result := Copy(FData, Index * Size, Size);
end;

procedure TSpaceImage.LoadFrom(Data: TIntegerArray; AWidth, AHeight: Integer);
begin
  FData := Copy(Data, 0, Length(Data));
  FWidth := AWidth;
  FHeight := AHeight;
end;

end.
