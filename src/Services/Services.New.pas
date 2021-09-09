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
    mtPesquisaCarteiraPTEAid: TIntegerField;
    mtCadastroCarteiraPTEAid: TIntegerField;
    mtPesquisaCarteiraPTEAIfNoneMatch: TStringField;
    mtCadastroCarteiraPTEALaudoMedicoPath: TStringField;
    mtPesquisaCarteiraPTEAFotoStream: TBlobField;
    qryArquivosCarteiraPTEA: TFDQuery;
    qryArquivosCarteiraPTEAIDCarteira: TIntegerField;
    qryArquivosCarteiraPTEAFotoStream: TBlobField;
    qryArquivosCarteiraPTEADocStream: TBlobField;
    qryArquivosCarteiraPTEAIfNoneMatch: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    private const
      baseURL = 'http://localhost:9000';
    public
      procedure Salvar;
      procedure Listar;
      procedure Delete(const AId: string);
      procedure GetById(const AId: string);
      procedure StreamFiles;
      procedure GetFiles;
      function GetFilesById(const AId: integer): TStream;
  end;

var
  ServiceNew: TServiceNew;

implementation

uses
  Services.Connection,
  DataSet.Serialize,
  RESTRequest4D,
  FMX.Dialogs,
  Pages.Dashboard,
  REST.Types;

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}
{ TDataModule1 }

procedure TServiceNew.DataModuleCreate(Sender: TObject);
var
  Connection: TServiceConnection;
begin
  mtPesquisaCarteiraPTEA.Open;
  mtCadastroCarteiraPTEA.Open;

  Connection := TServiceConnection.Create(Self);
  qryArquivosCarteiraPTEA.Connection := Connection.LocalConnection;
end;

procedure TServiceNew.Delete(const AId: string);
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New.baseURL(baseURL).Resource('carteiras').ResourceSuffix(AId).Delete;
  if not(LResponse.StatusCode = 204) then
    raise Exception.Create(LResponse.JSONValue.GetValue<string>('error'))
  else
    begin
      qryArquivosCarteiraPTEA.Close;
      qryArquivosCarteiraPTEA.ParamByName('IDCARTEIRA').Value := AId;
      qryArquivosCarteiraPTEA.Open;
      qryArquivosCarteiraPTEA.Delete;
    end;
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

  //try
  //LResponse := TRequest.New.baseURL(baseURL).Resource('carteiras')
  //.ResourceSuffix(mtPesquisaCarteiraPTEAid.AsString + '/static/foto').Get;
  //
  //
  //mtArquivosCarteiraPTEA.Open;
  //mtCadastroCarteiraPTEAFotoStream mtCadastroCarteiraPTEA.Edit;
  //finally
  //
  //end;

end;

procedure TServiceNew.GetFiles;
var
  LResponse: IResponse;
begin
  //implementar ETag
  mtPesquisaCarteiraPTEA.Open;
  mtPesquisaCarteiraPTEA.First;
  while not(mtPesquisaCarteiraPTEA.Eof) do
    begin
      //2 situações com 2 variantes
      //se a qry estiver vazia, pode não haver foto ainda ou pode estar desatualizado
      //se a qry não estiver vazia, pode estar desatualizada e pra isso precisa checar o etag da foto
      qryArquivosCarteiraPTEA.Close;
      qryArquivosCarteiraPTEA.ParamByName('IDCarteira').Value := mtPesquisaCarteiraPTEAid.Value;
      qryArquivosCarteiraPTEA.Open;

      if qryArquivosCarteiraPTEA.IsEmpty then
        begin
          LResponse := TRequest.New.baseURL(baseURL).Resource('carteiras')
            .ResourceSuffix(mtPesquisaCarteiraPTEAid.AsString + '/static/foto').Get;
          qryArquivosCarteiraPTEA.Append;
          qryArquivosCarteiraPTEAIDCarteira.Value := mtPesquisaCarteiraPTEAid.Value;
          qryArquivosCarteiraPTEAFotoStream.LoadFromStream(LResponse.ContentStream);
          qryArquivosCarteiraPTEA.Post;
        end
      else
        begin
          LResponse := TRequest.New.baseURL(baseURL).Resource('carteiras')
            .ResourceSuffix(mtPesquisaCarteiraPTEAid.AsString + '/etag/foto')
            .AddHeader('If-None-Match', qryArquivosCarteiraPTEAIfNoneMatch.Value).Get;
          qryArquivosCarteiraPTEA.Edit;
          qryArquivosCarteiraPTEAIfNoneMatch.Value := LResponse.Headers.Values['ETag'];
          qryArquivosCarteiraPTEA.Post;

          if (LResponse.StatusCode in [200]) then
            begin
              LResponse := TRequest.New.baseURL(baseURL).Resource('carteiras')
                .ResourceSuffix(mtPesquisaCarteiraPTEAid.AsString + '/static/foto').Get;
              qryArquivosCarteiraPTEA.Edit;
              qryArquivosCarteiraPTEAFotoStream.LoadFromStream(LResponse.ContentStream);
              qryArquivosCarteiraPTEA.Post;
            end
          else if (LResponse.StatusCode = 304) then
            mtPesquisaCarteiraPTEA.Next
          else
            ShowMessage('Erro durante o download das imagens. ' + LResponse.JSONValue.GetValue<string>('error'));
        end;

      mtPesquisaCarteiraPTEA.Next;

    end;
