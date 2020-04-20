unit uDriversUploader;

interface

uses uDriversTypes, uEventTypes, uDataConstantStorage, FIBDatabase, pFIBQuery, pFIBProps, System.SysUtils;

type
  TDriversUploader = class(TObject)
  private
    FLogMessageMethod: TLogMessageMethod;

    FDataConstantStorage: TDataConstantStorage;

    trWrite: TFIBTransaction;
    qrWrite: TpFIBQuery;

    procedure DoLogMessage(const AValue: string; AEventType: TEventType);
  public
    procedure UploadDriver(const ADriver: TDriver);

    constructor Create(const ALogMessageMethod: TLogMessageMethod);
    procedure BeforeDestruction; override;
  end;

  TDummyDataConstantStorage = class(TDataConstantStorage)
  public
    property Database;
  end;

implementation

uses uMKUtils, uErrorMessageFormatter;

const
  constDriverNameFieldName = 'driver_name';
  constTariffFieldName = 'tariff';
  constDetectionTimeFieldName = 'detection_time';
  constLatitudeFieldName = 'latitude';
  constLongitudeFieldName = 'longitude';

  constDBConnectionParams: TDBConnectionParams = (DatabaseName: 'localhost:spytaxi'; UserName: 'SYSDBA'; Password: '101';
    Role: '');
  constSQLWriteDriver = 'insert into drivers_position (' + constDriverNameFieldName + ', ' + constTariffFieldName + ', ' +
    constDetectionTimeFieldName + ', ' + constLatitudeFieldName + ', ' + constLongitudeFieldName + ') values (:' +
    constDriverNameFieldName + ', :' + constTariffFieldName + ', :' + constDetectionTimeFieldName + ', :' + constLatitudeFieldName
    + ', :' + constLongitudeFieldName + ')';

procedure TDriversUploader.BeforeDestruction;
begin
  FreeAndNilEx(qrWrite);
  FreeAndNilEx(trWrite);
  FreeAndNilEx(FDataConstantStorage);
  inherited;
end;

constructor TDriversUploader.Create(const ALogMessageMethod: TLogMessageMethod);
var
  lErrorStr: string;
begin
  if not TDataConstantStorage.CreateStorage(constDBConnectionParams, nil, FDataConstantStorage, lErrorStr) then
  begin
    raise Exception.Create(lErrorStr);
  end;

  if not FDataConstantStorage.ConnectToDB(lErrorStr) then
  begin
    raise Exception.Create(lErrorStr);
  end;

  trWrite := TFIBTransaction.Create(nil);
  trWrite.DefaultDatabase := TDummyDataConstantStorage(FDataConstantStorage).Database;

  qrWrite := TpFIBQuery.Create(nil);
  qrWrite.Database := TDummyDataConstantStorage(FDataConstantStorage).Database;
  qrWrite.Transaction := trWrite;
  qrWrite.GoToFirstRecordOnExecute := True;
  qrWrite.Options := [qoStartTransaction];
  qrWrite.Close;
  qrWrite.SQL.Clear;

  FLogMessageMethod := ALogMessageMethod;
end;

procedure TDriversUploader.DoLogMessage(const AValue: string; AEventType: TEventType);
begin
  if Assigned(FLogMessageMethod) then
  begin
    FLogMessageMethod(AValue, AEventType);
  end;
end;

procedure TDriversUploader.UploadDriver(const ADriver: TDriver);
var
  lErrorStr: string;
  lMessage: string;
begin
  try
    try
      qrWrite.Close;
      qrWrite.SQL.Clear;
      qrWrite.SQL.Add(constSQLWriteDriver);

      qrWrite.ParamByName(constDriverNameFieldName).AsString := ADriver.Id;
      qrWrite.ParamByName(constDetectionTimeFieldName).AsTime := ADriver.TimeDetected;
      qrWrite.ParamByName(constLatitudeFieldName).AsDouble := ADriver.Position.Latitude;
      qrWrite.ParamByName(constLongitudeFieldName).AsDouble := ADriver.Position.Longitude;
      qrWrite.ParamByName(constTariffFieldName).AsString := ADriver.Tariff;

      qrWrite.ExecQuery;

      if qrWrite.Transaction.InTransaction then
      begin
        qrWrite.Transaction.Commit;

        lMessage := Self.ClassName + '.UploadDriver: ' + 'Добавлен водитель в БД Id: ' + ADriver.Id;
        DoLogMessage(lMessage, etInformation);
      end
      else
      begin
        qrWrite.Transaction.Rollback;
      end;

    except
      on E: Exception do
      begin
        lErrorStr := TErrorMessageFormatter.ErrorRunMethodMessage(Self, 'UploadDriver', E);
        DoLogMessage(lErrorStr, etError);
      end;
    end;
  finally
    qrWrite.Close;
  end;
end;

end.
