unit uInterfaceObjects;

interface
uses uSpyTaxiTypes;
type
  ICar = interface
    function GetPositon: TCarPosition;
  end;

implementation

end.
