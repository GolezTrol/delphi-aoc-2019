unit IntCode.Processor;

interface

uses
  AoC.Types,
  SysUtils;

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
  OpCode: Integer;

  function ReadInc: Integer;
  begin
    Result := Code[Position];
    Inc(Position);
  end;

  function ReadAddr: Integer;
  begin
    Result := Code[ReadInc];
  end;

  procedure Write(const Value, Addr: Integer);
  begin
    Code[Addr] := Value;
  end;

begin
  Position := 0;
  repeat
    OpCode := ReadInc;
    case OpCode of
      1: // Add
        Write(ReadAddr+ReadAddr, ReadInc);
      2: // Multiply
        Write(ReadAddr*ReadAddr, ReadInc);
      3: // Store input
        Write(FIO.Read, ReadInc);
      4: // Read output
        FIO.Write(ReadAddr);
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
