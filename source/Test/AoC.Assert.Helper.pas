unit AoC.Assert.Helper;

interface

uses
  DUnitX.TestFramework,
  AoC.Types;

type
  Assert = class(DUnitX.TestFramework.Assert)
    class procedure AreEqualIntArrays(Expected, Actual: TIntegerArray; Description: String = '');
  end;

implementation

uses
  SysUtils;

{ Assert }

class procedure Assert.AreEqualIntArrays(Expected, Actual: TIntegerArray; Description: String = '');
var
  i: Integer;
begin
  Assert.AreEqual(Length(Expected), Length(Actual), Description + ', length');
  if Length(Expected) = Length(Actual) then
    for i := Low(Actual) to High(Actual) do
      Assert.AreEqual(Integer(Expected[i]), Actual[i], Description + ', item ' + i.ToString);
end;

end.
