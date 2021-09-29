object ServiceUser: TServiceUser
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 143
  object qryCadastroUsuario: TFDQuery
    CachedUpdates = True
    SQL.Strings = (
      'select * from usuario')
    Left = 56
    Top = 16
  end
  object qryPesquisaUsuario: TFDQuery
    SQL.Strings = (
      'select * from usuario')
    Left = 56
    Top = 80
  end
end
