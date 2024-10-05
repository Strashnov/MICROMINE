unit About;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects
{$IFDEF MSWINDOWS}
    , FMX.Platform.Win, Winapi.Windows, Winapi.ShellAPI
{$ENDIF};

type
  TformAbout = class(TForm)
    sbClose: TSpeedButton;
    panLine: TPanel;
    imgLogo: TImage;
    txtVersion: TText;
    labDescription: TLabel;
    labAuthor: TLabel;
    labTelephone: TLabel;
    labEmailLink: TLabel;
    labEmail: TLabel;
    procedure sbCloseClick(Sender: TObject);
{$IFDEF MSWINDOWS}
    procedure labEmailLinkClick(Sender: TObject);
{$ENDIF}
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formAbout: TformAbout;

implementation

{$R *.fmx}

uses Components;
{$IFDEF MSWINDOWS}

procedure TformAbout.labEmailLinkClick(Sender: TObject);
begin
  ShellExecute(FmxHandleToHWND(Handle), 'open',
    PChar('mailto:delcpy@yandex.ru'), nil, nil, SW_SHOWNORMAL);
end;
{$ENDIF}

procedure TformAbout.sbCloseClick(Sender: TObject);
begin
  formAbout.Close;
end;

end.
