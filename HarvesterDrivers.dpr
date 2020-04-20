program HarvesterDrivers;

uses
  FastMM4,
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uCarDetector in 'uCarDetector.pas',
  uJSONParser in 'uJSONParser.pas',
  uDriversTypes in 'uDriversTypes.pas',
  uEventService in '..\RoboVizor\Events\uEventService.pas',
  uEventTypes in '..\common\Utils\uEventTypes.pas',
  uDataConstantStorage in '..\common\DataBase\uDataConstantStorage.pas',
  uMKCommonData in '..\common\DataBase\uMKCommonData.pas',
  uMKData_Items in '..\common\DataBase\uMKData_Items.pas',
  uMKUtils in '..\common\Utils\uMKUtils.pas',
  uCommandSymbol in '..\common\Utils\uCommandSymbol.pas',
  uErrorMessageFormatter in '..\common\Utils\uErrorMessageFormatter.pas',
  uMKModifyCommonData in '..\common\DataBase\uMKModifyCommonData.pas',
  uDataBaseConsts in '..\common\DataBase\uDataBaseConsts.pas',
  uDriversUploader in 'uDriversUploader.pas',
  uCoordinateMaskGenerator in 'uCoordinateMaskGenerator.pas',
  uDriversConst in 'uDriversConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
