unit Solver.PathSolver;

interface

uses
  Spring,
  Solver.Intf;
type
  TPathSolver = class(TInterfacedObject, IPathSolver)
  private
    FSolverResolver: ISolverResolver;
    procedure Solve(InputPath: String; Callback: TResultProc);
  public
    constructor Create(SolverResolver: ISolverResolver);
    procedure AfterConstruction; override;
  end;

implementation

uses
  System.IOUtils, System.Types, System.SysUtils, Spring.Container;

procedure TPathSolver.AfterConstruction;
begin
  Guard.CheckNotNull(FSolverResolver, 'SolverResolver');
  inherited;
end;

constructor TPathSolver.Create(SolverResolver: ISolverResolver);
begin
  FSolverResolver := SolverResolver;
  inherited Create;
end;

procedure TPathSolver.Solve(InputPath: String; Callback: TResultProc);
var
  Files: TStringDynArray;
  FileName: String;
  Puzzle: String;
  Input: String;
  Solution: String;
  Solver: ISolver;
  PuzzleNr: Integer;
  Day: String;
begin
  InputPath := TPath.GetFullPath(InputPath);
  Files := TDirectory.GetFiles(InputPath, '*.txt');
  for FileName in Files do
  begin
    Day := TPath.GetFileNameWithoutExtension(FileName);
    for PuzzleNr := 1 to 2 do
      try
        Puzzle := Day + '.' + PuzzleNr.ToString;
        Solver := FSolverResolver.GetSolver(Puzzle);

        Input := TFile.ReadAllText(FileName);
        // A string result is compiled as a var parameter. To prevent stubs from
        // implicitly returning the previous result, initialize the variable before
        // each call.
        Solution := 'No result';
        Solution := Solver.Solve(Input);
        CallBack(Puzzle, Solution)
      except
        on E: EResolveException do
          CallBack(Puzzle, 'No solver found')
      end;
  end;
end;

end.
