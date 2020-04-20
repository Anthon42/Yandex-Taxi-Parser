unit uDriversTypes;

interface

uses System.SysUtils, uEventTypes;

type
  TLogMessageMethod = procedure(const AValue: string; AEventType: TEventType) of object;

  TMapObjectPosition = record
    Latitude: Double;
    Longitude: Double;
    function LatitudeToStr: string;
    function LongitudeToStr: string;
  end;

  TCarPosition = TMapObjectPosition;
  TZonePosition = TMapObjectPosition;

  TDriver = record
    Id: string;
    Position: TCarPosition;
    Color: string;
    TimeDetected: TDateTime;
    // Тариф(биснес, премиум и т. д.)
    Tariff: string;
  end;

  TCarDetectMethod = procedure(const ADriver: TDriver) of object;

  TJSONContent = record
    class function GetJSONContent(const AZonePosition: TZonePosition; const ATariff: string): string; static;
  end;

implementation

class function TJSONContent.GetJSONContent(const AZonePosition: TZonePosition; const ATariff: string): string;
begin
  Result := '{"simplify":true,"classes":["'+ATariff+'"],"id":"000000000000000000000000000000","point":[' +
    FloatToStr(AZonePosition.Longitude) + ',' + FloatToStr(AZonePosition.Latitude) +
    '],"supported":["code_dispatch"],"full_adjust_task":true,"current_drivers":[]}';
end;

{ TMapObjectPosition }

function TMapObjectPosition.LatitudeToStr: string;
begin
  Result := FloatToStr(Latitude);
end;

function TMapObjectPosition.LongitudeToStr: string;
begin
  Result := FloatToStr(Longitude);
end;

end.
