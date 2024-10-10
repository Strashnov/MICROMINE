// -----------------------------------------------------------------------------
// ru-RU
// Экспорт в файл txt или csv
//
// en-EN
// Export to file txt or csv
//
// Version 1.0.0
// The year the module was created 04.10.2024
// -----------------------------------------------------------------------------
// ------------------------------------------------------- author Strashnov Igor
// -----------------------------------------------------------------------------
unit ExportToFile;

interface

uses FMX.DialogService, System.UITypes, FMX.Dialogs, FMX.Grid, FMX.Edit,
  System.SysUtils;

Type
  /// <summary>
  /// Import from stringgrid to file csv or txt
  /// </summary>
  TExportToFile = class sealed(TObject)
  private
    FFile: TextFile;
  public
    procedure Data(SaveDialog: TSaveDialog; Grid: TStringGrid;
      Seporator: TEdit);
  end;

implementation

{ TExportToFile }

procedure TExportToFile.Data(SaveDialog: TSaveDialog; Grid: TStringGrid;
  Seporator: TEdit);
var
  Rows, Columns: Integer;
const
  MESSAGE_DIALOG: string = 'This file already exists'; // Message
begin
  if SaveDialog.Execute then
    AssignFile(FFile, SaveDialog.FileName);
  begin
    begin
{$REGION 'Meesage dialog if file exists'}
      if FileExists(SaveDialog.FileName) = true then
        TDialogService.MessageDialog(MESSAGE_DIALOG, TMsgDlgType.mtConfirmation,
          mbYesNo, TMsgDlgBtn.mbNo, 0,
          procedure(const AResult: TModalResult)
          begin
            if (AResult = mrYes) then
            begin
              Rewrite(FFile);
            end;
          end)
{$ENDREGION}
      else
{$REGION 'Create file if not exist file and save'}
      begin
        Rewrite(FFile);
        for Rows := 0 to Grid.RowCount - 1 do
        begin
          for Columns := 0 to Grid.ColumnCount - 1 do
          begin
            if Columns > 0 then
              Write(FFile, Seporator.Text);
            Write(FFile, Trim(Grid.Cells[Columns, Rows]));
          end;
          Writeln(FFile);
        end;
        CloseFile(FFile);
      end;
{$ENDREGION}
    end;
  end;
end;

end.
