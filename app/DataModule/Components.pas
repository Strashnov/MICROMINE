unit Components;

interface

uses
  System.SysUtils, System.Classes, System.Actions, FMX.ActnList, FMX.Forms,
  FMX.Types, FMX.Dialogs, StrUtils, FMX.Grid.Style, FMX.Grid;

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
var
  MicromineFile: textfile;
  s, NumberOfColumns: string;
  Count, CountLinesFile, VariableToFile: integer;
  CountColums: integer;
begin
{$REGION 'Open text file'}
  Count := 0;
  if OpenDialog.Execute then
  begin
    AssignFile(MicromineFile, OpenDialog.FileName);
    Reset(MicromineFile);
    Readln(MicromineFile, s);
    formMain.Caption := Copy(s, 0, 37); // ��������� ������ ������
    while not(eof(MicromineFile)) do
    begin
      Readln(MicromineFile, s);
      Inc(Count); // ������� ���������� �����
      for CountLinesFile := 0 to Count do
      begin
        VariableToFile := pos('VARIABLES', s, 1);
        if VariableToFile <> 0 then
          NumberOfColumns := Copy(s, 4055, 2);
        formMain.labExtensionFile.Text := NumberOfColumns;
        // ������ ���������� �������� � ����� �����
      end;
    end;
    CloseFile(MicromineFile);
  end;
{$ENDREGION}
{$REGION 'Create col'}
  for CountColums := 0 to NumberOfColumns.ToInteger do
  begin
    formMain.StringGrid.AddObject(TStringColumn.Create(self));
    formMain.StringGrid.Columns[CountColums].Header := IntToStr(Random(100));
  end;
{$ENDREGION}
end;

end.
