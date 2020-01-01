unit Password.Tests;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TPasswordTests = class(TObject)
  public
    [Test]
    procedure Validate;
  end;

implementation

uses
  Password;

{ TPasswordTests }

procedure TPasswordTests.Validate;
begin
  Assert.IsTrue(TPassword.Validate('111111'), '111111->double');
  Assert.IsFalse(TPassword.Validate('223450'), '223450->decreasing');
  Assert.IsFalse(TPassword.Validate('123789'), '123789->no double');
end;

initialization
  TDUnitX.RegisterTestFixture(TPasswordTests);
end.
