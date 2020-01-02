unit Permutation.Tests;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TPermutationTests = class(TObject)
  public
    [Test]
    procedure Permutations;
  end;

implementation

uses
  SysUtils,
  AoC.Types,
  Permutation;

{ TPermutationTests }

procedure TPermutationTests.Permutations;
  procedure Check(Input: TIntegerArray; Expected: TIntegerArrayArray);
  var
    Actual: TIntegerArrayArray;
    e: Integer;
    p: Integer;
  begin
    Actual := TPermutation.GetPermutations(Input);
    Assert.AreEqual(Length(Expected), Length(Actual), 'Number of permutations');
    for p := 0 to High(Expected) do
    begin
      Assert.AreEqual(Length(Expected[p]), Length(Actual[p]), Format('Number of elements in %d ', [p]));
      for e := 0 to High(Expected[p]) do
        Assert.AreEqual(Expected[p][e], Actual[p][e], Format('Element [%d][%d]', [p, e]));
    end;
  end;
begin
  Check([1], [[1]]);
  Check([1,2], [[1,2],[2,1]]);
end;

initialization
  TDUnitX.RegisterTestFixture(TPermutationTests);
end.
