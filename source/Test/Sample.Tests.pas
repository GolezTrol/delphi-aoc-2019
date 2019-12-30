unit Sample.Tests;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TSampleTests = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Atribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

procedure TSampleTests.Setup;
begin
end;

procedure TSampleTests.TearDown;
begin
end;

procedure TSampleTests.Test1;
begin
  Assert.Pass();
end;

procedure TSampleTests.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
  Assert.Pass();
end;

initialization
  TDUnitX.RegisterTestFixture(TSampleTests);
end.
