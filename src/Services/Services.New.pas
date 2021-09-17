unit Services.New;

interface

uses
  Configs.GLOBAL,
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
    qryArquivosCarteiraPTEAhasDoc: TBooleanField;
    qryTemp: TFDQuery;
    qryTempid: TFDAutoIncField;
    qryTempFotoRostoPath: TStringField;
    qryTempLaudoMedicoPath: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    private
    var
      Config: TConfigGlobal;
    public
      procedure Salvar;
      procedure Listar;
      procedure Delete(const AId: string);
      procedure GetById(const AId: string);
      procedure PostStreamDoc;
      procedure PostStreamFoto(AId: string);
      procedure GetFiles;
      function GetImageStreamById(AId: integer): TStream;
      function GetFileById(AId: integer): TFDQuery;
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
  qryTemp.Connection := Connection.LocalConnection;
end;

procedure TServiceNew.Delete(const AId: string);
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras').ResourceSuffix(AId).Delete;
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
  LResponse := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras').ResourceSuffix(AId)
    .DataSetAdapter(mtCadastroCarteiraPTEA).Get;

  if not(LResponse.StatusCode = 200) then
    raise Exception.Create(LResponse.JSONValue.GetValue<string>('error'));
end;

function TServiceNew.GetFileById(AId: integer): TFDQuery;
begin
  qryArquivosCarteiraPTEA.Close;
  qryArquivosCarteiraPTEA.ParamByName('IDCARTEIRA').Value := AId.ToString;
  qryArquivosCarteiraPTEA.Open;
  Result := qryArquivosCarteiraPTEA;
end;

procedure TServiceNew.GetFiles;
var
  LResponse: IResponse;
  LResponseHasDoc: IResponse;
begin
  mtPesquisaCarteiraPTEA.Open;
  mtPesquisaCarteiraPTEA.First;
  while not(mtPesquisaCarteiraPTEA.Eof) do
    begin
      qryArquivosCarteiraPTEA.Close;
      qryArquivosCarteiraPTEA.ParamByName('IDCarteira').Value := mtPesquisaCarteiraPTEAid.Value;
      qryArquivosCarteiraPTEA.Open;

      LResponseHasDoc := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras')
        .ResourceSuffix(mtPesquisaCarteiraPTEAid.AsString + '/has/doc').Get;

      if qryArquivosCarteiraPTEA.IsEmpty then
        begin
          LResponse := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras')
            .ResourceSuffix(mtPesquisaCarteiraPTEAid.AsString + '/static/foto').Get;
          qryArquivosCarteiraPTEA.Append;
          qryArquivosCarteiraPTEAIDCarteira.Value := mtPesquisaCarteiraPTEAid.Value;
          qryArquivosCarteiraPTEAFotoStream.LoadFromStream(LResponse.ContentStream);
          if LResponseHasDoc.StatusCode = 200 then
            qryArquivosCarteiraPTEAhasDoc.Value := true
          else if LResponseHasDoc.StatusCode = 204 then
            qryArquivosCarteiraPTEAhasDoc.Value := false;
          qryArquivosCarteiraPTEA.Post;
        end
      else
        begin
          LResponse := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras')
            .ResourceSuffix(mtPesquisaCarteiraPTEAid.AsString + '/etag/foto')
            .AddHeader('If-None-Match', qryArquivosCarteiraPTEAIfNoneMatch.Value).Get;

          qryArquivosCarteiraPTEA.Edit;
          //etag
          qryArquivosCarteiraPTEAIfNoneMatch.Value := LResponse.Headers.Values['ETag'];
          //hasDoc
          if LResponseHasDoc.StatusCode = 200 then
            qryArquivosCarteiraPTEAhasDoc.Value := true
          else if LResponseHasDoc.StatusCode = 204 then
            qryArquivosCarteiraPTEAhasDoc.Value := false;
          qryArquivosCarteiraPTEA.Post;

          if (LResponse.StatusCode in [200]) then
            begin
              LResponse := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras')
                .ResourceSuffix(mtPesquisaCarteiraPTEAid.AsString + '/static/foto').Get;
              qryArquivosCarteiraPTEA.Edit;
              qryArquivosCarteiraPTEAFotoStream.LoadFromStream(LResponse.ContentStream);
              qryArquivosCarteiraPTEA.Post;
            end
          else if not(LResponse.StatusCode = 304) then
            showmessage('Erro durante o download das imagens. ' + LResponse.JSONValue.GetValue<string>('error'));
        end;

      mtPesquisaCarteiraPTEA.Next;
    end;
