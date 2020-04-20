unit uCarDetector;

interface

uses uHttpDownloader, uDriversTypes, Classes, uJSONParser, uEventTypes;

type
  TCarDetector = class
  private
    FHttpDownloader: THttpDownloader;
    FOnLogMessage: TLogMessageMethod;
    FDriversParser: TDriversParser;

    procedure DoLogMessage(const AMessage: string; AEventType: TEventType);
  public

    procedure LoadCars(const AZonePosition: TZonePosition; const ATariff: string);

    constructor Create(const ALogMessageMethod: TLogMessageMethod; ACarDetectMethod: TCarDetectMethod); reintroduce;
    procedure BeforeDestruction; override;
  end;

const
  constTaxiUrl = 'https://tc.mobile.yandex.net/3.0/nearestdrivers?block_id=default';

implementation

uses uMKUtils;

procedure TCarDetector.BeforeDestruction;
begin
  FreeAndNilEx(FHttpDownloader);
  FreeAndNilEx(FDriversParser);
  inherited;
end;

constructor TCarDetector.Create(const ALogMessageMethod: TLogMessageMethod; ACarDetectMethod: TCarDetectMethod);
begin
  FHttpDownloader := THttpDownloader.Create;

  FDriversParser := TDriversParser.Create;
  FDriversParser.OnLogMessage := ALogMessageMethod;

  FOnLogMessage := ALogMessageMethod;

  FDriversParser.OnCarDetected := ACarDetectMethod;
end;

procedure TCarDetector.DoLogMessage(const AMessage: string; AEventType: TEventType);
begin
  if Assigned(FOnLogMessage) then
  begin
    FOnLogMessage(AMessage, AEventType);
  end;
end;

procedure TCarDetector.LoadCars(const AZonePosition: TZonePosition; const ATariff: string);
var
  lPostList: TStringStream;
  lResponseContent: string;
  lErrorStr: string;
begin
  lResponseContent := '';
  lPostList := TStringStream.Create(TJSONContent.GetJSONContent(AZonePosition, ATariff));
  try
    if not FHttpDownloader.Post(constTaxiUrl, lPostList, lResponseContent, lErrorStr) then
    begin
      DoLogMessage(lErrorStr, etError);
    end
    else
    begin
      FDriversParser.Parse(lResponseContent);
    end;
  finally
    FreeAndNilEx(lPostList);
  end;
end;

end.
