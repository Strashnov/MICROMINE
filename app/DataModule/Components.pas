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

uses Main, ExportToFile, About, ANSIToByte;
{$R *.dfm}

procedure TdmComponent.actAboutExecute(Sender: TObject);
begin
  formAbout.ShowModal; // Open form about
end;

procedure TdmComponent.actCloseExecute(Sender: TObject);
begin
  Application.Terminate; // Close all form
end;

procedure TdmComponent.actOpenFileExecute(Sender: TObject);
var
  List: TStringList;
  Count, Rows, Columns, CountColums, IncArrayHeader, IncArrayValues,
    incArrayType, RowsInNotVisible, StringLenght: Integer;
  ArrayType: array of string;
  NumberOfColumns, StringOne, StringTwo: string;
  HeaderArrayBuf: array of string;
  StartToCopy, StopToCopy: array of Integer;
  Encoding: TEncoding;
  ANSIToByte: TANSIToByte;
var
  i: Integer;
begin
  if OpenDialog.Execute then
  begin
    List := TStringList.Create;
    try
      List.LoadFromFile(OpenDialog.FileName);

//      for i := 0 to Count do
//        if List.Strings[i] = '^J' then
//          List.Strings[i].Replace('^J', '');
      Count := List.Count;
      formMain.labNumberOfLines.Text := 'Rows: ' + IntToStr(Count - 2);
      formMain.Caption := List.Strings[0]; // Micromine
      List.BeginUpdate;
      NumberOfColumns := Trim(Copy(List.Strings[1], 4055, 4)); // Variable
      List.EndUpdate;
{$REGION 'Read the column names into the array'}
      List.Move(0, List.Count - 1); // Shift down two positions
      List.Move(0, List.Count - 1);
      // Name columns head
      SetLength(HeaderArrayBuf, NumberOfColumns.ToInteger);
      for IncArrayHeader := Low(HeaderArrayBuf) to High(HeaderArrayBuf) do
      begin
        List.BeginUpdate;
        HeaderArrayBuf[IncArrayHeader] :=
          Copy(List.Strings[IncArrayHeader], 1, 10);
        List.EndUpdate;
      end;
      // The number of characters in the variable
      SetLength(StopToCopy, NumberOfColumns.ToInteger);
      for IncArrayValues := Low(StopToCopy) to High(StopToCopy) do
      begin
        List.BeginUpdate;
        StopToCopy[IncArrayValues] :=
          Trim(Copy(List.Strings[IncArrayValues], 13, 3)).ToInteger;
        List.EndUpdate;
        SetLength(ArrayType, NumberOfColumns.ToInteger);
      end;
      for incArrayType := Low(ArrayType) to High(ArrayType) do
      begin
        List.BeginUpdate;
        ArrayType[incArrayType] :=
          Trim(Copy(List.Strings[incArrayType], 11, 1));
        List.EndUpdate;
      end;
      List.Move(List.Count - 1, 0); // Shift is two positions up
      List.Move(List.Count - 1, 0);
      // formMain.labExtensionFile.Text := NumberOfColumns;
{$ENDREGION}
{$REGION 'Create columns and rows'}
      for CountColums := 0 to NumberOfColumns.ToInteger - 1 do
      begin
        formMain.StringGrid.AddObject(TStringColumn.Create(self));
        // Create columns
        formMain.StringGrid.RowCount := Count - (2 + NumberOfColumns.ToInteger);
        // Number of lines
        formMain.StringGrid.Columns[CountColums].Header :=
          HeaderArrayBuf[CountColums];
      end;

{$ENDREGION}
{$REGION 'Shift positions for values'}
      for RowsInNotVisible := 1 to (2 + NumberOfColumns.ToInteger) do
        List.Move(0, List.Count - 1);

{$ENDREGION}
{$REGION 'Inser values to StrinGrid'}
      for Rows := 0 to formMain.StringGrid.RowCount - 1 do
      begin
        List.BeginUpdate;
        StringLenght := Length(List.Strings[Rows]);
        StringOne := Copy(List.Strings[Rows], 1, StringLenght);

        IncArrayValues := 1;
        for Columns := 0 to formMain.StringGrid.ColumnCount - 1 do
        begin
          StringTwo := Copy(StringOne, IncArrayValues, StopToCopy[Columns]);
          if Length(StringTwo) >= StopToCopy[Columns] then
          begin
            if ArrayType[Columns] = 'R' then
            begin
              ANSIToByte := TANSIToByte.Create;
              try
                ANSIToByte.ByteTo(StringTwo);
                formMain.StringGrid.Cells[Columns, Rows] :=
                  ANSIToByte.ResultString;
                IncArrayValues := IncArrayValues + StopToCopy[Columns];
              finally
                ANSIToByte.Free;
              end;
            end
            else
            begin
              formMain.StringGrid.Cells[Columns, Rows] := StringTwo;
              IncArrayValues := IncArrayValues + StopToCopy[Columns];
            end;
          end
          else
          begin
            formMain.StringGrid.Cells[Columns, Rows] := StringTwo;
            IncArrayValues := IncArrayValues + StopToCopy[Columns];
          end;
        end;
      end;
      List.EndUpdate;
{$ENDREGION}
    finally
      List.Free;
    end;
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
