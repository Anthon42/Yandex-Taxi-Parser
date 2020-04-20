unit uCoordinateMaskGenerator;

interface

uses uDriversTypes, System.Generics.Collections;

type
  TCoordinateMaskGenerator = class(TObject)
  private
    FCurrentIndex: Integer;
    FListPosition: TList<TZonePosition>;

  public
    function NextPosition: TZonePosition;

    constructor Create(const ATopLeftPosition, ABottomRightPosition: TZonePosition; const ACountElement: Integer);
    procedure BeforeDestruction; override;
  end;

implementation

uses uMKUtils;

procedure TCoordinateMaskGenerator.BeforeDestruction;
begin
  FreeAndNilEx(FListPosition);
  inherited;
end;

constructor TCoordinateMaskGenerator.Create(const ATopLeftPosition, ABottomRightPosition: TZonePosition;
  const ACountElement: Integer);
var
  lLatitudeStep: Double;
  lLongitudeStep: Double;

  lKnotPosition: TZonePosition;
begin
  FCurrentIndex := 0;
  FListPosition := TList<TZonePosition>.Create;

  lLatitudeStep := (ABottomRightPosition.Latitude - ATopLeftPosition.Latitude) / ACountElement;
  lLongitudeStep := (ABottomRightPosition.Longitude - ATopLeftPosition.Longitude) / ACountElement;
  // Создаем список координат
  lKnotPosition := ATopLeftPosition;
  while lKnotPosition.Longitude < ABottomRightPosition.Longitude do
  begin
    while lKnotPosition.Latitude > ABottomRightPosition.Latitude do
    begin
      FListPosition.Add(lKnotPosition);
      lKnotPosition.Latitude := lKnotPosition.Latitude + lLatitudeStep;
    end;
    lKnotPosition.Latitude := ATopLeftPosition.Latitude;
    lKnotPosition.Longitude := lKnotPosition.Longitude + lLongitudeStep;
  end;
end;

function TCoordinateMaskGenerator.NextPosition: TZonePosition;
begin
  if FListPosition.Count = 0 then
  begin
    Result.Latitude := 0;
    Result.Longitude := 0;
    Exit;
  end;

  Result := FListPosition.Items[FCurrentIndex];
  Inc(FCurrentIndex);

  if FCurrentIndex > FListPosition.Count - 1 then
    FCurrentIndex := 0;
end;

end.
