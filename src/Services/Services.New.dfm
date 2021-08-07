object ServiceNew: TServiceNew
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 139
  Width = 150
  object mtPesquisaCarteiraPTEA: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 56
    Top = 72
    object mtPesquisaCarteiraPTEAid: TFDAutoIncField
      AutoGenerateValue = arNone
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ClientAutoIncrement = False
    end
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
    object mtPesquisaCarteiraPTEAfotoRostoPath: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'fotoRostoPath'
      Origin = 'fotoRostoPath'
      Size = 254
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
    object mtCadastroCarteiraPTEAid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
    end
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
  end
end
