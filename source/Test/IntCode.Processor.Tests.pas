unit IntCode.Processor.Tests;

interface

uses
  SysUtils,
  DUnitX.TestFramework,
  IntCode.Processor,
  InputUtils,
  AoC.Types;

type
  TTestIO = class(TInterfacedObject, IIO)
    Value: Integer;
    function Read: Integer;
    procedure Write(AValue: Integer);
  end;

  [TestFixture]
  TIntCodeProcessorTests = class(TObject)
  private
    FProcessor: TIntCodeProcessor;
    FIO: TTestIO;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase('Add 1', '1,0,0,0,99|2,0,0,0,99', '|')] // (1 + 1 = 2).
    [TestCase('Mul 1', '2,3,0,3,99|2,3,0,6,99', '|')] // (3 * 2 = 6).
    [TestCase('Mul 2', '2,4,4,5,99,0|2,4,4,5,99,9801', '|')] // (99 * 99 = 9801).
    [TestCase('Multiple statements', '1,1,1,4,99,5,6,0,99|30,1,1,4,2,5,6,0,99', '|')]
    [TestCase('Input', '3,0,99|12345,0,99', '|')]
    // Immediate mode
    [TestCase('Add immedate', '1001,0,2,0,99|1003,0,2,0,99', '|')] // (1001 + 2 = 1003).
    // Negative numbers
    [TestCase('Add immedate', '1101,100,-1,4,0|1101,100,-1,4,99', '|')] // (100+-1).
    procedure TestExecute(const Input: String; const Expected: String);

    [Test]
    [TestCase('Output', '4,3,99,23456|23456', '|')]
    [TestCase('Output', '104,3,99,23456|3', '|')]
    procedure TestOutput(const Input: String; const Expected: String);

    [TestCase('Multiple statements', '1,1,1,4,99,5,6,0,99|30', '|')]
    procedure TestExecuteScalar(const Input: String; const Expected: String);
  end;

implementation

procedure TIntCodeProcessorTests.Setup;
begin
  FIO := TTestIO.Create;
  FProcessor := TIntCodeProcessor.Create(FIO);
end;

procedure TIntCodeProcessorTests.TearDown;
begin
  FProcessor.Free;
end;

procedure TIntCodeProcessorTests.TestExecute(const Input, Expected: String);
var
  Code, ExpectedCode: TIntegerArray;
  i: Integer;
begin
  Code := TInput.IntCommaSeparated(Input);
  ExpectedCode := TInput.IntCommaSeparated(Expected);
  FProcessor.Execute(Code);
  Assert.AreEqual(Length(ExpectedCode), Length(Code), 'Length of codes');
  if Length(ExpectedCode) = Length(Code) then
    for i := Low(Code) to High(Code) do
      Assert.AreEqual(Integer(ExpectedCode[i]), Code[i], 'Item ' + i.ToString);
end;

procedure TIntCodeProcessorTests.TestExecuteScalar(const Input,
  Expected: String);
var
  Code: TIntegerArray;
begin
  Code := TInput.IntCommaSeparated(Input);
  Assert.AreEqual(Expected, FProcessor.ExecuteScalar(Code).ToString);
end;

procedure TIntCodeProcessorTests.TestOutput(const Input, Expected: String);
var
  Code: TIntegerArray;
begin
  Code := TInput.IntCommaSeparated(Input);
  FProcessor.Execute(Code);
  Assert.AreEqual(Expected, FIO.Value.ToString);
end;

{ TTestInput }

function TTestIO.Read: Integer;
begin
  Result := 12345;
end;

procedure TTestIO.Write(AValue: Integer);
begin
  Value := AValue;
end;

initialization
  TDUnitX.RegisterTestFixture(TIntCodeProcessorTests);
end.
