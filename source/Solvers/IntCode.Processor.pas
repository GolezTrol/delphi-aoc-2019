unit IntCode.Processor;

interface

uses
  AoC.Types,
  SysUtils,
  Math;

type
  EIntCode = class(Exception);
  EInvalidOpCode = class(EIntCode);

  IIO = interface
    ['{83FEF665-616E-4CD4-A9E8-CBBDA5392649}']
    function Read: Integer;
    procedure Write(Value: Integer);
  end;

  TIntCodeProcessor = class(TInterfacedObject)
  private
    FIO: IIO;
  public
    constructor Create(AInput: IIO);
    procedure Execute(var Code: TIntegerArray);
    function ExecuteScalar(const Code: TIntegerArray): Integer;
  end;

implementation

constructor TIntCodeProcessor.Create(AInput: IIO);
begin
  FIO := AInput;
end;

procedure TIntCodeProcessor.Execute(var Code: TIntegerArray);
var
  Position: Integer;
  Modes: Integer;
  ModeIndex: Integer;
  OpCode: Integer;

  function ReadValue: Integer;
  begin
    // Read a value and increment the position
    Result := Code[Position];
    Inc(Position);
  end;

  function ReadMode: Integer;
  const
    MODE_ADDRESS = 0;
    MODE_IMMEDATE = 1;
  var
    Mode: Integer;
  begin
    // Read a value, and depending on the mode, use it immediately, or use it
    // as an address for reading from.
    Result := ReadValue;

    Mode := (Modes div Trunc(IntPower(10, ModeIndex))) mod 10;
    Inc(ModeIndex);

    if Mode = MODE_ADDRESS then
      Result := Code[Result]
  end;

  procedure Write(const Value, Addr: Integer);
  begin
    Code[Addr] := Value;
  end;

begin
  Position := 0;
  repeat
    OpCode := ReadValue;
    Modes := OpCode div 100;
    ModeIndex := 0;
    OpCode := OpCode mod 100;
    case OpCode of
      1: // Add
        Write(ReadMode+ReadMode, ReadValue);
      2: // Multiply
        Write(ReadMode*ReadMode, ReadValue);
      3: // Store input
        Write(FIO.Read, ReadValue);
      4: // Read output
        FIO.Write(ReadMode);
      99:
        Break;
    else
      raise EInvalidOpCode.CreateFmt('Unknown opcode %d at address %d', [OpCode, Position-1]);
    end;

  until False;

end;

function TIntCodeProcessor.ExecuteScalar(const Code: TIntegerArray): Integer;
var
  CodeCopy: TIntegerArray;
begin
  CodeCopy := Copy(Code, 0, Length(Code));
  Execute(CodeCopy);
  Result := CodeCopy[0];
end;

end.
