object dmComponent: TdmComponent
  Height = 480
  Width = 640
  object ActionList: TActionList
    Left = 520
    Top = 16
    object actClose: TAction
      Text = 'Close'
      ShortCut = 16451
      OnExecute = actCloseExecute
    end
    object actOpenFile: TAction
      Text = 'Open'
      OnExecute = actOpenFileExecute
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Micromine|*.STR|Al file|*.*'
    Left = 424
    Top = 24
  end
end
