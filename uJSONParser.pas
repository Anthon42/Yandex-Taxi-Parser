unit uJSONParser;

interface

uses System.JSON, System.SysUtils, uDriversTypes, System.Generics.Collections, uEventTypes;

type
  TDriversParser = class
  private
    FOnCarDetect: TCarDetectMethod;
    FOnLogMessage: TLogMessageMethod;
    procedure DoCarDetectEvent(const ADriver: TDriver);
    procedure DoLogMessage(const AMessage: string; AEventType: TEventType);
  public
    property OnCarDetected: TCarDetectMethod read FOnCarDetect write FOnCarDetect;
    property OnLogMessage: TLogMessageMethod read FOnLogMessage write FOnLogMessage;

    procedure Parse(AValue: string);
  end;

implementation

uses uErrorMessageFormatter, uMKUtils;

procedure TDriversParser.DoCarDetectEvent(const ADriver: TDriver);
begin
  if Assigned(FOnCarDetect) then
  begin
    FOnCarDetect(ADriver);
  end;
end;

procedure TDriversParser.DoLogMessage(const AMessage: string; AEventType: TEventType);
begin
  if Assigned(FOnLogMessage) then
  begin
    FOnLogMessage(AMessage, AEventType);
  end;
end;

procedure TDriversParser.Parse(AValue: string);
var
  lJSONObject: TJSONObject;
  lJSONPositionObject: TJSONObject;
  lJSONCoordinatesObject: TJSONObject;
  lDriversJSONArray: TJSONArray;
  lPositionJSONArray: TJSONArray;
  lIndex: Integer;
  lDriver: TDriver;

  lErrorStr: string;
begin
  // Парсим
  try
    try
      lJSONObject := TJSONObject.Create;
      lJSONObject.Parse(TEncoding.UTF8.GetBytes(AValue), 0);
      // Создаем массив водителей
      lDriversJSONArray := lJSONObject.Values['drivers'].AsType<TJSONArray>;
      // Перебираем массив водителей
      for lIndex := 0 to lDriversJSONArray.Count - 1 do
      begin
        lJSONPositionObject := lDriversJSONArray.Items[lIndex].AsType<TJSONObject>;

        lDriver.Id := lJSONPositionObject.Values['id'].ToString;

        lDriver.Tariff := lJSONPositionObject.Values['display_tariff'].ToString;

        lPositionJSONArray := lJSONPositionObject.Values['positions'].AsType<TJSONArray>;

        if lPositionJSONArray.Count > 0 then
        begin
          lJSONCoordinatesObject := lPositionJSONArray.Items[0].AsType<TJSONObject>;

          lDriver.Position.Longitude := StrToFloat(lJSONCoordinatesObject.Values['lon'].AsType<string>);

          lDriver.Position.Latitude := StrToFloat(lJSONCoordinatesObject.Values['lat'].AsType<string>);

          lDriver.TimeDetected := Now;

          DoCarDetectEvent(lDriver);
        end;
      end;
    except
      on E: Exception do
      begin
        lErrorStr := TErrorMessageFormatter.ErrorRunMethodMessage(Self, 'Parse', E);
        DoLogMessage(lErrorStr, etError);
      end;
    end;
  finally
    FreeAndNilEx(lJSONObject);
  end;
end;

end.
