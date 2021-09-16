object ServiceNew: TServiceNew
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 274
  Width = 154
  object mtPesquisaCarteiraPTEA: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
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
    Top = 72
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
    object mtCadastroCarteiraPTEAfotoRostoPath: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'fotoRostoPath'
      Origin = 'fotoRostoPath'
      Size = 254
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
    Left = 56
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
    Left = 56
    Top = 200
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
end
