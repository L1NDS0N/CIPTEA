unit Services.Card;

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
  TServiceCard = class(TDataModule)
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
    qryUsuarioLocal: TFDQuery;
    qryUsuarioLocalid: TIntegerField;
    qryUsuarioLocalNome: TStringField;
    qryUsuarioLocalToken: TStringField;
    qryUsuarioLocalStayConected: TBooleanField;
    qryUsuarioLocalTokenCreatedAt: TIntegerField;
    qryUsuarioLocalTokenExpires: TIntegerField;
    mtPaginadorCarteiraPTEA: TFDMemTable;
    mtPaginadorCarteiraPTEAtotal: TIntegerField;
    mtPaginadorCarteiraPTEAlimit: TIntegerField;
    mtPaginadorCarteiraPTEApage: TIntegerField;
    mtPaginadorCarteiraPTEApages: TIntegerField;
    mtFiltrarCarteiraPTEA: TFDMemTable;
    mtFiltrarCarteiraPTEANomeResponsavel: TStringField;
    mtFiltrarCarteiraPTEACpfResponsavel: TStringField;
    mtFiltrarCarteiraPTEARgResponsavel: TStringField;
    mtFiltrarCarteiraPTEANomeTitular: TStringField;
    mtFiltrarCarteiraPTEACpfTitular: TStringField;
    mtFiltrarCarteiraPTEARgTitular: TStringField;
    mtFiltrarCarteiraPTEADataNascimento: TDateField;
    mtFiltrarCarteiraPTEAEmailContato: TStringField;
    mtFiltrarCarteiraPTEANumeroContato: TStringField;
    mtFiltrarCarteiraPTEACriadoEm: TSQLTimeStampField;
    mtFiltrarCarteiraPTEAAlteradoEm: TSQLTimeStampField;
    mtFiltrarCarteiraPTEAid: TIntegerField;
    mtFiltrarCarteiraPTEAFotoStream: TBlobField;
    mtFiltrarNomes: TFDMemTable;
    mtNomesFiltrados: TFDMemTable;
    mtFiltrarNomesnomes: TDataSetField;
    mtNomesFiltradosnome: TStringField;
    mtCadastroCarteiraPTEACipteaId: TStringField;
    mtPesquisaCarteiraPTEACipteaId: TStringField;
    mtFiltrarCarteiraPTEACipteaId: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    private
    var
      Config: TConfigGlobal;
    public
      procedure Salvar;
      procedure Listar;
      function ListarPagina: boolean;
      function Filtrar(AFilter: string): boolean;
      function FiltrarNomes(AFilter: string): boolean;
      procedure Delete(const AId: string);
      procedure GetById(const AId: string);
      procedure PostStreamDoc;
      procedure PostStreamFoto(AId: string);
      procedure GetFiles;
      function GetImageStreamById(AId: string): TStream;
      function GetFileById(AId: integer): TFDQuery;

  end;

var
  ServiceCard: TServiceCard;

implementation

uses
  Services.Connection,
  DataSet.Serialize,
  RESTRequest4D,
  System.JSON;

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}
{ TDataModule1 }

procedure TServiceCard.DataModuleCreate(Sender: TObject);
var
  Connection: TServiceConnection;
begin
  mtPesquisaCarteiraPTEA.Open;
  mtCadastroCarteiraPTEA.Open;

  Connection := TServiceConnection.Create(Self);
  qryArquivosCarteiraPTEA.Connection := Connection.LocalConnection;
  qryUsuarioLocal.Connection := Connection.LocalConnection;
end;

procedure TServiceCard.Delete(const AId: string);
var
  LResponse: IResponse;
begin
  try
    qryUsuarioLocal.Close;
    qryUsuarioLocal.Open;
    LResponse := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras').TokenBearer(qryUsuarioLocalToken.Value)
      .ResourceSuffix(AId).Delete;

    if LResponse.StatusCode = 204 then
      begin
        qryArquivosCarteiraPTEA.Close;
        qryArquivosCarteiraPTEA.ParamByName('IDCARTEIRA').Value := AId;
        qryArquivosCarteiraPTEA.Open;
        qryArquivosCarteiraPTEA.Delete;
      end
    else
      raise Exception.Create('Não foi possível deletar os dados da carteirinha #' + AId + '. Erro #' +
          LResponse.StatusCode.ToString + ' - ' + LResponse.JSONValue.GetValue<string>('error'));
  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;
end;

