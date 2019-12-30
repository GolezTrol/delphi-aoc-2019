unit Puzzle.Y2019.Tests;

interface

uses
  Bootstrapper,
  Solver.Intf,
  DUnitX.TestFramework,
  SysUtils;

type
  [TestFixture]
  TPuzzleTests2019 = class(TObject)
  private
    FBootstrapper: TBootstrapper;
    FResolver: ISolverResolver;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    // For a mass of _12_, divide by 3 and round down to get 4, then subtract 2 to get _2_.
    [TestCase('A', '12, 2')]
    [TestCase('B', '14, 2')]
    [TestCase('C', '1969, 654')]
    [TestCase('D', '100756, 33583')]
    procedure Test_2019_1_1_Fuel(const Mass: Integer; const Fuel: Integer);
    [Test]
    procedure Test_2019_1_1_Sum;

    [Test]
    // A module of mass 14 requires 2 fuel. This fuel requires no further fuel (2 divided by 3 and rounded down is 0, which would call for a negative fuel), so the total fuel required is still just 2.
    // At first, a module of mass 1969 requires 654 fuel. Then, this fuel requires 216 more fuel (654 / 3 - 2). 216 then requires 70 more fuel, which requires 21 fuel, which requires 5 fuel, which requires no further fuel. So, the total fuel required for a module of mass 1969 is 654 + 216 + 70 + 21 + 5 = 966.
    // The fuel required by a module of mass 100756 and its fuel is: 33583 + 11192 + 3728 + 1240 + 411 + 135 + 43 + 12 + 2 = 50346.
    [TestCase('A', '14, 2')]
    [TestCase('C', '1969, 966')]
    [TestCase('D', '100756, 50346')]
    procedure Test_2019_1_2_Fuel(const Mass: Integer; const Fuel: Integer);
    [Test]
    procedure Test_2019_1_2_Sum;

  end;

implementation

procedure TPuzzleTests2019.Setup;
begin
  FBootstrapper := TBootstrapper.Create;
  FBootstrapper.Initialize;
  FResolver := FBootstrapper.Container.Resolve<ISolverResolver>;
end;

procedure TPuzzleTests2019.TearDown;
begin
  FBootstrapper.Free;
end;

procedure TPuzzleTests2019.Test_2019_1_1_Fuel(const Mass, Fuel: Integer);
begin
  Assert.AreEqual(
    Fuel.ToString,
    FResolver.GetSolver('2019.1.1').Solve(Mass.ToString));
end;

procedure TPuzzleTests2019.Test_2019_1_1_Sum;
begin
  // Test if the puzzle handles input well, (one int per line)
  Assert.AreEqual('4', FResolver.GetSolver('2019.1.1').Solve('12'#13'14'));
end;

procedure TPuzzleTests2019.Test_2019_1_2_Fuel(const Mass, Fuel: Integer);
begin
  Assert.AreEqual(
    Fuel.ToString,
    FResolver.GetSolver('2019.1.2').Solve(Mass.ToString));
end;

procedure TPuzzleTests2019.Test_2019_1_2_Sum;
begin
  // Test if the puzzle handles input well, (one int per line)
  Assert.AreEqual('4', FResolver.GetSolver('2019.1.2').Solve('12'#13'14'));
end;

initialization
  TDUnitX.RegisterTestFixture(TPuzzleTests2019);
end.
