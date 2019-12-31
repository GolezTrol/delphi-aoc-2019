unit IntCode.Processor;

interface

uses
  AoC.Types,
  SysUtils;

type
  EIntCode = class(Exception);
  EInvalidOpCode = class(EIntCode);

  TIntCodeProcessor = class
    procedure Execute(var Code: TIntegerArray);
    function ExecuteScalar(const Code: TIntegerArray): Integer;
  end;

implementation

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
