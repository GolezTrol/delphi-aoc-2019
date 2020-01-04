unit IntCode.Types;

interface

uses
  AoC.Types,
  SysUtils;

type
  EIntCode = class(Exception);
  EInvalidOpCode = class(EIntCode);
  EIntCodeIO = class(EIntCode);

  IIO = interface
    ['{83FEF665-616E-4CD4-A9E8-CBBDA5392649}']
    function Read: TAoCInt;
    procedure Write(Value: TAoCInt);
  end;

implementation

end.
