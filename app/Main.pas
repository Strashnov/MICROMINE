unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus;

type
  TformMain = class(TForm)
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    miHelp: TMenuItem;
    miClose: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formMain: TformMain;

implementation

{$R *.fmx}

uses Components;

end.