function TServiceCard.Filtrar(AFilter: string): boolean;
var
  LResponse: IResponse;
begin
  Result := false;
  try
    try
      qryUsuarioLocal.Close;
      qryUsuarioLocal.Open;

      LResponse := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras').ResourceSuffix('filter')
        .DataSetAdapter(mtFiltrarCarteiraPTEA).AddParam('value', AFilter).AddHeader('Accept-Encoding', 'gzip')
        .TokenBearer(qryUsuarioLocalToken.Value).Get;

    finally
      if LResponse.StatusCode = 200 then
        Result := true
      else if LResponse.StatusCode = 204 then
        begin
          raise Exception.Create('Valor não encontrado no servidor');
        end
      else if LResponse.StatusCode = 401 then
        raise Exception.Create('Atualmente você não possui autorização para listar os dados.')
      else if not(LResponse.StatusCode = 200) and not(LResponse.StatusCode = 304) then
        raise Exception.Create('Não foi possível listar os dados - Erro #' + LResponse.StatusCode.ToString + ', ' +
            LResponse.JSONValue.GetValue<string>('error'));
    end;
  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;
end;

function TServiceCard.FiltrarNomes(AFilter: string): boolean;
var
  LResponse: IResponse;
begin
  Result := false;
  try
    try
      if AFilter = EmptyStr then
        abort;
      qryUsuarioLocal.Close;
      qryUsuarioLocal.Open;

      LResponse := TRequest.New.BaseURL(Config.BaseURL).Resource('nomes').ResourceSuffix('filter')
        .DataSetAdapter(mtFiltrarNomes).AddParam('value', AFilter).AddHeader('Accept-Encoding', 'gzip')
        .TokenBearer(qryUsuarioLocalToken.Value).Get;

    finally
      if LResponse.StatusCode = 200 then
        Result := true
      else if LResponse.StatusCode = 204 then
        begin
          raise Exception.Create('Nome para filtrar não encontrado no banco de dados');
        end
      else if LResponse.StatusCode = 401 then
        raise Exception.Create('Atualmente você não possui autorização para listar os dados.')
      else if not(LResponse.StatusCode = 200) and not(LResponse.StatusCode = 304) then
        raise Exception.Create('Não foi possível listar os dados - Erro #' + LResponse.StatusCode.ToString + ', ' +
            LResponse.JSONValue.GetValue<string>('error'));
    end;
  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;

end;

procedure TServiceCard.GetById(const AId: string);
var
  LResponse: IResponse;
begin
  try
    try
      qryUsuarioLocal.Close;
      qryUsuarioLocal.Open;
      mtCadastroCarteiraPTEA.EmptyDataSet;
      LResponse := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras').ResourceSuffix(AId)
        .TokenBearer(qryUsuarioLocalToken.Value).DataSetAdapter(mtCadastroCarteiraPTEA).Get;
    finally
      if LResponse.StatusCode = 401 then
        raise Exception.Create('Atualmente você não possui autorização para efetuar esta operação.')
      else if not(LResponse.StatusCode = 200) then
        raise Exception.Create('Não foi possível obter os dados da carteirinha #' + AId + '. Erro #' +
            LResponse.StatusCode.ToString + ' - ' + LResponse.JSONValue.GetValue<string>('error'));
    end;
  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;
end;

function TServiceCard.GetFileById(AId: integer): TFDQuery;
begin
  try
    qryArquivosCarteiraPTEA.Close;
    qryArquivosCarteiraPTEA.ParamByName('IDCARTEIRA').Value := AId.ToString;
    qryArquivosCarteiraPTEA.Open;
    Result := qryArquivosCarteiraPTEA;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure TServiceCard.GetFiles;
var
  LResponse: IResponse;
  LResponseHasDoc: IResponse;
