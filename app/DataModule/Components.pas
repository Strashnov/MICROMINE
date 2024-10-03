unit Components;

interface

uses
  System.SysUtils, System.Classes, System.Actions, FMX.ActnList, FMX.Forms,
  FMX.Types, FMX.Dialogs, StrUtils, FMX.Grid.Style, FMX.Grid, FMX.Controls,
  FMX.DialogService, System.UITypes;

type
  TdmComponent = class(TDataModule)
    ActionList: TActionList;
    actClose: TAction;
    OpenDialog: TOpenDialog;
    actOpenFile: TAction;
    SaveDialogTXT: TSaveDialog;
    actSaveToTXT: TAction;
    SaveDialogCSV: TSaveDialog;
    actSaveToCSV: TAction;
    StyleBook: TStyleBook;
    procedure actCloseExecute(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
    procedure actSaveToTXTExecute(Sender: TObject);
    procedure actSaveToCSVExecute(Sender: TObject);
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
  for CountColums := 0 to NumberOfColumns.ToInteger - 1 do
  begin
    formMain.StringGrid.AddObject(TStringColumn.Create(self));
    formMain.StringGrid.Columns[CountColums].Header := IntToStr(Random(100));
    formMain.StringGrid.RowCount := 2;
  end;
{$ENDREGION}
end;

procedure TdmComponent.actSaveToCSVExecute(Sender: TObject);
var
  f: textfile;
  i, j: integer;
begin
  if SaveDialogCSV.Execute then
    AssignFile(f, SaveDialogCSV.FileName);
  if FileExists(SaveDialogCSV.FileName) = true then
    TDialogService.MessageDialog('This file already exists',
      TMsgDlgType.mtConfirmation, mbYesNo, TMsgDlgBtn.mbNo, 0,
      procedure(const AResult: TModalResult)
      begin
        if (AResult = mrYes) then
        begin
          Rewrite(f);
        end;
      end)

  else
  begin
    Rewrite(f);
    for i := 0 to formMain.StringGrid.ColumnCount - 1 do
      for j := 0 to formMain.StringGrid.RowCount - 1 do
        Write(f, formMain.StringGrid.Cells[j, i] + formMain.edtSeparator.Text);

    CloseFile(f);
  end;
end;

procedure TdmComponent.actSaveToTXTExecute(Sender: TObject);
var
  f: textfile;
  i, j: integer;
begin
  if SaveDialogTXT.Execute then
  begin
    AssignFile(f, SaveDialogTXT.FileName);
    if FileExists(SaveDialogTXT.FileName) = true then
      TDialogService.MessageDialog('This file already exists',
        TMsgDlgType.mtConfirmation, mbYesNo, TMsgDlgBtn.mbNo, 0,
        procedure(const AResult: TModalResult)
        begin
          if (AResult = mrYes) then
          begin
            Rewrite(f);
          end;
        end)

    else
      Rewrite(f);
    for i := 0 to formMain.StringGrid.ColumnCount - 1 do
      for j := 0 to formMain.StringGrid.RowCount - 1 do
        Write(f, formMain.StringGrid.Cells[j, j] + formMain.edtSeparator.Text);
    CloseFile(f);
  end;
end;

end.
