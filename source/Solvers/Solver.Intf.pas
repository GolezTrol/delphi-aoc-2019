unit Solver.Intf;

interface

type
  TResultProc = reference to procedure(Puzzle: String; Solution: String);

  IPathSolver = interface
    ['{B71B72F7-BF11-4440-9BDC-CDDB4918ECF5}']
    procedure Solve(InputPath: String; Callback: TResultProc);
  end;

  ISolver = interface
    ['{D9BC8186-C180-4E2C-AF1B-2414B22A7FE7}']
    function Solve(Input: String): String;
  end;

  ISolverResolver = interface
    ['{B7168ED4-F3A8-40BF-ACD3-E362FCD32E51}']
    function GetSolver(Puzzle: String): ISolver;
  end;

implementation

end.
