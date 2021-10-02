object ServiceUser: TServiceUser
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 103
  object qryUsuarioLocal: TFDQuery
    Connection = ServiceLocalConnection.LocalConnection
    SQL.Strings = (
      'select * from usuario limit 1')
    Left = 29
    Top = 14
    object qryUsuarioLocalid: TIntegerField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qryUsuarioLocalNome: TStringField
      FieldName = 'Nome'
      Origin = 'Nome'
      Size = 32767
    end
    object qryUsuarioLocalToken: TStringField
      FieldName = 'Token'
      Origin = 'Token'
      Size = 32767
    end
    object qryUsuarioLocalStayConected: TBooleanField
      FieldName = 'StayConected'
      Origin = 'StayConected'
      Required = True
    end
    object qryUsuarioLocalTokenCreatedAt: TIntegerField
      FieldName = 'TokenCreatedAt'
      Origin = 'TokenCreatedAt'
    end
    object qryUsuarioLocalTokenExpires: TIntegerField
      FieldName = 'TokenExpires'
      Origin = 'TokenExpires'
    end
  end
  object mtUsuario: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 32
    Top = 80
    object mtUsuarioid: TIntegerField
      FieldName = 'id'
    end
    object mtUsuarionome: TStringField
      FieldName = 'nome'
      Size = 100
    end
    object mtUsuarioemail: TStringField
      FieldName = 'email'
      Size = 100
    end
    object mtUsuariosenha: TStringField
      FieldName = 'senha'
      Size = 254
    end
  end
end
