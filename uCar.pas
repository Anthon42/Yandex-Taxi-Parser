unit uCar;

interface

uses uSpyTaxiTypes;

type
  TCar = class
  private
    FCarPosition: TCarPosition;
    FId: string;
  public
    constructor Create(const ACarPosition: TCarPosition; const lId: string); reintroduce;
  end;

implementation

{ TCar }

constructor TCar.Create(const ACarPosition: TCarPosition; const lId: string);
begin
  FCarPosition := ACarPosition;
  FId := lId;
end;

end.
