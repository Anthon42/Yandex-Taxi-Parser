unit uMain;

interface

uses
  // Пользовательские модули
  uCarDetector, uEventService, uDriversUploader, uCoordinateMaskGenerator
  //
    , Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    btnStartCapture: TButton;
    btnStopCapture: TButton;
    rbgTariff: TRadioGroup;
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

uses uDriversConst,uMKUtils;

procedure TfrmMain.btnStartCaptureClick(Sender: TObject);
var
  lTariff: string;
begin
  btnStopCapture.Enabled := True;
  btnStartCapture.Enabled := False;
  // Выбор тарифа такси
  if rbgTariff.ItemIndex = 0 then
    lTariff := constPrimierClass
  else
    lTariff := constEleteClass;

  FLoadCars := True;
  while FLoadCars do
  begin
    Application.ProcessMessages;
    FCarDetector.LoadCars(FCoordinateMaskGenerator.NextPosition, lTariff);
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

  FDriversUploader := TDriversUploader.Create(FCommonEventService.LogMessageService);
  FCarDetector := TCarDetector.Create(FCommonEventService.LogMessageService, FDriversUploader.UploadDriver);

  FCoordinateMaskGenerator := TCoordinateMaskGenerator.Create(constTopLeftPosition, constBottomRightPosition, constMaskSize);
  // Меняем мантису для конвертера типов, т.к с таким сепаратором работает яндекс такси
  FormatSETTINGS.DecimalSeparator := '.';
end;

end.
