unit Bootstrapper;

interface

uses
  Spring,
  Spring.Container,
  Spring.Container.Common;

type
  TBootstrapper = class
  private
    FContainer: TContainer;
  private
    procedure RegisterSolvers;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize;
    procedure Run;
    property Container: TContainer read FContainer;
  end;

implementation

uses
  Forms,
  AoC.Mainform,
  Solver.Intf,
  Solver.PathSolver,
  Solver.Resolver,
  Solver.Registration;

constructor TBootstrapper.Create;
begin
  FContainer := TContainer.Create;
end;

destructor TBootstrapper.Destroy;
begin
  FContainer.Free;
  inherited;
end;

procedure TBootstrapper.Initialize;
begin
  FContainer.RegisterType<TFrmAoC>.DelegateTo(
    function: TFrmAoC
    begin
      Application.CreateForm(TFrmAoC, Result);
    end);

  FContainer.RegisterType<IPathSolver, TPathSolver>;

  RegisterSolvers;

  FContainer.Build;
end;


procedure TBootstrapper.RegisterSolvers;
begin
  FContainer.RegisterType<ISolverResolver>.DelegateTo(
    function: ISolverResolver
    begin
      Result := TSolverResolver.Create(FContainer);
    end);

  Solver.Registration.Register(FContainer);
end;

procedure TBootstrapper.Run;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  FContainer.Resolve<TFrmAoC>;
  Application.Run;
end;

end.
