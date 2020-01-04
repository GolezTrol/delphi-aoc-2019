unit Solver.Registration;

interface

uses
  Spring.Container,
  Solver.Intf;

procedure Register(Container: TContainer);

implementation

uses
  System.Rtti,
  SysUtils,
  Classes,
  Solver.Y2019;

procedure Register(Container: TContainer);
begin
  Container.RegisterType<ISolver, TSolver2019_1_1>('2019.1.1');
  Container.RegisterType<ISolver, TSolver2019_1_2>('2019.1.2');
  Container.RegisterType<ISolver, TSolver2019_2_1>('2019.2.1');
  Container.RegisterType<ISolver, TSolver2019_2_2>('2019.2.2');
  Container.RegisterType<ISolver, TSolver2019_3_1>('2019.3.1');
  Container.RegisterType<ISolver, TSolver2019_3_2>('2019.3.2');
  Container.RegisterType<ISolver, TSolver2019_4_1>('2019.4.1');
  Container.RegisterType<ISolver, TSolver2019_4_2>('2019.4.2');
  Container.RegisterType<ISolver, TSolver2019_5_1>('2019.5.1');
  Container.RegisterType<ISolver, TSolver2019_5_2>('2019.5.2');
  Container.RegisterType<ISolver, TSolver2019_6_1>('2019.6.1');
  Container.RegisterType<ISolver, TSolver2019_6_2>('2019.6.2');
  Container.RegisterType<ISolver, TSolver2019_7_1>('2019.7.1');
  Container.RegisterType<ISolver, TSolver2019_7_2>('2019.7.2');
  Container.RegisterType<ISolver, TSolver2019_8_1>('2019.8.1');
  Container.RegisterType<ISolver, TSolver2019_8_2>('2019.8.2');
  Container.RegisterType<ISolver, TSolver2019_9_1>('2019.9.1');
  Container.RegisterType<ISolver, TSolver2019_9_2>('2019.9.2');
end;

end.
