program AoC2019Tests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitX.TestFramework,
  TestInsight.DUnitX,
  Module.Fuel.Tests in 'Module.Fuel.Tests.pas',
  Puzzle.Y2019.Tests in 'Puzzle.Y2019.Tests.pas',
  Aoc.TestCase.Attribute in 'Aoc.TestCase.Attribute.pas',
  IntCode.Processor.Tests in 'IntCode.Processor.Tests.pas',
  Wiring.Tests in 'Wiring.Tests.pas',
  Password.Tests in 'Password.Tests.pas';

{$R *.RES}

begin
  RunRegisteredTests;
end.

