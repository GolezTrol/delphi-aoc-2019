program AoC2019_Solvers;

uses
  AoC.Mainform in 'AoC.Mainform.pas' {FrmAoC},
  Spring,
  Spring.Container,
  Bootstrapper in 'Bootstrapper.pas';

{$R *.res}

begin
  with TBootstrapper.Create do
  try
    Initialize;
    Run;
  finally
    Free;
  end;
end.