end;

function TServiceNew.GetFilesById(const AId: integer): TStream;
begin
  Result := TMemoryStream.Create;
  qryArquivosCarteiraPTEA.Close;
  qryArquivosCarteiraPTEA.ParamByName('IDCARTEIRA').Value := AId.ToString;
  qryArquivosCarteiraPTEA.Open;
  qryArquivosCarteiraPTEAFotoStream.SaveToStream(Result);
  Result.Position := 0;
end;

procedure TServiceNew.Listar;
var
  LResponse: IResponse;
begin
  try
    mtPesquisaCarteiraPTEA.First;
    LResponse := TRequest.New.baseURL(baseURL).Resource('carteiras').AddHeader('Accept-Encoding', 'gzip')
      .AddHeader('If-None-Match', mtPesquisaCarteiraPTEAIfNoneMatch.Value).Get;
    if LResponse.StatusCode = 200 then
      mtPesquisaCarteiraPTEA.LoadFromJSON(LResponse.JSONValue.ToJSON);
  finally
    mtPesquisaCarteiraPTEA.First;
    mtPesquisaCarteiraPTEAIfNoneMatch.Value := LResponse.Headers.Values['ETag'];
  end;

  if not(LResponse.StatusCode = 200) and not(LResponse.StatusCode = 304) then
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

procedure TServiceNew.StreamFiles;
var
  LStreamFoto, LStreamDoc: TFileStream;
  LResponse: IResponse;
  LResponse2: IResponse;
begin
  try
    //TThread.CreateAnonymousThread(
    //procedure
    //begin
    if not(mtCadastroCarteiraPTEAfotoRostoPath.Value = EmptyStr) then
      begin
        LStreamFoto := TFileStream.Create(mtCadastroCarteiraPTEAfotoRostoPath.Value, fmOpenRead);
        LResponse := TRequest.New.baseURL(baseURL).Resource('carteiras')
          .ResourceSuffix(mtCadastroCarteiraPTEAid.AsString + '/static/foto').ContentType('application/octet-stream')
          .AddBody(LStreamFoto, false).Put;
        if not(LResponse.StatusCode in [200, 201, 204]) then
          raise Exception.Create(LResponse.JSONValue.GetValue<string>('error'));
        ShowMessage('Status: ' + IntToStr(LResponse.StatusCode) + 'Message: ' + LResponse.Content);
      end;
    //end);
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
  //TThread.CreateAnonymousThread(
  //procedure
  //begin
  //LResponse2 := TRequest.New.baseURL(baseURL).Resource('carteiras').ResourceSuffix(mtCadastroCarteiraPTEAid.AsString
  //+ '/static/doc').ContentType('application/octet-stream').AddBody(LStreamDoc, false).Put;
  // //if not(LResponse.StatusCode in [200, 201, 204]) then
  // //raise Exception.Create(LResponse.JSONValue.GetValue<string>('error'));
  //ShowMessage('Status: ' + IntToStr(LResponse2.StatusCode) + 'Message: ' + LResponse2.Content);
  //end);
end;

end.
