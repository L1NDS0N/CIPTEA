object ServiceConnection: TServiceConnection
  OldCreateOrder = False
  Height = 83
  Width = 248
  object FDConnection: TFDConnection
    Params.Strings = (
      'User_Name=root'
      'Password=root'
      'Database=CIPTEA'
      'Server=localhost'
      'DriverID=MySQL')
    LoginPrompt = False
    BeforeConnect = FDConnectionBeforeConnect
    Left = 40
    Top = 16
  end
  object FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink
    Left = 160
    Top = 16
  end
end
