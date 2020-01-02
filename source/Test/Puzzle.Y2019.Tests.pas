unit Puzzle.Y2019.Tests;

interface

uses
  Bootstrapper,
  Solver.Intf,
  DUnitX.TestFramework,
  AoC.TestCase.Attribute,
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
    // Day 1: The Tyranny of the Rocket Equation
    // Day 1, 1: Basic fuel calculation
    // For a mass of _12_, divide by 3 and round down to get 4, then subtract 2 to get _2_.
    [AoCTestCase('2019.1.1', '12', '2')]
    [AoCTestCase('2019.1.1', '14', '2')]
    [AoCTestCase('2019.1.1', '1969', '654')]
    [AoCTestCase('2019.1.1', '100756', '33583')]
    [AoCTestCase('2019.1.1', '12'#13'14', '4' {2+2})] // Checking input format handling

    // Day 1, 2: Fuel for fuel
    // A module of mass 14 requires 2 fuel. This fuel requires no further fuel (2 divided by 3 and rounded down is 0, which would call for a negative fuel), so the total fuel required is still just 2.
    // At first, a module of mass 1969 requires 654 fuel. Then, this fuel requires 216 more fuel (654 / 3 - 2). 216 then requires 70 more fuel, which requires 21 fuel, which requires 5 fuel, which requires no further fuel. So, the total fuel required for a module of mass 1969 is 654 + 216 + 70 + 21 + 5 = 966.
    // The fuel required by a module of mass 100756 and its fuel is: 33583 + 11192 + 3728 + 1240 + 411 + 135 + 43 + 12 + 2 = 50346.
    [AoCTestCase('2019.1.2', '14', '2')]
    [AoCTestCase('2019.1.2', '1969', '966')]
    [AoCTestCase('2019.1.2', '100756', '50346')]

    // Day 2: 1202 Program Alarm
    // Day 2, 1: Restore gravity assist
    // The solver should replace input values with [1]12,[2]2
    // The first test case is a program as it should be executed.
    // It adds up the values at positions 12 (5) and 2 (2), leading to a result of 7.
    // The second test case, is a program with other (invalid) ovalues in that spot, to prove
    // that the solver replaces the values correctly.
    [AoCTestCase('2019.2.1', '1,12,2,0,99,0,0,0,0,0,0,0,5', '7' {2 + 5})]
    [AoCTestCase('2019.2.1', '1,77,88,0,99,0,0,0,0,0,0,0,5', '7' {2 + 5})]

    // Day 3: Crossed Wires
    // Day 3, 1: Manhattan distance
    [AoCTestCase('2019.3.1', 'R8,U5,L5,D3'#13'U7,R6,D4,L4', '6' )]
    [AoCTestCase('2019.3.1', 'R75,D30,R83,U83,L12,D49,R71,U7,L72'#13'U62,R66,U55,R34,D71,R55,D58,R83', '159' )]
    [AoCTestCase('2019.3.1', 'R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51'#13'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7', '135' )]

    // Day 3, 2: Minimize signal delay
    [AoCTestCase('2019.3.2', 'R8,U5,L5,D3'#13'U7,R6,D4,L4', '30' )]
    [AoCTestCase('2019.3.2', 'R75,D30,R83,U83,L12,D49,R71,U7,L72'#13'U62,R66,U55,R34,D71,R55,D58,R83', '610' )]
    [AoCTestCase('2019.3.2', 'R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51'#13'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7', '410' )]

    // Day 4: Secure Container
    // Day 4, 1: Password range
    [AoCTestCase('2019.4.1', '111111-111111', '1' )]
    [AoCTestCase('2019.4.1', '111110-111112', '2' )]
    [AoCTestCase('2019.4.1', '555550-555552', '0' )]

    // Day 4, 2: Additional criteria
    [AoCTestCase('2019.4.2', '112233-112233', '1' )]
    [AoCTestCase('2019.4.2', '123444-123444', '0' )]
    [AoCTestCase('2019.4.2', '111120-111123', '1' )] // Finds only 111122

    // Day 5: Sunny with a Chance of Asteroids
    // Diagnose Airco
    [AoCTestCase('2019.5.1', '4,3,99,23456', '23456' )] // Outputs number at address 3
    [AoCTestCase('2019.5.1', '104,3,99,23456', '3' )] // Outputs immediate 3

    // Diagnose thermal radiator controller (ID = 5)
    // Program will take input. If input is <, = or > 8, it will output 999, 1000, 1001 respectively.
    // For the puzzle, the input is 5.
    [AoCTestCase('2019.5.2', '3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99', '999')]

    // Day 6: Universal Orbit Map
    // Day 6, 1: Checksum
    [AoCTestCase('2019.6.1', 'COM)B'#13'B)C'#13'C)D'#13'D)E'#13'E)F'#13'B)G'#13'G)H'#13'D)I'#13'E)J'#13'J)K'#13'K)L', '42')]
    // Day 6, 1: Distance from YOU to SAN
    [AoCTestCase('2019.6.2', 'COM)B'#13'B)C'#13'C)D'#13'D)E'#13'E)F'#13'B)G'#13'G)H'#13'D)I'#13'E)J'#13'J)K'#13'K)L'#13'K)YOU'#13'I)SAN', '4')]
    procedure Tests(const Puzzle, Input, ExpectedResult: String);
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

procedure TPuzzleTests2019.Tests(const Puzzle, Input, ExpectedResult: String);
begin
  Assert.AreEqual(ExpectedResult, FResolver.GetSolver(Puzzle).Solve(Input));
end;

initialization
  TDUnitX.RegisterTestFixture(TPuzzleTests2019);
end.
