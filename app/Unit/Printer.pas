unit Printer;

interface

uses
  FMX.Dialogs, FMX.Grid, FMX.Printer
{$IFDEF MSWINDOWS}
  {,Vcl.Printers}
{$ENDIF};

Type
  /// <summary>
  /// Printer
  /// </summary>
  TPrintingPage = class sealed(TObject)
  private
    FFile: TextFile;
  public
    procedure Start(PrintDialog: TPrintDialog; Grid: TStringGrid);
  end;

implementation

{ TPrintingPage }

procedure TPrintingPage.Start(PrintDialog: TPrintDialog; Grid: TStringGrid);
var
  Rows, Columns: Integer;
  Print: TPrinter;
begin
  if PrintDialog.Execute then
    AssignPrn(FFile);
  begin
    Rewrite(FFile);
    for Rows := 0 to Grid.RowCount - 1 do
    begin
      for Columns := 0 to Grid.ColumnCount - 1 do
      begin
        if Columns > 0 then
          Write(FFile, Grid.Cells[Columns, Rows]);
      end;
      Writeln(FFile);
    end;
  end;
  CloseFile(FFile);
end;

end.
