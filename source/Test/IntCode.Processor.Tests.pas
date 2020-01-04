unit IntCode.Processor.Tests;

interface

uses
  SysUtils,
  DUnitX.TestFramework,
  AoC.Assert.Helper,
  IntCode.Types,
  IntCode.IO,
  IntCode.Processor,
  InputUtils,
  AoC.Types;

type
  [TestFixture]
  TIntCodeProcessorTests = class(TObject)
  private
    FProcessor: TIntCodeProcessor;
    FIO: IIntCodeArrayIO;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    // Opcodes
    [TestCase('Add Position', '1,0,0,0,99|2,0,0,0,99', '|')] // (1 + 1 = 2).
    [TestCase('Add Immediate 1', '1001,0,2,0,99|1003,0,2,0,99', '|')] // (1001 + 2 = 1003).
    [TestCase('Add Immediate 2', '1101,15,20,3,99|1101,15,20,35,99', '|')] // (15+20=35).
    [TestCase('Add Immediate 3', '101,20,1,3,99|101,20,1,40,99', '|')] // (20+20=40).
    [TestCase('Mul Position 1', '2,3,0,3,99|2,3,0,6,99', '|')] // (3 * 2 = 6).
    [TestCase('Mul Position 2', '2,4,4,5,99,0|2,4,4,5,99,9801', '|')] // (99 * 99 = 9801).
    [TestCase('Mul Immediate 1', '1102,3,4,3,99|1102,3,4,12,99', '|')] // (3 * 4 = 12).
    [TestCase('Input Position', '3,0,99|12345,0,99', '|')]
    // Because @2 = 0, continue with the multiplication and store its result (8) in pos 2.
    [TestCase('Jump-if-true Position', '5,2,0,1102,2,4,2,99|5,2,8,1102,2,4,2,99', '|')]
    // Because @2 = 0, continue with the multiplication and store its result (14) in pos 2.
    // After that, jump to position zero again.
    // The jump there will now find the 14, read the position (8) from address 14.
    // At pos 8 is an addition that will add up addresses 0 and 3 (5+1102=1107) and store them back in 0
    [TestCase('Jump-if-true Position', '5,2,0,1102,2,7,2,1105,1,0,3,0,99,0,8|1107,2,14,1102,2,7,2,1105,1,0,3,0,99,0,8', '|')]
    // Because 3<>0, jump to position 5 which has an input instruction.
    [TestCase('Jump-if-true Immediate', '1105,3,5,0,0,3,4,99|1105,3,5,0,12345,3,4,99', '|')]
    // False false, so jump to 3+4=7
    [TestCase('Jump-if-false Position', '1106,0,4,99,1101,3,4,0,99|7,0,4,99,1101,3,4,0,99', '|')]
    // Not false, so just continue with 3+4=7
    [TestCase('Jump-if-false Immediate', '1106,3,5,1101,3,4,0,99|7,3,5,1101,3,4,0,99', '|')]
    [TestCase('Less than, false, Position', '7,0,1,3,99|7,0,1,0,99', '|')] // 7 is not less than 0
    [TestCase('Less than, true, Position', '7,0,4,3,99|7,0,4,1,99', '|')] // 7 is less than 99
    [TestCase('Less than, false, Immediate', '1107,3,2,3,99|1107,3,2,0,99', '|')] // 3 is not less than 2
    [TestCase('Less than, true, Immediate', '1107,2,3,3,99|1107,2,3,1,99', '|')] // 2 is less than 3

    [TestCase('Equal, false, Position', '8,0,1,3,99|8,0,1,0,99', '|')] // 8 is not equal to 0
    [TestCase('Equal, true, Position', '8,0,5,3,99,8|8,0,5,1,99,8', '|')] // 8 is equal to 8
    [TestCase('Equal, false, Immediate', '1108,3,1,3,99|1108,3,1,0,99', '|')] // 3 is not equal to 1
    [TestCase('Equal, true, Immediate', '1108,7,7,3,99|1108,7,7,1,99', '|')] // 2 is less than 3
    // Complex
    [TestCase('Multiple statements', '1,1,1,4,99,5,6,0,99|30,1,1,4,2,5,6,0,99', '|')]
    // Negative numbers
    [TestCase('Add immedate', '1101,100,-1,4,0|1101,100,-1,4,99', '|')] // (100+-1).
    //
    [TestCase('Add immedate', '1101,100,-1,4,0|1101,100,-1,4,99', '|')] // (100+-1).
    procedure TestExecute(const Input: String; const Expected: String);

    [Test]
    [TestCase('Output Position', '4,3,99,23456|23456', '|')]
    [TestCase('Output Immediate', '104,3,99,23456|3', '|')]
    // A given puzzle example.
    // The program will then output 999 if the input value is below 8, output 1000 if the input value is equal to 8, or output 1001 if the input value is greater than 8.
    // Since our input is 12345, the output should be 1001
    [TestCase('Complex program', '3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99|1001', '|')]
    procedure TestOutput(const Input: String; const Expected: String);

    [TestCase('Multiple statements', '1,1,1,4,99,5,6,0,99|30', '|')]
    procedure TestExecuteScalar(const Input: String; const Expected: String);

    // Add up 2 and 8 and write to address 0. After getting input, the program does another multiplication (9*10=90)
    [TestCase('Suspending', '1101,2,6,0,3,1,1102,9,10,2,99|8,2,6,0,3,1,1102,9,10,2,99|8,12345,90,0,3,1,1102,9,10,2,99', '|')]
    procedure TestSuspension(const Input: String; const First: String; const Final: String);
  end;

implementation

procedure TIntCodeProcessorTests.Setup;
begin
  FIO := TIntCodeArrayIO.Create([12345]);
  FProcessor := TIntCodeProcessor.Create(FIO);
end;

procedure TIntCodeProcessorTests.TearDown;
begin
  FProcessor.Free;
end;

procedure TIntCodeProcessorTests.TestExecute(const Input, Expected: String);
var
  Code, ExpectedCode: TIntegerArray;
begin
  Code := TInput.IntCommaSeparated(Input);
  ExpectedCode := TInput.IntCommaSeparated(Expected);
  FProcessor.Execute(Code);
  Assert.AreEqualIntArrays(ExpectedCode, Code);
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
  Outputs: TIntegerArray;
begin
  Code := TInput.IntCommaSeparated(Input);
  FProcessor.Execute(Code);
  Outputs := FIO.GetOutputs;
  Assert.AreEqual(1, Length(Outputs), 'Number of output values');
  Assert.AreEqual(Expected, Outputs[0].ToString, 'First/only output value');
end;

procedure TIntCodeProcessorTests.TestSuspension(const Input, First,
  Final: String);
var
  Prog: TIntCodeProgram;
begin
  Prog := TIntCodeProgram.Create(TInput.IntCommaSeparated(Input));

  FProcessor.Run(Prog);
  Assert.AreEqual(Prog.ProgramState, psSuspended);
  Assert.AreEqualIntArrays(TInput.IntCommaSeparated(First), Prog.MemDump, 'First');
  repeat
    FProcessor.Run(Prog);
  until Prog.ProgramState = psHalted;
  Assert.AreEqualIntArrays(TInput.IntCommaSeparated(Final), Prog.MemDump, 'Final');
end;

initialization
  TDUnitX.RegisterTestFixture(TIntCodeProcessorTests);
end.
