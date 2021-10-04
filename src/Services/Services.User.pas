unit Services.User;

interface

uses
  Services.Connection,
  System.SysUtils,
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
  System.JSON;

type
  TServiceUser = class(TDataModule)
    qryCadastroUsuario: TFDQuery;
    qryPesquisaUsuario: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    private
      ServiceConnection: TServiceConnection;
    public
      function Append(const AJson: TJSONObject): Boolean;
      function GetByFieldValue(AField: string; AValue: string): TFDQuery;
      function Update(const AJson: TJSONObject; AId: integer): Boolean;
  end;

implementation

uses
  DataSet.Serialize;

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

procedure TServiceUser.DataModuleCreate(Sender: TObject);
begin
  ServiceConnection := TServiceConnection.Create(Self);

  qryCadastroUsuario.Connection := ServiceConnection.FDConnection;
  qryPesquisaUsuario.Connection := ServiceConnection.FDConnection;

  qryCadastroUsuario.Active := True;
  qryPesquisaUsuario.Active := True;
end;

function TServiceUser.Append(const AJson: TJSONObject): Boolean;
begin
  qryCadastroUsuario.SQL.Add('where 1<>1');
  qryCadastroUsuario.Open();
  qryCadastroUsuario.LoadFromJSON(AJson, False);
  Result := qryCadastroUsuario.ApplyUpdates(0) = 0;
end;

function TServiceUser.GetByFieldValue(AField: string; AValue: string): TFDQuery;
begin
  qryPesquisaUsuario.SQL.Clear;
  qryPesquisaUsuario.SQL.Add('select * from usuario where ' + AField + ' = ' + QuotedStr(AValue));
  qryPesquisaUsuario.Open;
  Result := qryPesquisaUsuario;
end;

function TServiceUser.Update(const AJson: TJSONObject; AId: integer): Boolean;
begin
  qryCadastroUsuario.Close;
  qryCadastroUsuario.SQL.Add('where id = :id');
  qryCadastroUsuario.ParamByName('ID').Value := AId;
  qryCadastroUsuario.Open();
  qryCadastroUsuario.MergeFromJSONObject(AJson, False);
  Result := qryCadastroUsuario.ApplyUpdates(0) = 0;
end;

end.
