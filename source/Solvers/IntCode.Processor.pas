unit IntCode.Processor;

interface

uses
  AoC.Types,
  SysUtils,
  Math,
  IntCode.Types;

type
  TProgramState = (psUnstarted, psSuspended, psRunning, psHalted);

  TIntCodeProgram = class
  private
    // Global program state
    Code: TIntegerArray; // The program code/memory
    Position: Integer; // Instruction pointer
    RelativeBase: Integer; // Relative base (offset) of position)
    State: TProgramState; // Running state
    // Current instruction.
    OpCode: Integer; // The opcode
    Modes: Integer; // Parameter modes
    ModeIndex: Integer; // Parameter index (for reading from modes)
  public
    constructor Create(ACode: TIntegerArray);
    property ProgramState: TProgramState read State;
    property MemDump: TIntegerArray read Code;
  end;

  TIntCodeProcessor = class(TInterfacedObject)
  private
    FIO: IIO;
  public
    constructor Create(AInput: IIO);
    procedure Execute(var Code: TIntegerArray);
    function ExecuteScalar(const Code: TIntegerArray): TAoCInt;
    procedure Run(AProgram: TIntCodeProgram);
  end;

implementation

constructor TIntCodeProcessor.Create(AInput: IIO);
begin
  FIO := AInput;
end;

procedure TIntCodeProcessor.Execute(var Code: TIntegerArray);
var
  p: TIntCodeProgram;
begin
  p := TIntCodeProgram.Create(Code);
  try
    repeat
      Run(p);
    until p.State = psHalted;
  finally
    p.Free;
  end;
end;

function TIntCodeProcessor.ExecuteScalar(const Code: TIntegerArray): TAocInt;
var
  CodeCopy: TIntegerArray;
begin
  CodeCopy := Copy(Code, 0, Length(Code));
  Execute(CodeCopy);
  Result := CodeCopy[0];
end;

procedure TIntCodeProcessor.Run(AProgram: TIntCodeProgram);
const
  MODE_POSITION = 0;
  MODE_IMMEDATE = 1;
  MODE_RELATIVE = 2;

  function ReadAddress(Address: Integer): TAoCInt;
  begin
    if Address > High(AProgram.Code) then
      Exit(0);
    Result := AProgram.Code[Address];
  end;

  function ReadValue: TAoCInt;
  begin
    // Read a value and increment the position
    Result := ReadAddress(AProgram.Position);
    Inc(AProgram.Position);
  end;

  function GetMode: Integer;
  begin
    Result := (AProgram.Modes div Trunc(IntPower(10, AProgram.ModeIndex))) mod 10;
    Inc(AProgram.ModeIndex);
  end;

  function ReadParam: TAoCInt;
  begin
    // Read a value, and depending on the mode, use it immediately, or use it
    // as an address for reading from.
    Result := ReadValue;

    case GetMode of
      MODE_POSITION:
        Result := ReadAddress(Result);
      MODE_RELATIVE:
        Result := ReadAddress(Result + AProgram.RelativeBase);
    end;
  end;

  procedure Write(const Value: TAoCInt; const Addr: Integer);
  var
    AbsAddr: Integer;
  begin
    AbsAddr := Addr;
    case GetMode of
      MODE_RELATIVE:
        AbsAddr := AbsAddr + AProgram.RelativeBase;
    end;
    if AbsAddr > High(AProgram.Code) then
      SetLength(AProgram.Code, AbsAddr+1000);
    AProgram.Code[AbsAddr] := Value;
  end;

  procedure Jump(const Condition: Boolean; const Addr: Integer);
  begin
    if Condition then
      AProgram.Position := Addr;
  end;

var
  Condition: Boolean;
begin
  if AProgram.State = psSuspended then
    Write(FIO.Read, ReadValue);
  AProgram.State := psRunning;

  repeat
    AProgram.OpCode := ReadValue;
    AProgram.Modes := AProgram.OpCode div 100;
    AProgram.ModeIndex := 0;
    AProgram.OpCode := AProgram.OpCode mod 100;
    case AProgram.OpCode of
      1: // Add
        Write(ReadParam+ReadParam, ReadValue);
      2: // Multiply
        Write(ReadParam*ReadParam, ReadValue);
      3: // Wait for input
        AProgram.State := psSuspended;
      4: // Read output
        FIO.Write(ReadParam);
      5: // Jump if true
      begin
        Condition := ReadParam <> 0;
        Jump(Condition, ReadParam);
      end;
      6: // Jump if false
      begin
        Condition := ReadParam = 0;
        Jump(Condition, ReadParam);
      end;
      7: // Less than
      begin
        Condition := ReadParam < ReadParam;
        Write(Ord(Condition), ReadValue);
      end;
      8: // Equal
      begin
        Condition := ReadParam = ReadParam;
        Write(Ord(Condition), ReadValue);
      end;
      9:
        AProgram.RelativeBase := AProgram.RelativeBase + ReadParam;
      99:
        AProgram.State := psHalted;
    else
      raise EInvalidOpCode.CreateFmt('Unknown opcode %d at address %d', [AProgram.OpCode, AProgram.Position-1]);
    end;

  until AProgram.State in [psSuspended, psHalted];
end;

{ TProgram }

constructor TIntCodeProgram.Create(ACode: TIntegerArray);
begin
  Code := ACode;
  Position := 0;
  RelativeBase := 0;
  State := psUnstarted;
end;

end.
