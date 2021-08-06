object ServiceCarteiraPTEA: TServiceCarteiraPTEA
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 145
  Width = 144
  object qryCadastroCarteiraPTEA: TFDQuery
    CachedUpdates = True
    Connection = ServiceConnection.FDConnection
    SQL.Strings = (
      'select * from carteiraptea')
    Left = 56
    Top = 16
    object qryCadastroCarteiraPTEAid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryCadastroCarteiraPTEANomeResponsavel: TStringField
      FieldName = 'NomeResponsavel'
      Origin = 'NomeResponsavel'
      Required = True
      Size = 80
    end
    object qryCadastroCarteiraPTEACpfResponsavel: TStringField
      FieldName = 'CpfResponsavel'
      Origin = 'CpfResponsavel'
      Required = True
      Size = 14
    end
    object qryCadastroCarteiraPTEARgResponsavel: TStringField
      FieldName = 'RgResponsavel'
      Origin = 'RgResponsavel'
      Required = True
    end
    object qryCadastroCarteiraPTEANomeTitular: TStringField
      FieldName = 'NomeTitular'
      Origin = 'NomeTitular'
      Required = True
      Size = 80
    end
    object qryCadastroCarteiraPTEACpfTitular: TStringField
      FieldName = 'CpfTitular'
      Origin = 'CpfTitular'
      Required = True
      Size = 14
    end
    object qryCadastroCarteiraPTEARgTitular: TStringField
      FieldName = 'RgTitular'
      Origin = 'RgTitular'
      Required = True
    end
    object qryCadastroCarteiraPTEADataNascimento: TDateField
      FieldName = 'DataNascimento'
      Origin = 'DataNascimento'
      Required = True
    end
    object qryCadastroCarteiraPTEAfotoRostoPath: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'fotoRostoPath'
      Origin = 'fotoRostoPath'
      Size = 254
    end
    object qryCadastroCarteiraPTEAEmailContato: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'EmailContato'
      Origin = 'EmailContato'
      Size = 100
    end
    object qryCadastroCarteiraPTEANumeroContato: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'NumeroContato'
      Origin = 'NumeroContato'
      Size = 10
    end
    object qryCadastroCarteiraPTEACriadoEm: TSQLTimeStampField
      AutoGenerateValue = arDefault
      FieldName = 'CriadoEm'
      Origin = 'CriadoEm'
    end
    object qryCadastroCarteiraPTEAAlteradoEm: TSQLTimeStampField
      AutoGenerateValue = arDefault
      FieldName = 'AlteradoEm'
      Origin = 'AlteradoEm'
    end
  end
  object qryPesquisaCarteiraPTEA: TFDQuery
    Connection = ServiceConnection.FDConnection
    SQL.Strings = (
      'select * from carteiraptea')
    Left = 56
    Top = 72
    object qryPesquisaCarteiraPTEAid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryPesquisaCarteiraPTEANomeResponsavel: TStringField
      FieldName = 'NomeResponsavel'
      Origin = 'NomeResponsavel'
      Required = True
      Size = 80
    end
    object qryPesquisaCarteiraPTEACpfResponsavel: TStringField
      FieldName = 'CpfResponsavel'
      Origin = 'CpfResponsavel'
      Required = True
      Size = 14
    end
    object qryPesquisaCarteiraPTEARgResponsavel: TStringField
      FieldName = 'RgResponsavel'
      Origin = 'RgResponsavel'
      Required = True
    end
    object qryPesquisaCarteiraPTEANomeTitular: TStringField
      FieldName = 'NomeTitular'
      Origin = 'NomeTitular'
      Required = True
      Size = 80
    end
    object qryPesquisaCarteiraPTEACpfTitular: TStringField
      FieldName = 'CpfTitular'
      Origin = 'CpfTitular'
      Required = True
      Size = 14
    end
    object qryPesquisaCarteiraPTEARgTitular: TStringField
      FieldName = 'RgTitular'
      Origin = 'RgTitular'
      Required = True
    end
    object qryPesquisaCarteiraPTEADataNascimento: TDateField
      FieldName = 'DataNascimento'
      Origin = 'DataNascimento'
      Required = True
    end
    object qryPesquisaCarteiraPTEAfotoRostoPath: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'fotoRostoPath'
      Origin = 'fotoRostoPath'
      Size = 254
    end
    object qryPesquisaCarteiraPTEAEmailContato: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'EmailContato'
      Origin = 'EmailContato'
      Size = 100
    end
    object qryPesquisaCarteiraPTEANumeroContato: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'NumeroContato'
      Origin = 'NumeroContato'
      Size = 10
    end
    object qryPesquisaCarteiraPTEACriadoEm: TSQLTimeStampField
      AutoGenerateValue = arDefault
      FieldName = 'CriadoEm'
      Origin = 'CriadoEm'
    end
    object qryPesquisaCarteiraPTEAAlteradoEm: TSQLTimeStampField
      AutoGenerateValue = arDefault
      FieldName = 'AlteradoEm'
      Origin = 'AlteradoEm'
    end
  end
end
