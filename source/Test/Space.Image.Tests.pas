unit Space.Image.Tests;

interface

uses
  DUnitX.TestFramework,
  Aoc.Assert.Helper;

type
  [TestFixture]
  TSpaceImageTests = class(TObject)
  public
    [Test]
    procedure TestInputDigit;
    [Test]
    [TestCase('', '123456789012,2,3,2,123456,789012')]
    procedure TestImageLoader(Data: String; Layers, Width, Height: Integer; FirstLayer, SecondLayer: String);
    [Test]
    // Find layer with least zeroes, multiple number of 1's and 2's.
    //             Data         W  H  D1 D2 Outcome
    [TestCase('', '123456789012,3, 2, 1, 2, 1')] // 1*1 = 1
    [TestCase('', '122216789012,3, 2, 1, 2, 6')] // 2*3 = 6
    procedure TestCheckProduct(AData: String; AWidth, AHeight, Digit1, Digit2, Outcome: Integer);

    // 2 is transparent
    [TestCase('', '122216789012,189016,3,2')]
    procedure TestFlatten(AData, ALayer: String; AWidth, AHeight: Integer);

    [TestCase('', '122210011012,'#13#10'░░░'#13#10'█░█,3,2')]
    procedure TestDraw(AData, AImage: String; AWidth, AHeight: Integer);
  end;

implementation

uses
  InputUtils,
  Space.Image,
  AoC.Types;

{ TSpaceImageTests }

procedure TSpaceImageTests.TestCheckProduct(AData: String; AWidth, AHeight, Digit1, Digit2,
  Outcome: Integer);
begin
  with TSpaceImage.Create do
  try
    LoadFrom(TInput.IntDigits(AData), AWidth, AHeight);
    Assert.AreEqual(Outcome, CheckProduct(0, [Digit1, Digit2]));
  finally
    Free;
  end;
end;

procedure TSpaceImageTests.TestDraw(AData, AImage: String; AWidth,
  AHeight: Integer);
begin
  with TSpaceImage.Create do
  try
    LoadFrom(TInput.IntDigits(AData), AWidth, AHeight);
    Assert.AreEqual(Draw, AImage);
  finally
    Free;
  end;
end;

procedure TSpaceImageTests.TestFlatten(AData, ALayer: String; AWidth, AHeight: Integer);
begin
  with TSpaceImage.Create do
  try
    LoadFrom(TInput.IntDigits(AData), AWidth, AHeight);
    Assert.AreEqualIntArrays(
      TInput.IntDigits(ALayer),
      Flatten);
  finally
    Free;
  end;
end;

procedure TSpaceImageTests.TestImageLoader(Data: String; Layers, Width, Height: Integer;
  FirstLayer, SecondLayer: String);
var
  Image: TSpaceImage;
begin
  Image := TSpaceImage.Create;
  try
    Image.LoadFrom(TInput.IntDigits(Data), Width, Height);
    Assert.AreEqual(Layers, Image.GetLayerCount, 'Layers');
    Assert.AreEqual(Width, Image.Width, 'Width');
    Assert.AreEqual(Height, Image.Height, 'Height' );
    Assert.AreEqualIntArrays(TInput.IntDigits(FirstLayer), Image.GetLayerData(0), 'First layer');
    Assert.AreEqualIntArrays(TInput.IntDigits(SecondLayer), Image.GetLayerData(1), 'Second layer');
  finally
    Image.Free;
  end;
end;

procedure TSpaceImageTests.TestInputDigit;
var
  Expected, Actual: TIntegerArray;
begin
  Expected := [2,3,4,5];
  Actual := TInput.IntDigits('2345');
  Assert.AreEqualIntArrays(Expected, Actual);
end;

initialization
  TDUnitX.RegisterTestFixture(TSpaceImageTests);
end.
