object ServiceLocalConnection: TServiceLocalConnection
  OldCreateOrder = False
  Height = 96
  Width = 129
  object LocalConnection: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\Lindson Fran'#231'a\Desktop\CIPTEA\src\db\CIPTEA.db' +
        '3'
      'OpenMode=ReadWrite'
      'DriverID=SQLite')
    LoginPrompt = False
    BeforeConnect = LocalConnectionBeforeConnect
    Left = 56
    Top = 24
  end
end
