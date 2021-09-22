unit Services.CarteiraPTEA;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  Services.Connection,
  FireDAC.VCLUI.Wait;

type
  TServiceCarteiraPTEA = class(TDataModule)
    qryCadastroCarteiraPTEA: TFDQuery;
    qryCadastroCarteiraPTEAid: TFDAutoIncField;
    qryCadastroCarteiraPTEANomeResponsavel: TStringField;
    qryCadastroCarteiraPTEACpfResponsavel: TStringField;
    qryCadastroCarteiraPTEARgResponsavel: TStringField;
    qryCadastroCarteiraPTEANomeTitular: TStringField;
    qryCadastroCarteiraPTEACpfTitular: TStringField;
    qryCadastroCarteiraPTEARgTitular: TStringField;
    qryCadastroCarteiraPTEADataNascimento: TDateField;
    qryCadastroCarteiraPTEAfotoRostoPath: TStringField;
    qryCadastroCarteiraPTEAEmailContato: TStringField;
    qryCadastroCarteiraPTEANumeroContato: TStringField;
    qryCadastroCarteiraPTEACriadoEm: TSQLTimeStampField;
    qryCadastroCarteiraPTEAAlteradoEm: TSQLTimeStampField;
    qryPesquisaCarteiraPTEA: TFDQuery;
    qryPesquisaCarteiraPTEAid: TFDAutoIncField;
    qryPesquisaCarteiraPTEANomeResponsavel: TStringField;
    qryPesquisaCarteiraPTEACpfResponsavel: TStringField;
    qryPesquisaCarteiraPTEARgResponsavel: TStringField;
    qryPesquisaCarteiraPTEANomeTitular: TStringField;
    qryPesquisaCarteiraPTEACpfTitular: TStringField;
    qryPesquisaCarteiraPTEARgTitular: TStringField;
    qryPesquisaCarteiraPTEADataNascimento: TDateField;
    qryPesquisaCarteiraPTEAfotoRostoPath: TStringField;
    qryPesquisaCarteiraPTEAEmailContato: TStringField;
    qryPesquisaCarteiraPTEANumeroContato: TStringField;
    qryPesquisaCarteiraPTEACriadoEm: TSQLTimeStampField;
    qryPesquisaCarteiraPTEAAlteradoEm: TSQLTimeStampField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    private
      ServiceConnection: TServiceConnection;
    public
      function ListAll: TFDQuery;
      function Append(const AJson: TJSONObject): Boolean;
      procedure Delete(AId: integer);
      function Update(const AJson: TJSONObject; AId: integer): Boolean;
      function UpdateAField(const AField: string; AValue: Variant; AId: integer): Boolean;
      function GetById(const AId: string): TFDQuery;
      function GetAFieldById(const AField: string; const AId: string): string;
      function GetByFieldValue(const AField: string; const AValue: string): TFDQuery;
      procedure ConnectionConfig;

  end;

implementation

uses
  DataSet.Serialize,
  System.DateUtils;

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}
{ TServiceCarteiraPTEA }

function TServiceCarteiraPTEA.Append(const AJson: TJSONObject): Boolean;
begin
  qryCadastroCarteiraPTEA.SQL.Add('where 1<>1');
  qryCadastroCarteiraPTEA.Open();
  qryCadastroCarteiraPTEA.LoadFromJSON(AJson, False);
  Result := qryCadastroCarteiraPTEA.ApplyUpdates(0) = 0;
end;

procedure TServiceCarteiraPTEA.ConnectionConfig;
begin
  ServiceConnection := TServiceConnection.Create(Self);

  qryCadastroCarteiraPTEA.Connection := ServiceConnection.FDConnection;
  qryPesquisaCarteiraPTEA.Connection := ServiceConnection.FDConnection;

  qryCadastroCarteiraPTEA.Active := True;
  qryPesquisaCarteiraPTEA.Active := True;
end;

procedure TServiceCarteiraPTEA.DataModuleCreate(Sender: TObject);
begin
  Self.ConnectionConfig;
end;

procedure TServiceCarteiraPTEA.DataModuleDestroy(Sender: TObject);
begin
  ServiceConnection.Destroy;
end;

procedure TServiceCarteiraPTEA.Delete(AId: integer);
begin
  qryCadastroCarteiraPTEA.SQL.Clear;
  qryCadastroCarteiraPTEA.SQL.Add('DELETE FROM CARTEIRAPTEA WHERE ID = :ID');
  qryCadastroCarteiraPTEA.ParamByName('ID').Value := AId;
  qryCadastroCarteiraPTEA.ExecSQL;
end;

function TServiceCarteiraPTEA.GetAFieldById(const AField: string; const AId: string): string;
begin
  qryPesquisaCarteiraPTEA.SQL.Clear;
  qryPesquisaCarteiraPTEA.SQL.Add('select * from carteiraptea where id = :id');
  qryPesquisaCarteiraPTEA.ParamByName('id').AsInteger := AId.ToInteger;
  qryPesquisaCarteiraPTEA.Open();
  Result := qryPesquisaCarteiraPTEA.FieldByName(AField).AsString;
end;

function TServiceCarteiraPTEA.GetByFieldValue(const AField: string; const AValue: string): TFDQuery;
begin
  qryPesquisaCarteiraPTEA.SQL.Clear;
  qryPesquisaCarteiraPTEA.SQL.Add('select * from carteiraptea where ' + AField + ' = ' + AValue);
  qryPesquisaCarteiraPTEA.Open;
  Result := qryPesquisaCarteiraPTEA;
end;

function TServiceCarteiraPTEA.GetById(const AId: string): TFDQuery;
begin
  qryPesquisaCarteiraPTEA.SQL.Add('where id = :id');
  qryPesquisaCarteiraPTEA.ParamByName('id').AsInteger := AId.ToInteger;
  qryPesquisaCarteiraPTEA.Open();
  Result := qryPesquisaCarteiraPTEA;
end;

function TServiceCarteiraPTEA.ListAll: TFDQuery;
begin
  qryPesquisaCarteiraPTEA.Open();
  Result := qryPesquisaCarteiraPTEA;
end;

function TServiceCarteiraPTEA.Update(const AJson: TJSONObject; AId: integer): Boolean;
begin
  qryCadastroCarteiraPTEA.Close;
  qryCadastroCarteiraPTEA.SQL.Add('where id = :id');
  qryCadastroCarteiraPTEA.ParamByName('ID').Value := AId;
  qryCadastroCarteiraPTEA.Open();
  qryCadastroCarteiraPTEA.MergeFromJSONObject(AJson, False);
  Result := qryCadastroCarteiraPTEA.ApplyUpdates(0) = 0;
end;

function TServiceCarteiraPTEA.UpdateAField(const AField: string; AValue: Variant; AId: integer): Boolean;
begin
  qryCadastroCarteiraPTEA.Close;
  qryCadastroCarteiraPTEA.SQL.Clear;
  qryCadastroCarteiraPTEA.SQL.Add('select * from carteiraptea where id = :id');
  qryCadastroCarteiraPTEA.ParamByName('ID').Value := AId;
  qryCadastroCarteiraPTEA.Open();
  qryCadastroCarteiraPTEA.Edit;
  qryCadastroCarteiraPTEA.FieldByName(AField).AsVariant := AValue;
  qryCadastroCarteiraPTEAAlteradoEm.AsDateTime := Now;

  Result := qryCadastroCarteiraPTEA.ApplyUpdates(0) = 0;
end;

end.
