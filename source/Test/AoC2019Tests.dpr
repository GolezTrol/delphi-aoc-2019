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
  Sample.Tests in 'Sample.Tests.pas',
  Module.Fuel.Tests in 'Module.Fuel.Tests.pas',
  Puzzle.Y2019.Tests in 'Puzzle.Y2019.Tests.pas';

{$R *.RES}

begin
  RunRegisteredTests;
end.

