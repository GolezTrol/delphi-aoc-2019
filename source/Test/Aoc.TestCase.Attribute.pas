unit Aoc.TestCase.Attribute;

interface

uses
  DUnitX.TestFramework;

type
  // Custom test case attribute, to easily declare test cases for puzzles, with a
  // puzzle, an input, and an output
  // https://stackoverflow.com/questions/35009927/can-i-pass-a-set-to-a-test-case-in-dunitx
  AoCTestCaseAttribute = class(CustomTestCaseSourceAttribute)
  private
    FCaseInfo: TestCaseInfoArray;
  protected
    function GetCaseInfoArray: TestCaseInfoArray; override;
  public
    constructor Create(const Puzzle: string; const Input: string; const ExpectedResult: String; const Description: String = '');
  end;

implementation

uses
  System.Rtti;

{ AoCTestCaseAttribute }

constructor AoCTestCaseAttribute.Create(const Puzzle, Input, ExpectedResult: String;
  const Description: String = '');
begin
  inherited Create;
  SetLength(FCaseInfo, 1);
  FCaseInfo[0].Name := Puzzle;
  if Description <> '' then
    FCaseInfo[0].Name := FCaseInfo[0].Name + ' - ' + Description;
  FCaseInfo[0].Name := FCaseInfo[0].Name + ' ' + Input + '->' + ExpectedResult;
  SetLength(FCaseInfo[0].Values, 3);
  FCaseInfo[0].Values[0] := TValue.From<string>(Puzzle);
  FCaseInfo[0].Values[1] := TValue.From<string>(Input);
  FCaseInfo[0].Values[2] := TValue.From<string>(ExpectedResult);
end;

function AoCTestCaseAttribute.GetCaseInfoArray: TestCaseInfoArray;
begin
  Result := FCaseInfo;
end;

end.
