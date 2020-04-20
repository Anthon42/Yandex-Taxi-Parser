unit uMain;

interface

uses
  // ѕользовательские модули
  uCarDetector, uEventService, uDriversUploader, uCoordinateMaskGenerator
  //
    , Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    btnStartCapture: TButton;
    btnStopCapture: TButton;
    procedure btnStartCaptureClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStopCaptureClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FCommonEventService: TCommonEventService;

    FCarDetector: TCarDetector;

    FDriversUploader: TDriversUploader;

    FCoordinateMaskGenerator: TCoordinateMaskGenerator;

    FLoadCars: Boolean;
  public
    { Public declarations }

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses uDriversConst, uDriversTypes, uMKUtils;

procedure TfrmMain.btnStartCaptureClick(Sender: TObject);
var
  lZonePosition: TZonePosition;
begin
  btnStopCapture.Enabled := True;
  btnStartCapture.Enabled := False;
  FLoadCars := True;

  while FLoadCars do
  begin
    Application.ProcessMessages;

    lZonePosition := FCoordinateMaskGenerator.NextPosition;
    // дл€ Primier
    FCarDetector.LoadCars(lZonePosition, constPrimierClass);
    // дл€ Elete
    FCarDetector.LoadCars(lZonePosition, constEleteClass);
  end;
end;

procedure TfrmMain.btnStopCaptureClick(Sender: TObject);
begin
  btnStopCapture.Enabled := False;
  btnStartCapture.Enabled := True;
  FLoadCars := False;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNilEx(FCommonEventService);
  FreeAndNilEx(FCarDetector);
  FreeAndNilEx(FDriversUploader);
  FreeAndNilEx(FCoordinateMaskGenerator);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FCommonEventService := TCommonEventService.Create(True, nil);
  FCommonEventService.Start;

  FDriversUploader := TDriversUploader.Create
    (FCommonEventService.LogMessageService);
  FCarDetector := TCarDetector.Create(FCommonEventService.LogMessageService,
    FDriversUploader.UploadDriver);

  FCoordinateMaskGenerator := TCoordinateMaskGenerator.Create
    (constTopLeftPosition, constBottomRightPosition, constMaskSize);
  // ћен€ем мантису дл€ конвертера типов, т.к с таким сепаратором работает €ндекс такси
  FormatSETTINGS.DecimalSeparator := '.';
end;

end.
