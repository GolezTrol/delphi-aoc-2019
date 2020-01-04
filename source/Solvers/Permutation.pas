unit Permutation;

interface

uses
  AoC.Types;

type
  TPermutation = class
    class function GetPermutations(ASet: TIntegerArray): TIntegerArrayArray;
  end;

implementation

{ TPermutation }

class function TPermutation.GetPermutations(ASet: TIntegerArray): TIntegerArrayArray;
var
  Index: Integer;

  procedure Swap(var A, B: TAoCInt); inline;
  var
    C: Integer;
  begin
    C := A;
    A := B;
    B := C;
  end;

  procedure Generate(k: Integer; A: TIntegerArray);
  var
    i: Integer;
  begin
    // Heap's algorithm for determining permutations
    // https://en.wikipedia.org/wiki/Heap%27s_algorithm
    if k = 1 then
    begin
      Result[Index] := Copy(A, 0, Length(A));
      Inc(Index);
    end
    else
    begin
      // Generate permutations with kth unaltered
      // Initially k == length(A)
      Generate(k - 1, A);

      // Generate permutations for kth swapped with each k-1 initial
      for i := 0 to k-2 do
      begin
        // Swap choice dependent on parity of k (even or odd)
        if not Odd(k) then
          Swap(A[i], A[k-1]) // zero-indexed, the kth is at k-1
        else
          Swap(A[0], A[k-1]);
        Generate(k - 1, A)
      end;
    end;
  end;

var
  i, k, Count: Integer;
begin
  k := Length(ASet);
  // Number of permutations is the factorial of the length of the set
  Count := 1;
  for i := 2 to k do
    Count := Count * i;
  SetLength(Result, Count);

  Index := 0;

  Generate(k, ASet);
end;

end.
