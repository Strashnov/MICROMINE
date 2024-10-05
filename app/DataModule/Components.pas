unit Components;

interface

uses
  System.SysUtils, System.Classes, System.Actions, FMX.ActnList, FMX.Forms,
  FMX.Types, FMX.Dialogs, StrUtils, FMX.Grid.Style, FMX.Grid, FMX.Controls,
  FMX.DialogService, System.UITypes, FMX.Printer;

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
    PrintDialog: TPrintDialog;
    actPrinter: TAction;
    procedure actCloseExecute(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
    procedure actSaveToCSVExecute(Sender: TObject);
    procedure actSaveToTXTExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actPrinterExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  dmComponent: TdmComponent;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses Main, ExportToFile, About, Printer;
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
  List: TStringList;
  Count, CountColums, IncArrayHeader, IncArrayValues: Integer;
  Rows, Columns, i: Integer;
  NumberOfColumns: string;
  HeaderArrayBuf, ArrayValuseBuf: array of string;
begin
  if OpenDialog.Execute then
  begin
    List := TStringList.Create;

    try
      List.LoadFromFile(OpenDialog.FileName);
      Count := List.Count;
      formMain.Caption := List.Strings[0];
      NumberOfColumns := Trim(Copy(List.Strings[1], 4055, 4));
      // ����� ����������
{$REGION 'We read the column names into the array'}
      List.Move(0, List.Count - 1);
      List.Move(0, List.Count - 1);
      SetLength(HeaderArrayBuf, NumberOfColumns.ToInteger);
      for IncArrayHeader := Low(HeaderArrayBuf) to High(HeaderArrayBuf) do
      begin
        HeaderArrayBuf[IncArrayHeader] :=
          Copy(List.Strings[IncArrayHeader], 1, 10);
      end;
      List.Move(List.Count - 1, 0);
      List.Move(List.Count - 1, 0);
      // formMain.labExtensionFile.Text := NumberOfColumns;
{$ENDREGION}
{$REGION 'Work with grid'}
      for CountColums := 0 to NumberOfColumns.ToInteger - 1 do
      begin
        formMain.StringGrid.AddObject(TStringColumn.Create(self));
        // ������� �������
        formMain.StringGrid.RowCount := Count; // ���������� �����
        formMain.StringGrid.Columns[CountColums].Header :=
          HeaderArrayBuf[CountColums];
      end;

{$ENDREGION}
{$REGION 'Values in grid'}
      for Rows := 0 to formMain.StringGrid.RowCount - 1 do
      begin
        for Columns := 0 to formMain.StringGrid.ColumnCount - 1 do
        begin
          formMain.StringGrid.Cells[Columns, Rows] := IntToStr(Random(100));
        end;
      end
{$ENDREGION}
    finally
      List.Clear;
    end;
  end;

end;

procedure TdmComponent.actPrinterExecute(Sender: TObject); // Printer
var
  PrintingPage: TPrintingPage;
begin
  PrintingPage := TPrintingPage.Create;
  try
    PrintingPage.Start(PrintDialog, formMain.StringGrid);
  finally
    PrintingPage.Free;
  end;
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
