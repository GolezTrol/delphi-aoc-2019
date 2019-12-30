unit AoC.Mainform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Solver.Intf,
  Spring.Container.Common;

type
  TFrmAoC = class(TForm)
    mmoSolutions: TMemo;
    btnGoGoGo: TButton;
    edtPath: TEdit;
    procedure btnGoGoGoClick(Sender: TObject);
  private
    FSolver: IPathSolver;
  public
    [Inject]
    procedure Inject(Solver: IPathSolver);
  end;

implementation

{$R *.dfm}

procedure TFrmAoC.btnGoGoGoClick(Sender: TObject);
begin
  mmoSolutions.Clear;
  FSolver.Solve(edtPath.Text,
    procedure(Puzzle: String; Solution: String)
    begin
      mmoSolutions.Lines.Add(Puzzle + ': ' + Solution);
    end);
end;

procedure TFrmAoC.Inject(Solver: IPathSolver);
begin
  FSolver := Solver;
end;

end.