end;

function TServiceNew.GetImageStreamById(AId: integer): TStream;
begin
  Result := TMemoryStream.Create;
  qryArquivosCarteiraPTEA.Close;
  qryArquivosCarteiraPTEA.ParamByName('IDCARTEIRA').Value := AId.ToString;
  qryArquivosCarteiraPTEA.Open;
  if not(qryArquivosCarteiraPTEA.IsEmpty) then
    begin
      qryArquivosCarteiraPTEAFotoStream.SaveToStream(Result);
      Result.Position := 0;
    end
  else
    Result.DisposeOf;
end;

procedure TServiceNew.Listar;
var
  LResponse: IResponse;
begin
  try
    mtPesquisaCarteiraPTEA.First;
    LResponse := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras').AddHeader('Accept-Encoding', 'gzip')
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

procedure TServiceNew.PostStreamFoto(AId: string);
var
  LStreamFoto: TStream;
  LResponseFoto: IResponse;
begin
  try
    qryArquivosCarteiraPTEA.Close;
    qryArquivosCarteiraPTEA.ParamByName('IDCARTEIRA').Value := AId;
    qryArquivosCarteiraPTEA.Open;

    if not(qryArquivosCarteiraPTEA.IsEmpty) then
      if not(qryArquivosCarteiraPTEAFotoStream.IsNull) then
        begin
          LStreamFoto := TMemoryStream.Create;
          qryArquivosCarteiraPTEAFotoStream.SaveToStream(LStreamFoto);
          LStreamFoto.Position := 0;
          LResponseFoto := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras')
            .ResourceSuffix(AId + '/static/foto').ContentType('application/octet-stream')
            .AddBody(LStreamFoto, false).Put;

          if not(LResponseFoto.StatusCode in [200, 201, 204]) then
            raise Exception.Create(LResponseFoto.JSONValue.GetValue<string>('error'));
          //destruir a stream da foto
          if LResponseFoto.StatusCode > 0 then
            LStreamFoto.Free;
        end;
  except
    on E: Exception do
      showmessage('N�o foi poss�vel enviar a foto para o servidor. ' + E.Message);
  end;
end;

procedure TServiceNew.Salvar;
var
  LRequest: IRequest;
  LResponse: IResponse;
begin

  LRequest := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras').AddBody(mtCadastroCarteiraPTEA.ToJSONObject);
  if (mtCadastroCarteiraPTEAid.AsInteger > 0) then
    LResponse := LRequest.ResourceSuffix(mtCadastroCarteiraPTEAid.AsString).Put
  else
    LResponse := LRequest.Post;

  if not(LResponse.StatusCode in [200, 201, 204]) then
    raise Exception.Create(LResponse.JSONValue.GetValue<string>('error'));

  mtCadastroCarteiraPTEA.EmptyDataSet;
end;

procedure TServiceNew.PostStreamDoc;
var
  LStreamDoc: TFileStream;
  LResponseDoc: IResponse;
begin
  try
    if not(mtCadastroCarteiraPTEALaudoMedicoPath.IsNull) then
      begin
        LStreamDoc := TFileStream.Create(mtCadastroCarteiraPTEALaudoMedicoPath.Value, fmOpenRead);
        LResponseDoc := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras')
          .ResourceSuffix(mtCadastroCarteiraPTEAid.AsString + '/static/doc').ContentType('application/octet-stream')
          .AddBody(LStreamDoc, false).Put;

        if not(LResponseDoc.StatusCode in [200, 201, 204]) then
          raise Exception.Create(LResponseDoc.JSONValue.GetValue<string>('error'));

        if LResponseDoc.StatusCode > 0 then
          LStreamDoc.Free;
      end;
  except
    on E: Exception do
      showmessage('N�o foi poss�vel enviar o laudo para o servidor. '+E.Message);
  end;
end;

end.
