unit Components;

interface

uses
  System.SysUtils, System.Classes, System.Actions, FMX.ActnList, FMX.Forms,
  FMX.Types, FMX.Dialogs;

type
  TdmComponent = class(TDataModule)
    ActionList: TActionList;
    actClose: TAction;
    OpenDialog: TOpenDialog;
    actOpenFile: TAction;
    procedure actCloseExecute(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmComponent: TdmComponent;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses Main;
{$R *.dfm}

procedure TdmComponent.actCloseExecute(Sender: TObject);
begin
  Application.Terminate; // Close all form
end;

procedure TdmComponent.actOpenFileExecute(Sender: TObject);
begin
  if OpenDialog.Execute then
    formMain.memText.Lines.LoadFromFile(OpenDialog.FileName);
end;

end.