begin
  try
    qryUsuarioLocal.Close;
    qryUsuarioLocal.Open;
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
              .TokenBearer(qryUsuarioLocalToken.Value)
              .ResourceSuffix(mtPesquisaCarteiraPTEAid.AsString + '/static/foto').Get;

            qryArquivosCarteiraPTEA.Append;
            qryArquivosCarteiraPTEAIDCarteira.Value := mtPesquisaCarteiraPTEAid.Value;
            qryArquivosCarteiraPTEAFotoStream.LoadFromStream(LResponse.ContentStream);

            if LResponseHasDoc.StatusCode = 200 then
              qryArquivosCarteiraPTEAhasDoc.Value := true
            else if LResponseHasDoc.StatusCode = 204 then
              qryArquivosCarteiraPTEAhasDoc.Value := false;
            qryArquivosCarteiraPTEA.post;
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
            qryArquivosCarteiraPTEA.post;

            if (LResponse.StatusCode in [200]) then
              begin
                LResponse := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras')
                  .TokenBearer(qryUsuarioLocalToken.Value)
                  .ResourceSuffix(mtPesquisaCarteiraPTEAid.AsString + '/static/foto').Get;
                qryArquivosCarteiraPTEA.Edit;
                qryArquivosCarteiraPTEAFotoStream.LoadFromStream(LResponse.ContentStream);
                qryArquivosCarteiraPTEA.post;
              end
            else if not(LResponse.StatusCode = 304) then
              raise Exception.Create('Não foi possível efetuar o download das imagens - Erro #' +
                  LResponse.StatusCode.ToString + ', ' + LResponse.JSONValue.GetValue<string>('error'));

          end;

        mtPesquisaCarteiraPTEA.Next;
      end;
  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;
end;

function TServiceCard.GetImageStreamById(AId: string): TStream;
begin
  try
    Result := TMemoryStream.Create;
    qryArquivosCarteiraPTEA.Close;
    qryArquivosCarteiraPTEA.ParamByName('IDCARTEIRA').Value := AId;
    qryArquivosCarteiraPTEA.Open;
    if not(qryArquivosCarteiraPTEA.IsEmpty) then
      begin
        qryArquivosCarteiraPTEAFotoStream.SaveToStream(Result);
        Result.Position := 0;
      end
    else
      Result.DisposeOf;
  except
    on E: Exception do
      begin
        raise Exception.Create('Erro durante obtenção da imagem #' + AId + ' - ' + E.Message);
      end;
  end;
end;

procedure TServiceCard.Listar;
var
  LResponse: IResponse;
begin
  try
    try
      qryUsuarioLocal.Close;
      qryUsuarioLocal.Open;
      //caso único, para obter o valor do Etag já armazenado
      mtPesquisaCarteiraPTEA.First;
      LResponse := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras').AddHeader('Accept-Encoding', 'gzip')
        .TokenBearer(qryUsuarioLocalToken.Value).DataSetAdapter(mtPesquisaCarteiraPTEA)
        .AddHeader('If-None-Match', mtPesquisaCarteiraPTEAIfNoneMatch.Value).Get;

    finally
      mtPesquisaCarteiraPTEA.First;
      mtPesquisaCarteiraPTEAIfNoneMatch.Value := LResponse.Headers.Values['ETag'];

      if LResponse.StatusCode = 401 then
        raise Exception.Create('Atualmente você não possui autorização para listar os dados.')
      else if not(LResponse.StatusCode = 200) and not(LResponse.StatusCode = 304) then
        raise Exception.Create('Não foi possível listar os dados - Erro #' + LResponse.StatusCode.ToString + ', ' +
            LResponse.JSONValue.GetValue<string>('error'));
    end;
  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;
end;

procedure TServiceCard.PostStreamFoto(AId: string);
var
  LStreamFoto: TStream;
  LResponseFoto: IResponse;
begin
  try
    try
      qryArquivosCarteiraPTEA.Close;
      qryArquivosCarteiraPTEA.ParamByName('IDCARTEIRA').Value := AId;
      qryArquivosCarteiraPTEA.Open;

      qryUsuarioLocal.Close;
      qryUsuarioLocal.Open;

      if not(qryArquivosCarteiraPTEA.IsEmpty) then
        if not(qryArquivosCarteiraPTEAFotoStream.IsNull) then
          begin
            LStreamFoto := TMemoryStream.Create;
            qryArquivosCarteiraPTEAFotoStream.SaveToStream(LStreamFoto);
            LStreamFoto.Position := 0;
            LResponseFoto := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras')
              .TokenBearer(qryUsuarioLocalToken.Value).ResourceSuffix(AId + '/static/foto')
              .ContentType('application/octet-stream').addbody(LStreamFoto, false).Put;
          end;
    finally
      if LResponseFoto.StatusCode = 401 then
        raise Exception.Create('Atualmente você não possui autorização para gravar imagens.')
      else if not(LResponseFoto.StatusCode in [200, 201, 204]) then
        raise Exception.Create('Erro durante gravação da foto ' + AId + ' no servidor - Erro #' +
            LResponseFoto.StatusCode.ToString + ', ' + LResponseFoto.JSONValue.GetValue<string>('error'));

      if LResponseFoto.StatusCode > 0 then
        LStreamFoto.Free;
    end;
  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;
