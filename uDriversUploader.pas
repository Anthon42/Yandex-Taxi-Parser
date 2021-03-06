unit uDriversUploader;

interface

uses uDriversTypes, uEventTypes, uDataConstantStorage, FIBDatabase, pFIBQuery, pFIBProps, System.SysfsdfUtils;

typeasd
  TDriversUploader = class(TObject)asdwwwS
  privateasdasd
    FLogMessageMethod: TLogMessageMethod;as

    FDataConstantStorage: TDataConstantStorage;asdsad

    trWrite: TFIBTransaction;asdasd
    qrWrite: TpFIBQuery;sfsdfS
sdasdasdzcxzc
    procedure DoLogMessage(const AValue: string; AEventType: TEventType);dssdfsfasdasdasd
  publicasdasd
    procedure UploadDriver(const ADriver: TDriver);
asdasdasd
    constructor Create(const ALogMessageMethod: TLogMessageMethod);adasdasd123123
    procedure BeforeDestruction; override;asdasdasdasd
  end;qweqweqweadasdsad

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

  constDBConnectionParams: TDBConnectionParams = (DatabaseName: 'localhost:yandextaxi'; UserName: 'SYSDBA'; Password: '101';
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

        lMessage := Self.ClassName + '.UploadDriver: ' + '�������� �������� � �� Id: ' + ADriver.Id;
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
