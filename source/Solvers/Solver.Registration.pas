unit Solver.Registration;

interface

uses
  Spring.Container,
  Solver.Intf;

procedure Register(Container: TContainer);

implementation

uses
  Solver.Y2019;

procedure Register(Container: TContainer);
begin
  Container.RegisterType<ISolver, TSolver2019_1_1>('2019.1.1');
  Container.RegisterType<ISolver, TSolver2019_1_2>('2019.1.2');
  Container.RegisterType<ISolver, TSolver2019_2_1>('2019.2.1');
  Container.RegisterType<ISolver, TSolver2019_2_2>('2019.2.2');
  Container.RegisterType<ISolver, TSolver2019_3_1>('2019.3.1');
end;

end.
