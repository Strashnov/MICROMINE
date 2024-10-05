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
    actAbout: TAction;
    procedure actCloseExecute(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
    procedure actSaveToCSVExecute(Sender: TObject);
    procedure actSaveToTXTExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  dmComponent: TdmComponent;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses Main, ExportToFile, About;
{$R *.dfm}

procedure TdmComponent.actAboutExecute(Sender: TObject);
begin
  formAbout.ShowModal;
end;

procedure TdmComponent.actCloseExecute(Sender: TObject);
begin
  Application.Terminate; // Close all form
end;

procedure TdmComponent.actOpenFileExecute(Sender: TObject);
var
  MicromineFile: textfile;
  s, NumberOfColumns, StringCopy: string;
  Count, CountLinesFile, VariableToFile: integer;
  CountColums, i: integer;
  OneString, TwoString, ThreeString, FourString, FiveString: string;
begin
  Count := 0;
  if OpenDialog.Execute then
  begin
    AssignFile(MicromineFile, OpenDialog.FileName);
    Reset(MicromineFile);
    Readln(MicromineFile, s);
    formMain.Caption := Copy(s, 0, 37); // ��������� ������ ������
{$REGION '������� ����������, ������� ����� � ���������� � ������� ����� � �����'}
    while not(eof(MicromineFile)) do
    begin
      Inc(Count); // ������� ���������� �����
      Readln(MicromineFile, s);
      for CountLinesFile := 0 to Count do
      begin
        VariableToFile := pos('VARIABLES', s, 1);
        if VariableToFile <> 0 then
          NumberOfColumns := Copy(s, 4055, 2);
        formMain.labExtensionFile.Text := NumberOfColumns; // Count.ToString; //
        // ������ ���������� �������� � ����� �����
      end;
    end;
{$ENDREGION}
{$REGION 'Create col'}
    for CountColums := 0 to NumberOfColumns.ToInteger - 1 do
    begin
      // if CountLinesFile = 1 then
      // begin
      Readln(MicromineFile, s);
      i := Length(s); // ���������� ���������� �������� � ������
      StringCopy := Copy(s, 0, i); // ��������� ��� ������ �������

      // ��������� ������
      OneString := Copy(StringCopy, 1, 10); // �������� ��� �� 10 ��������
      TwoString := Copy(StringCopy, 11, 3); // �������� ������ ���� ������
      ThreeString := Copy(StringCopy, 14, 3); // �������� ����� �� �������
      FourString := Copy(StringCopy, 17, 1); // �������� �������
      FiveString := Trim(Copy(StringCopy, 19, 255)); // �������� ��������
      // ShowMessage(OneString);

      formMain.StringGrid.AddObject(TStringColumn.Create(self));
      formMain.StringGrid.Columns[CountColums].Header := OneString;
      // IntToStr(Random(100));
      formMain.StringGrid.RowCount := 2;

      formMain.ProgressBar.Value := CountColums;
    end;
    // end;
    // {$ENDREGION}
  end;

  CloseFile(MicromineFile);
end;

procedure TdmComponent.actSaveToCSVExecute(Sender: TObject); // Export to CSV
var
  ExportToCSV: TExportToFile;
begin
  ExportToCSV := TExportToFile.Create;
  try
    ExportToCSV.Data(SaveDialogCSV, formMain.StringGrid, formMain.edtSeparator);
  finally
    ExportToCSV.Free;
  end;
end;

procedure TdmComponent.actSaveToTXTExecute(Sender: TObject); // Export to TXT
var
  ExportToTxt: TExportToFile;
begin
  ExportToTxt := TExportToFile.Create;
  try
    ExportToTxt.Data(SaveDialogTXT, formMain.StringGrid, formMain.edtSeparator);
  finally
    ExportToTxt.Free;
  end;
end;

end.
