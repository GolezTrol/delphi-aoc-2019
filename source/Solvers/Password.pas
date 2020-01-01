unit Password;

interface

type
  TPassword = class
    class function Validate1(Password: String): Boolean;
    class function Validate2(Password: String): Boolean;
    class function Validate(Password: String): Boolean;
  end;

implementation

{ TPassword }

class function TPassword.Validate(Password: String): Boolean;
begin
  Result := Validate2(Password);
end;

class function TPassword.Validate1(Password: String): Boolean;
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

class function TPassword.Validate2(Password: String): Boolean;
var
  i: Integer;
  AdjacentFound: Boolean;
begin
  AdjacentFound := False;
  for i := 1 to Length(Password) - 1 do
  begin
    if Password[i] > Password[i+1] then Exit(False);
    if (Password[i] = Password[i+1]) and
       // This[i+2] is safe, because there is always an #0 allocated after the string.
       (Password[i] <> Password[i+2]) and
       // Check back. Not pretty, but it works fast enough.
       ((i = 1) or (Password[i-1] <> Password[i])) then
      AdjacentFound := True;
  end;
  Exit(AdjacentFound);
end;

end.
