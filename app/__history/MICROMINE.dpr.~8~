program MICROMINE;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {formMain},
  Components in 'DataModule\Components.pas' {dmComponent: TDataModule},
  ExportToFile in 'Unit\ExportToFile.pas',
  About in 'Forms\About.pas' {formAbout},
  Printer in 'Unit\Printer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformMain, formMain);
  Application.CreateForm(TdmComponent, dmComponent);
  Application.CreateForm(TformAbout, formAbout);
  Application.Run;
end.
