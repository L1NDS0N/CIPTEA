object ServiceAuth: TServiceAuth
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 363
  Width = 97
  object qryUsuario: TFDQuery
    Connection = ServiceLocalConnection.LocalConnection
    SQL.Strings = (
      'select * from usuario limit 1')
    Left = 29
    Top = 40
    object qryUsuarioId: TIntegerField
      FieldName = 'Id'
      Origin = 'Id'
    end
    object qryUsuarioNome: TStringField
      FieldName = 'Nome'
      Origin = 'Nome'
      Required = True
      Size = 32767
    end
    object qryUsuarioToken: TStringField
      FieldName = 'Token'
      Origin = 'Token'
      Size = 254
    end
    object qryUsuarioRefreshToken: TStringField
      FieldName = 'RefreshToken'
      Origin = 'RefreshToken'
      Size = 254
    end
    object qryUsuarioTokenExpires: TSQLTimeStampField
      FieldName = 'TokenExpires'
      Origin = 'TokenExpires'
    end
    object qryUsuarioStayConected: TBooleanField
      FieldName = 'StayConected'
      Origin = 'StayConected'
      Required = True
    end
  end
end
