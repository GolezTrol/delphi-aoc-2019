unit IntCode.Processor.Tests;

interface

uses
  SysUtils,
  DUnitX.TestFramework,
  IntCode.Processor,
  InputUtils,
  AoC.Types;

type
  [TestFixture]
  TIntCodeProcessorTests = class(TObject)
  private
    FProcessor: TIntCodeProcessor;
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
    procedure TestExecute(const Input: String; const Expected: String);

    [TestCase('Multiple statements', '1,1,1,4,99,5,6,0,99|30', '|')]
    procedure TestExecuteScalar(const Input: String; const Expected: String);
  end;

implementation

procedure TIntCodeProcessorTests.Setup;
begin
  FProcessor := TIntCodeProcessor.Create;
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

initialization
  TDUnitX.RegisterTestFixture(TIntCodeProcessorTests);
end.
