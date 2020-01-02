unit IntCode.IO;

interface

uses
  AoC.Types,
  IntCode.Types;

type
  IIntCodeArrayIO = interface(IIO)
    function GetOutputs: TIntegerArray;
    function GetLastOutput: Integer;
  end;

  TIntCodeArrayIO = class(TInterfacedObject, IIO, IIntCodeArrayIO)
  private
    FInputs: TIntegerArray;
    FInputPointer: Integer;
    FOutputs: TIntegerArray;
  private  // IIO
    function Read: Integer;
    procedure Write(Value: Integer);
  private // IIntCodeArrayIO
    function GetOutputs: TIntegerArray;
    function GetLastOutput: Integer;
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

function TIntCodeArrayIO.GetLastOutput: Integer;
begin
  Result := 0;
  if Length(FOutputs) > 0 then
    Result := FOutputs[High(FOutputs)];
end;

function TIntCodeArrayIO.GetOutputs: TIntegerArray;
begin
  Result := FOutputs;
end;

function TIntCodeArrayIO.Read: Integer;
begin
  if FInputPointer >= Length(FInputs) then
    raise EIntCodeIO.Create('EOF on inputs');
  Result := FInputs[FInputPointer];
  Inc(FInputPointer);
end;

procedure TIntCodeArrayIO.Write(Value: Integer);
begin
  // Easy but inefficient re-allocation on every write. To be improved once we
  // get programs with a lot of output.
  SetLength(FOutputs, Length(FOutputs)+1);
  FOutputs[High(FOutputs)] := Value;
end;

end.
