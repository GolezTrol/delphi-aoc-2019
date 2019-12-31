program AoC2019_Solvers;

uses
  AoC.Mainform in 'AoC.Mainform.pas' {FrmAoC},
  Spring,
  Spring.Container,
  Bootstrapper in 'Bootstrapper.pas',
  Solver.PathSolver in 'Solver.PathSolver.pas',
  Solver.Resolver in 'Solver.Resolver.pas',
  Solver.Registration in 'Solver.Registration.pas',
  Solver.Y2019 in 'Solver.Y2019.pas',
  Module.Fuel in 'Module.Fuel.pas',
  InputUtils in 'InputUtils.pas',
  IntCode.Processor in 'IntCode.Processor.pas',
  AoC.Types in 'AoC.Types.pas';

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
