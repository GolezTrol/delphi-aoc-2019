unit Solver.Resolver;

interface

uses
  Spring.Container,
  Spring.Collections,
  Solver.Intf;

type
  TSolverResolver = class(TInterfacedObject, ISolverResolver)
  protected
    FContainer: TContainer;
    function GetSolver(Puzzle: String): ISolver;
  public
    constructor Create(Container: TContainer);
  end;

implementation

constructor TSolverResolver.Create(Container: TContainer);
begin
  FContainer := Container;
  inherited Create;
end;

function TSolverResolver.GetSolver(Puzzle: String): ISolver;
begin
  Result := FContainer.Resolve<ISolver>(Puzzle);
end;

end.
