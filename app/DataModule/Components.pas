unit Components;

interface

uses
  System.SysUtils, System.Classes, System.Actions, FMX.ActnList, FMX.Forms;

type
  TdmComponent = class(TDataModule)
    ActionList: TActionList;
    actClose: TAction;
    procedure actCloseExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmComponent: TdmComponent;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

procedure TdmComponent.actCloseExecute(Sender: TObject);
begin
  Application.Terminate; // Close all form
end;

end.
