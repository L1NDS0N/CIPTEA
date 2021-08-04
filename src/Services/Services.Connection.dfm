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
    Connected = True
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Users\Lindson Fran'#231'a\Desktop\CIPTEABackend\lib\libmySQL.dll'
    Left = 160
    Top = 16
  end
end
