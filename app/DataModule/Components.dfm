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
  end
end
