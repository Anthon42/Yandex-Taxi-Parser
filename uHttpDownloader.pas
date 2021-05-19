unit uHttpDownloader;

interface

uses IdHTTP, IdSSLOpenSSL, System.SysUtils, Vcl.Dialogs, System.Classes, IdCookieManager
  // User moduls
    , uExUtils;

type
  THTTPDownloader = class(TObject)
  strict private
    hpHtmlDownloader: TIdHTTP;
    sslSocket: TIdSSLIOHandlerSocketOpenSSL;
    FCookieManager: TIdCookieManager;
  public
    function Post(const AUrl: string; const APostData: TStringStream; out AResponseText: string; out AErrorStr: string): Boolean;
123123
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

const
  constUserAgent =
    'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36 OPR/50.0.2762.58';
  constConnectTimeOut = 10000;
  constReadTimeOut = 10000;

implementation

uses uErrorMessageFormatter;

procedure THTTPDownloader.AfterConstruction;
begin
  inherited;
  FCookieManager := TIdCookieManager.Create;

  sslSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  sslSocket.SSLOptions.Method := sslvTLSv1_2;

  hpHtmlDownloader := TIdHTTP.Create;
  hpHtmlDownloader.HandleRedirects := True;
  hpHtmlDownloader.CookieManager := FCookieManager;
  hpHtmlDownloader.AllowCookies := True;
  hpHtmlDownloader.Request.UserAgent := constUserAgent;
  // hpHtmlDownloader.Request.CustomHeaders.Clear;
  hpHtmlDownloader.Request.ContentType := 'application/json';
  hpHtmlDownloader.Request.Accept := 'application/json';

  { hpHtmlDownloader.Request.AcceptLanguage := 'ru-RU';
    hpHtmlDownloader.Request.CustomHeaders.AddValue('Authorization', constAuthorizationHeader); }

  hpHtmlDownloader.IOHandler := sslSocket;
  hpHtmlDownloader.ConnectTimeout := constConnectTimeOut;
  hpHtmlDownloader.ReadTimeout := constReadTimeOut;
end;

procedure THTTPDownloader.BeforeDestruction;
begin
  inherited;
  FreeAndNilEx(FCookieManager);
  FreeAndNilEx(hpHtmlDownloader);
  FreeAndNilEx(sslSocket);
end;

function THTTPDownloader.Post(const AUrl: string; const APostData: TStringStream; out AResponseText: string;
  out AErrorStr: string): Boolean;
begin
  Result := False;
  try
    if not Assigned(APostData) then
    begin
      AErrorStr := TErrorMessageFormatter.ErrorRunMethodMessage(Self, 'Post', 'Пустые данные для Post запроса');
      Exit;
    end;
    AResponseText := hpHtmlDownloader.Post(AUrl, APostData);

    Result := True;
  except
    on E: Exception do
    begin
      AErrorStr := TErrorMessageFormatter.ErrorRunMethodMessage(Self, 'Post', E);
    end;
  end;

end;

end.
