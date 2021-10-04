object ServiceAuth: TServiceAuth
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 106
  Width = 97
  object qryUsuario: TFDQuery
    Connection = ServiceLocalConnection.LocalConnection
    SQL.Strings = (
      'select * from usuario limit 1')
    Left = 29
    Top = 40
    object qryUsuarioid: TIntegerField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qryUsuarioNome: TStringField
      FieldName = 'Nome'
      Origin = 'Nome'
      Size = 32767
    end
    object qryUsuarioToken: TStringField
      FieldName = 'Token'
      Origin = 'Token'
      Size = 32767
    end
    object qryUsuarioStayConected: TBooleanField
      FieldName = 'StayConected'
      Origin = 'StayConected'
      Required = True
    end
    object qryUsuarioTokenCreatedAt: TIntegerField
      FieldName = 'TokenCreatedAt'
      Origin = 'TokenCreatedAt'
    end
    object qryUsuarioTokenExpires: TIntegerField
      FieldName = 'TokenExpires'
      Origin = 'TokenExpires'
    end
    object qryUsuarioEmail: TStringField
      FieldName = 'Email'
      Origin = 'Email'
      Size = 32767
    end
  end
end
