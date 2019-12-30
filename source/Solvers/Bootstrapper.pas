unit Bootstrapper;

interface

uses
  Spring,
  Spring.Container,
  Spring.Container.Common;

type
  TBootstrapper = class
  private
    FContainerIntf: IContainer;
    FContainer: TContainer;
  public
    constructor Create;
    procedure Initialize;
    procedure Run;
  end;

implementation

uses
  Forms,
  AoC.Mainform;

constructor TBootstrapper.Create;
begin
  FContainer := TContainer.Create;
  FContainerIntf := FContainer;
end;

procedure TBootstrapper.Initialize;
begin
  FContainer.RegisterType<TFrmAoC>.DelegateTo(
    function: TFrmAoC
    begin
      Application.CreateForm(TFrmAoC, Result);
    end);

  FContainer.Build;
end;

procedure TBootstrapper.Run;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  FContainer.Resolve<TFrmAoC>;
  Application.Run;
end;

end.
