unit ArcadeGame.Tests;

interface

uses
  DUnitX.TestFramework,
  ArcadeGame,
  InputUtils,
  IntCode.Types,
  IntCode.Processor,
  AoC.Types;

type
  [TestFixture]
  TArcadeGameTests = class(TObject)
  public
    [TestCase('Demo', '1,2,3,6,5,4', '')]
    procedure TestPaddle(Input: String);
  end;

implementation


{ TArcadeGameTests }

procedure TArcadeGameTests.TestPaddle(Input: String);
begin
  Assert.Pass('dummy');
end;

initialization
  TDUnitX.RegisterTestFixture(TArcadeGameTests);
end.
