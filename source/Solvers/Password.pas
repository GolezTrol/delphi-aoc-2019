unit Password;

interface

type
  TPassword = class
    class function Validate(Password: String): Boolean;
  end;

implementation

{ TPassword }

class function TPassword.Validate(Password: String): Boolean;
var
  i: Integer;
  AdjacentFound: Boolean;
begin
  AdjacentFound := False;
  for i := 1 to Length(Password) - 1 do
  begin
    if Password[i] > Password[i+1] then Exit(False);
    if Password[i] = Password[i+1] then AdjacentFound := True;
  end;
  Exit(AdjacentFound);
end;

end.
