unit Services.New;

interface

uses
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
  FireDAC.Comp.Client;

type
  TServiceNew = class(TDataModule)
    mtPesquisaCarteiraPTEA: TFDMemTable;
    mtPesquisaCarteiraPTEAid: TFDAutoIncField;
    mtPesquisaCarteiraPTEANomeResponsavel: TStringField;
    mtPesquisaCarteiraPTEACpfResponsavel: TStringField;
    mtPesquisaCarteiraPTEARgResponsavel: TStringField;
    mtPesquisaCarteiraPTEANomeTitular: TStringField;
    mtPesquisaCarteiraPTEACpfTitular: TStringField;
    mtPesquisaCarteiraPTEARgTitular: TStringField;
    mtPesquisaCarteiraPTEADataNascimento: TDateField;
    mtPesquisaCarteiraPTEAfotoRostoPath: TStringField;
    mtPesquisaCarteiraPTEAEmailContato: TStringField;
    mtPesquisaCarteiraPTEANumeroContato: TStringField;
    mtPesquisaCarteiraPTEACriadoEm: TSQLTimeStampField;
    mtPesquisaCarteiraPTEAAlteradoEm: TSQLTimeStampField;
    mtCadastroCarteiraPTEA: TFDMemTable;
    mtCadastroCarteiraPTEAid: TFDAutoIncField;
    mtCadastroCarteiraPTEANomeResponsavel: TStringField;
    mtCadastroCarteiraPTEACpfResponsavel: TStringField;
    mtCadastroCarteiraPTEARgResponsavel: TStringField;
    mtCadastroCarteiraPTEANomeTitular: TStringField;
    mtCadastroCarteiraPTEACpfTitular: TStringField;
    mtCadastroCarteiraPTEARgTitular: TStringField;
    mtCadastroCarteiraPTEADataNascimento: TDateField;
    mtCadastroCarteiraPTEAfotoRostoPath: TStringField;
    mtCadastroCarteiraPTEAEmailContato: TStringField;
    mtCadastroCarteiraPTEANumeroContato: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    private const
      baseURL = 'http://localhost:9000';
    public
      procedure Salvar;
      procedure Listar;
      procedure Delete(const AId: string);
      procedure GetById(const AId: string);
  end;

implementation

uses
  DataSet.Serialize,
  RESTRequest4D;

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}
{ TDataModule1 }

procedure TServiceNew.DataModuleCreate(Sender: TObject);
begin
  mtPesquisaCarteiraPTEA.Active := true;
  mtCadastroCarteiraPTEA.Active := true;
end;

procedure TServiceNew.Delete(const AId: string);
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New.baseURL(baseURL).Resource('carteiras').ResourceSuffix(AId).Delete;
  if not(LResponse.StatusCode = 204) then
    raise Exception.Create(LResponse.JSONValue.GetValue<string>('error'));

end;

procedure TServiceNew.GetById(const AId: string);
var
  LResponse: IResponse;
begin
  mtCadastroCarteiraPTEA.EmptyDataSet;
  LResponse := TRequest.New.baseURL(baseURL).Resource('carteiras').ResourceSuffix(AId)
    .DataSetAdapter(mtCadastroCarteiraPTEA).Get;
  if not(LResponse.StatusCode = 200) then
    raise Exception.Create(LResponse.JSONValue.GetValue<string>('error'));

end;

procedure TServiceNew.Listar;
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New.baseURL(baseURL).Resource('carteiras').DataSetAdapter(mtPesquisaCarteiraPTEA).Get;
  if not(LResponse.StatusCode = 200) then
    raise Exception.Create(LResponse.JSONValue.GetValue<string>('error'));

end;

procedure TServiceNew.Salvar;
var
  LRequest: IRequest;
  LResponse: IResponse;
begin
  LRequest := TRequest.New.baseURL(baseURL).Resource('carteiras').AddBody(mtCadastroCarteiraPTEA.ToJSONObject);
  if (mtCadastroCarteiraPTEAid.AsInteger > 0) then
    LResponse := LRequest.ResourceSuffix(mtCadastroCarteiraPTEAid.AsString).Put
  else
    LResponse := LRequest.Post;
  if not(LResponse.StatusCode in [200, 201, 204]) then
    raise Exception.Create(LResponse.JSONValue.GetValue<string>('error'));
  mtCadastroCarteiraPTEA.EmptyDataSet;

end;

end.
