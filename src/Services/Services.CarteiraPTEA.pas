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
  FireDAC.Comp.Client;

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
    private
    public
      function ListAll: TFDQuery;
      function Append(const AJson: TJSONObject): Boolean;
      procedure Delete(AId: integer);
      function Update(const AJson: TJSONObject; AId: integer): Boolean;
      function GetById(const AId: string): TFDQuery;
  end;

var
  ServiceCarteiraPTEA: TServiceCarteiraPTEA;

implementation

uses
  DataSet.Serialize,
  Services.Connection;

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

procedure TServiceCarteiraPTEA.DataModuleCreate(Sender: TObject);
begin
  qryCadastroCarteiraPTEA.Active := True;
  qryPesquisaCarteiraPTEA.Active := True;
end;

procedure TServiceCarteiraPTEA.Delete(AId: integer);
begin
  qryCadastroCarteiraPTEA.SQL.Clear;
  qryCadastroCarteiraPTEA.SQL.Add('DELETE FROM CARTEIRAPTEA WHERE ID = :ID');
  qryCadastroCarteiraPTEA.ParamByName('ID').Value := AId;
  qryCadastroCarteiraPTEA.ExecSQL;
end;

function TServiceCarteiraPTEA.GetById(const AId: string): TFDQuery;
begin
  qryCadastroCarteiraPTEA.SQL.Add('where id = :id');
  qryCadastroCarteiraPTEA.ParamByName('id').AsInteger := AId.ToInteger;
  qryCadastroCarteiraPTEA.Open();
  Result := qryCadastroCarteiraPTEA;
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

end.
