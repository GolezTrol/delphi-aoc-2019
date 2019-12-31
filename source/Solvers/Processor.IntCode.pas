unit Processor.IntCode;

interface

uses
  AoC.Types;

type
  TIntCodeCPU = class
    function Execute(Code: TIntegerArray): TIntegerArray; overload;
    function Execute(Code: TIntegerArray): Integer; overload;
  end;

implementation

end.
