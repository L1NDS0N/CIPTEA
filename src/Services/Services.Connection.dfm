object ServiceConnection: TServiceConnection
  OldCreateOrder = False
  Height = 97
  Width = 132
  object LocalConnection: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\Lindson Fran'#231'a\Desktop\CIPTEA\src\db\CIPTEA.db' +
        '3'
      'OpenMode=ReadWrite'
      'Encrypt='
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    BeforeConnect = LocalConnectionBeforeConnect
    Left = 56
    Top = 24
  end
end
