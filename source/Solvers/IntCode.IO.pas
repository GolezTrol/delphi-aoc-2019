unit IntCode.IO;

interface

uses
  AoC.Types,
  IntCode.Types;

type
  IIntCodeArrayIO = interface(IIO)
    function GetOutputs: TIntegerArray;
    function GetLastOutput: TAoCInt;
  end;

  TIntCodeArrayIO = class(TInterfacedObject, IIO, IIntCodeArrayIO)
  private
    FInputs: TIntegerArray;
    FInputPointer: Integer;
    FOutputs: TIntegerArray;
  private  // IIO
    function Read: TAoCInt;
    procedure Write(Value: TAoCInt);
  private // IIntCodeArrayIO
    function GetOutputs: TIntegerArray;
    function GetLastOutput: TAoCInt;
  public
    constructor Create(Inputs: TIntegerArray);
  end;

implementation

{ TIntCodeArrayIO }

constructor TIntCodeArrayIO.Create(Inputs: TIntegerArray);
begin
  FInputs := Inputs;
  inherited Create;
end;

function TIntCodeArrayIO.GetLastOutput: TAocInt;
begin
  Result := 0;
  if Length(FOutputs) > 0 then
    Result := FOutputs[High(FOutputs)];
end;

function TIntCodeArrayIO.GetOutputs: TIntegerArray;
begin
  Result := FOutputs;
end;

function TIntCodeArrayIO.Read: TAoCInt;
begin
  if FInputPointer >= Length(FInputs) then
    raise EIntCodeIO.Create('EOF on inputs');
  Result := FInputs[FInputPointer];
  Inc(FInputPointer);
end;

procedure TIntCodeArrayIO.Write(Value: TAoCInt);
begin
  // Easy but inefficient re-allocation on every write. To be improved once we
  // get programs with a lot of output.
  SetLength(FOutputs, Length(FOutputs)+1);
  FOutputs[High(FOutputs)] := Value;
end;

end.
