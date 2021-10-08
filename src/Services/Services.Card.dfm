object ServiceCard: TServiceCard
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 301
  Width = 303
  object mtPesquisaCarteiraPTEA: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvStoreVersion, rvStoreItems, rvSilentMode, rvStoreMergeData, rvStoreMergeMeta]
    ResourceOptions.StoreVersion = 1
    ResourceOptions.StoreItems = [siMeta, siData, siDelta, siVisible]
    ResourceOptions.StoreMergeData = dmDataAppend
    ResourceOptions.StoreMergeMeta = mmUpdate
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable, uvAutoCommitUpdates]
    UpdateOptions.LockWait = True
    UpdateOptions.RefreshMode = rmAll
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    UpdateOptions.CheckReadOnly = False
    UpdateOptions.CheckUpdatable = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 56
    Top = 128
    object mtPesquisaCarteiraPTEANomeResponsavel: TStringField
      FieldName = 'NomeResponsavel'
      Origin = 'NomeResponsavel'
      Required = True
      Size = 80
    end
    object mtPesquisaCarteiraPTEACpfResponsavel: TStringField
      FieldName = 'CpfResponsavel'
      Origin = 'CpfResponsavel'
      Required = True
      Size = 14
    end
    object mtPesquisaCarteiraPTEARgResponsavel: TStringField
      FieldName = 'RgResponsavel'
      Origin = 'RgResponsavel'
      Required = True
    end
    object mtPesquisaCarteiraPTEANomeTitular: TStringField
      FieldName = 'NomeTitular'
      Origin = 'NomeTitular'
      Required = True
      Size = 80
    end
    object mtPesquisaCarteiraPTEACpfTitular: TStringField
      FieldName = 'CpfTitular'
      Origin = 'CpfTitular'
      Required = True
      Size = 14
    end
    object mtPesquisaCarteiraPTEARgTitular: TStringField
      FieldName = 'RgTitular'
      Origin = 'RgTitular'
      Required = True
    end
    object mtPesquisaCarteiraPTEADataNascimento: TDateField
      FieldName = 'DataNascimento'
      Origin = 'DataNascimento'
      Required = True
    end
    object mtPesquisaCarteiraPTEAEmailContato: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'EmailContato'
      Origin = 'EmailContato'
      Size = 100
    end
    object mtPesquisaCarteiraPTEANumeroContato: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'NumeroContato'
      Origin = 'NumeroContato'
      Size = 10
    end
    object mtPesquisaCarteiraPTEACriadoEm: TSQLTimeStampField
      AutoGenerateValue = arDefault
      FieldName = 'CriadoEm'
      Origin = 'CriadoEm'
    end
    object mtPesquisaCarteiraPTEAAlteradoEm: TSQLTimeStampField
      AutoGenerateValue = arDefault
      FieldName = 'AlteradoEm'
      Origin = 'AlteradoEm'
    end
    object mtPesquisaCarteiraPTEAid: TIntegerField
      FieldName = 'id'
    end
    object mtPesquisaCarteiraPTEAIfNoneMatch: TStringField
      FieldName = 'IfNoneMatch'
      Size = 100
    end
    object mtPesquisaCarteiraPTEAFotoStream: TBlobField
      FieldName = 'FotoStream'
    end
  end
  object mtCadastroCarteiraPTEA: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 56
    Top = 16
    object mtCadastroCarteiraPTEANomeResponsavel: TStringField
      FieldName = 'NomeResponsavel'
      Origin = 'NomeResponsavel'
      Size = 80
    end
    object mtCadastroCarteiraPTEACpfResponsavel: TStringField
      FieldName = 'CpfResponsavel'
      Origin = 'CpfResponsavel'
      Size = 14
    end
    object mtCadastroCarteiraPTEARgResponsavel: TStringField
      FieldName = 'RgResponsavel'
      Origin = 'RgResponsavel'
    end
    object mtCadastroCarteiraPTEANomeTitular: TStringField
      FieldName = 'NomeTitular'
      Origin = 'NomeTitular'
      Size = 80
    end
    object mtCadastroCarteiraPTEACpfTitular: TStringField
      FieldName = 'CpfTitular'
      Origin = 'CpfTitular'
      Size = 14
    end
    object mtCadastroCarteiraPTEARgTitular: TStringField
      FieldName = 'RgTitular'
      Origin = 'RgTitular'
    end
    object mtCadastroCarteiraPTEADataNascimento: TDateField
      FieldName = 'DataNascimento'
      Origin = 'DataNascimento'
    end
    object mtCadastroCarteiraPTEAEmailContato: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'EmailContato'
      Origin = 'EmailContato'
      Size = 100
    end
    object mtCadastroCarteiraPTEANumeroContato: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'NumeroContato'
      Origin = 'NumeroContato'
      Size = 10
    end
    object mtCadastroCarteiraPTEAid: TIntegerField
      FieldName = 'id'
    end
    object mtCadastroCarteiraPTEALaudoMedicoPath: TStringField
      FieldName = 'LaudoMedicoPath'
      Size = 254
    end
  end
  object qryArquivosCarteiraPTEA: TFDQuery
    SQL.Strings = (
      'select * from ArquivosCarteiraPTEA'
      'where IDCarteira = :IDCARTEIRA')
    Left = 216
    Top = 136
    ParamData = <
      item
        Name = 'IDCARTEIRA'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
    object qryArquivosCarteiraPTEAIDCarteira: TIntegerField
      FieldName = 'IDCarteira'
      Origin = 'IDCarteira'
    end
    object qryArquivosCarteiraPTEAFotoStream: TBlobField
      FieldName = 'FotoStream'
      Origin = 'FotoStream'
    end
    object qryArquivosCarteiraPTEADocStream: TBlobField
      FieldName = 'DocStream'
      Origin = 'DocStream'
    end
    object qryArquivosCarteiraPTEAIfNoneMatch: TStringField
      FieldName = 'IfNoneMatch'
      Origin = 'IfNoneMatch'
      Size = 32767
    end
    object qryArquivosCarteiraPTEAhasDoc: TBooleanField
      FieldName = 'hasDoc'
    end
  end
  object qryTemp: TFDQuery
    SQL.Strings = (
      'select * from temp')
    Left = 216
    Top = 8
    object qryTempid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryTempFotoRostoPath: TStringField
      FieldName = 'FotoRostoPath'
      Origin = 'FotoRostoPath'
      Size = 254
    end
    object qryTempLaudoMedicoPath: TStringField
      FieldName = 'LaudoMedicoPath'
      Origin = 'LaudoMedicoPath'
      Size = 254
    end
  end
  object qryUsuarioLocal: TFDQuery
    Connection = ServiceLocalConnection.LocalConnection
    SQL.Strings = (
      'select * from usuario limit 1')
    Left = 213
    Top = 72
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
  object mtPaginadorCarteiraPTEA: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvStoreVersion, rvStoreItems, rvSilentMode, rvStorePrettyPrint, rvStoreMergeData, rvStoreMergeMeta]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 56
    Top = 72
    object mtPaginadorCarteiraPTEAtotal: TIntegerField
      FieldName = 'total'
    end
    object mtPaginadorCarteiraPTEAlimit: TIntegerField
      FieldName = 'limit'
    end
    object mtPaginadorCarteiraPTEApage: TIntegerField
      FieldName = 'page'
    end
    object mtPaginadorCarteiraPTEApages: TIntegerField
      FieldName = 'pages'
    end
  end
  object mtFiltrarCarteiraPTEA: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvStoreVersion, rvStoreItems, rvSilentMode, rvStoreMergeData, rvStoreMergeMeta]
    ResourceOptions.StoreVersion = 1
    ResourceOptions.StoreItems = [siMeta, siData, siDelta, siVisible]
    ResourceOptions.StoreMergeData = dmDataAppend
    ResourceOptions.StoreMergeMeta = mmUpdate
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable, uvAutoCommitUpdates]
    UpdateOptions.LockWait = True
    UpdateOptions.RefreshMode = rmAll
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    UpdateOptions.CheckReadOnly = False
    UpdateOptions.CheckUpdatable = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 56
    Top = 192
    object mtFiltrarCarteiraPTEANomeResponsavel: TStringField
      FieldName = 'NomeResponsavel'
      Origin = 'NomeResponsavel'
      Required = True
      Size = 80
    end
    object mtFiltrarCarteiraPTEACpfResponsavel: TStringField
      FieldName = 'CpfResponsavel'
      Origin = 'CpfResponsavel'
      Required = True
      Size = 14
    end
    object mtFiltrarCarteiraPTEARgResponsavel: TStringField
      FieldName = 'RgResponsavel'
      Origin = 'RgResponsavel'
      Required = True
    end
    object mtFiltrarCarteiraPTEANomeTitular: TStringField
      FieldName = 'NomeTitular'
      Origin = 'NomeTitular'
      Required = True
      Size = 80
    end
    object mtFiltrarCarteiraPTEACpfTitular: TStringField
      FieldName = 'CpfTitular'
      Origin = 'CpfTitular'
      Required = True
      Size = 14
    end
    object mtFiltrarCarteiraPTEARgTitular: TStringField
      FieldName = 'RgTitular'
      Origin = 'RgTitular'
      Required = True
    end
    object mtFiltrarCarteiraPTEADataNascimento: TDateField
      FieldName = 'DataNascimento'
      Origin = 'DataNascimento'
      Required = True
    end
    object mtFiltrarCarteiraPTEAEmailContato: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'EmailContato'
      Origin = 'EmailContato'
      Size = 100
    end
    object mtFiltrarCarteiraPTEANumeroContato: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'NumeroContato'
      Origin = 'NumeroContato'
      Size = 10
    end
    object mtFiltrarCarteiraPTEACriadoEm: TSQLTimeStampField
      AutoGenerateValue = arDefault
      FieldName = 'CriadoEm'
      Origin = 'CriadoEm'
    end
    object mtFiltrarCarteiraPTEAAlteradoEm: TSQLTimeStampField
      AutoGenerateValue = arDefault
      FieldName = 'AlteradoEm'
      Origin = 'AlteradoEm'
    end
    object mtFiltrarCarteiraPTEAid: TIntegerField
      FieldName = 'id'
    end
    object mtFiltrarCarteiraPTEAFotoStream: TBlobField
      FieldName = 'FotoStream'
    end
  end
  object mtFiltrarNomes: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 56
    Top = 248
    object mtFiltrarNomesnomes: TDataSetField
      FieldName = 'nomes'
    end
  end
  object mtNomesFiltrados: TFDMemTable
    DataSetField = mtFiltrarNomesnomes
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 168
    Top = 248
    object mtNomesFiltradosnome: TStringField
      DisplayWidth = 80
      FieldName = 'nome'
      LookupCache = True
      Size = 254
    end
  end
end
