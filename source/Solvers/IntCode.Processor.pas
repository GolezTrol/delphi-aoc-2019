unit IntCode.Processor;

interface

uses
  AoC.Types,
  SysUtils,
  Math,
  IntCode.Types;

type
  TProgramState = (psSuspended, psRunning, psHalted);

  TProgram = class
  private
    Code: TIntegerArray;
    Position: Integer;
    State: TProgramState;
  public
    constructor Create(ACode: TIntegerArray);
  end;

  TIntCodeProcessor = class(TInterfacedObject)
  private
    FIO: IIO;
  public
    constructor Create(AInput: IIO);
    procedure Execute(var Code: TIntegerArray);
    function ExecuteScalar(const Code: TIntegerArray): Integer;
    procedure Run(AProgram: TProgram);
  end;

implementation

constructor TIntCodeProcessor.Create(AInput: IIO);
begin
  FIO := AInput;
end;

procedure TIntCodeProcessor.Execute(var Code: TIntegerArray);
var
  p: TProgram;
begin
  p := TProgram.Create(Code);
  try
    repeat
      Run(p);
    until p.State = psHalted;
  finally
    p.Free;
  end;
end;

function TIntCodeProcessor.ExecuteScalar(const Code: TIntegerArray): Integer;
var
  CodeCopy: TIntegerArray;
begin
  CodeCopy := Copy(Code, 0, Length(Code));
  Execute(CodeCopy);
  Result := CodeCopy[0];
end;

procedure TIntCodeProcessor.Run(AProgram: TProgram);
var
  Modes: Integer;
  ModeIndex: Integer;
  OpCode: Integer;

  function ReadValue: Integer;
  begin
    // Read a value and increment the position
    Result := AProgram.Code[AProgram.Position];
    Inc(AProgram.Position);
  end;

  function ReadParam: Integer;
  const
    MODE_POSITION = 0;
    MODE_IMMEDATE = 1;
  var
    Mode: Integer;
  begin
    // Read a value, and depending on the mode, use it immediately, or use it
    // as an address for reading from.
    Result := ReadValue;

    Mode := (Modes div Trunc(IntPower(10, ModeIndex))) mod 10;
    Inc(ModeIndex);

    if Mode = MODE_POSITION then
      Result := AProgram.Code[Result]
  end;

  procedure Write(const Value, Addr: Integer);
  begin
    AProgram.Code[Addr] := Value;
  end;

  procedure Jump(const Condition: Boolean; const Addr: Integer);
  begin
    if Condition then
      AProgram.Position := Addr;
  end;

begin
  AProgram.State := psRunning;
  repeat
    OpCode := ReadValue;
    Modes := OpCode div 100;
    ModeIndex := 0;
    OpCode := OpCode mod 100;
    case OpCode of
      1: // Add
        Write(ReadParam+ReadParam, ReadValue);
      2: // Multiply
        Write(ReadParam*ReadParam, ReadValue);
      3: // Store input
        Write(FIO.Read, ReadValue);
      4: // Read output
        FIO.Write(ReadParam);
      5: // Jump if true
        Jump(ReadParam <> 0, ReadParam);
      6: // Jump if false
        Jump(ReadParam = 0, ReadParam);
      7: // Less than
        Write(Ord(ReadParam < ReadParam), ReadValue);
      8: // Equal
        Write(Ord(ReadParam = ReadParam), ReadValue);
      99:
        AProgram.State := psHalted;
    else
      raise EInvalidOpCode.CreateFmt('Unknown opcode %d at address %d', [OpCode, AProgram.Position-1]);
    end;

  until AProgram.State in [psSuspended, psHalted];
end;

{ TProgram }

constructor TProgram.Create(ACode: TIntegerArray);
begin
  Code := ACode;
  Position := 0;
  State := psSuspended;
end;

end.
