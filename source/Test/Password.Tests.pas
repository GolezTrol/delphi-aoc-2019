unit Password.Tests;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TPasswordTests = class(TObject)
  public
    [Test]
    procedure Validate1;
    [Test]
    procedure Validate2;
  end;

implementation

uses
  Password;

{ TPasswordTests }

procedure TPasswordTests.Validate1;
begin
  Assert.IsTrue(TPassword.Validate1('111111'), '111111->double');
  Assert.IsFalse(TPassword.Validate1('223450'), '223450->decreasing');
  Assert.IsFalse(TPassword.Validate1('123789'), '123789->no double');
end;

procedure TPasswordTests.Validate2;
begin
  Assert.IsTrue(TPassword.Validate2('112233'), '112233->double');
  Assert.IsFalse(TPassword.Validate2('123444'), '123444->triple');
  Assert.IsTrue(TPassword.Validate2('111122'), '223450->one double');
end;

initialization
  TDUnitX.RegisterTestFixture(TPasswordTests);
end.