end;

procedure TServiceCard.Salvar;
var
  LRequest: IRequest;
  LResponse: IResponse;
  idResponse: integer;
begin
  try
    try
      qryUsuarioLocal.Close;
      qryUsuarioLocal.Open;

      LRequest := TRequest.New.BaseURL(Config.BaseURL).TokenBearer(qryUsuarioLocalToken.Value).Resource('carteiras')
        .addbody(mtCadastroCarteiraPTEA.ToJSONObject);
      if (mtCadastroCarteiraPTEAid.AsInteger > 0) then
        LResponse := LRequest.ResourceSuffix(mtCadastroCarteiraPTEAid.AsString).Put
      else
        LResponse := LRequest.post;
    finally
      if LResponse.StatusCode in [200, 201, 204] then
        begin
          if not(mtCadastroCarteiraPTEAid.AsInteger > 0) then
            if LResponse.JSONValue.TryGetValue('id', idResponse) then
              begin
                mtCadastroCarteiraPTEA.Edit;
                mtCadastroCarteiraPTEAid.Value := idResponse;
              end;
        end
      else if LResponse.StatusCode = 401 then
        raise Exception.Create('Atualmente você não possui autorização para gravar os dados.')
      else
        raise Exception.Create(LResponse.JSONValue.GetValue<string>('error'));
    end;
  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;
end;

function TServiceCard.ListarPagina: boolean;
var
  LResponse: IResponse;
begin
  try
    if (mtPaginadorCarteiraPTEApage.Value > 0) AND
      (mtPaginadorCarteiraPTEApage.Value = mtPaginadorCarteiraPTEApages.Value) then
      begin
        Result := false;
        exit;
      end
    else
      begin
        qryUsuarioLocal.Close;
        qryUsuarioLocal.Open;

        LResponse := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras').AddHeader('Accept-Encoding', 'gzip')
          .AddParam('limit', '5').AddParam('page', (mtPaginadorCarteiraPTEApage.Value + 1).ToString)
          .TokenBearer(qryUsuarioLocalToken.Value).AddHeader('X-Paginate', 'true').Get;

        if LResponse.StatusCode in [200, 201, 204] then
          begin
            Result := true;
            mtPaginadorCarteiraPTEA.LoadFromJSON(LResponse.JSONValue.ToJSON);
            mtPesquisaCarteiraPTEA.LoadFromJSON(LResponse.JSONValue.GetValue<TJSONArray>('docs').ToJSON);
          end;

        if LResponse.StatusCode = 401 then
          raise Exception.Create('Atualmente você não possui autorização para listar os dados.')
        else if not(LResponse.StatusCode = 200) and not(LResponse.StatusCode = 304) then
          raise Exception.Create('Não foi possível listar os dados - Erro #' + LResponse.StatusCode.ToString + ', ' +
              LResponse.JSONValue.GetValue<string>('error'));
      end;

  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;

end;

procedure TServiceCard.PostStreamDoc;
var
  LStreamDoc: TFileStream;
  LResponseDoc: IResponse;
begin
  try
    qryUsuarioLocal.Close;
    qryUsuarioLocal.Open;
    if not(mtCadastroCarteiraPTEALaudoMedicoPath.IsNull) then
      begin
        LStreamDoc := TFileStream.Create(mtCadastroCarteiraPTEALaudoMedicoPath.Value, fmOpenRead);
        LResponseDoc := TRequest.New.BaseURL(Config.BaseURL).Resource('carteiras')
          .TokenBearer(qryUsuarioLocalToken.Value).ResourceSuffix(mtCadastroCarteiraPTEAid.AsString + '/static/doc')
          .ContentType('application/octet-stream').addbody(LStreamDoc, false).Put;

        if LResponseDoc.StatusCode = 401 then
          raise Exception.Create('Atualmente você não possui autorização para gravar laudos.')
        else if not(LResponseDoc.StatusCode in [200, 201, 204]) then
          raise Exception.Create('Erro durante gravação do laudo ' + mtCadastroCarteiraPTEAid.AsString +
              ' no servidor - Erro #' + LResponseDoc.StatusCode.ToString + ', ' +
              LResponseDoc.JSONValue.GetValue<string>('error'));

        if LResponseDoc.StatusCode > 0 then
          LStreamDoc.Free;
      end;
  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;
end;

end.
