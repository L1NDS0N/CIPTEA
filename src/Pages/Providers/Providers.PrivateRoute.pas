unit Providers.PrivateRoute;

interface

uses
  System.Threading,
  Router4D.Props,
  Configs.GLOBAL;

function OpenPrivateRoute(ARoute: string): boolean; overload;
function OpenPrivateRoute(ARoute: string; AProps: TProps): boolean; overload;

implementation

uses
  Restrequest4d,
  Services.Connection,
  Router4D,
  FireDAC.Comp.Client,
  System.SysUtils,
  System.Classes;

var
  Config: TConfigGLobal;

function OpenPrivateRoute(ARoute: string): boolean; overload;
begin
  OpenPrivateRoute(ARoute, nil)
end;

function OpenPrivateRoute(ARoute: string; AProps: TProps): boolean; overload;
var
  ServiceConnection: TServiceConnection;
  qryConsultaUsuario: TFDQuery;
  LResponse: IResponse;
  LRequest: IRequest;
begin
  TTask.Run(
      procedure
    begin
      TThread.Synchronize(TThread.Current,
          procedure
        begin
          qryConsultaUsuario := TFDQuery.Create(nil);
          ServiceConnection := TServiceConnection.Create(nil);

          try
            try
              qryConsultaUsuario.Connection := ServiceConnection.LocalConnection;
              qryConsultaUsuario.SQL.Add('select token from usuario limit 1');
              qryConsultaUsuario.Open;

              if not(qryConsultaUsuario.IsEmpty) then
                begin
                  if not(qryConsultaUsuario.FieldByName('token').IsNull) then
                    begin
                      LRequest := TRequest.New.BaseURL(Config.BaseURL).Resource('healthcheck')
                        .TokenBearer(qryConsultaUsuario.FieldByName('token').AsString).RaiseExceptionOn500(true);

                      LResponse := LRequest.Get;
                      if LResponse.StatusCode = 204 then
                        begin
                          try
                            if AProps <> nil then
                              TRouter4D.Link.&To(ARoute, AProps)
                            else
                              TRouter4D.Link.&To(ARoute);
                          except
                            on E: Exception do
                              raise Exception.Create('Erro durante navegação para a página #' + ARoute + '. ' +
                                  E.Message);
                          end;

                        end
                      else if LResponse.StatusCode = 401 then
                        begin
                          try
                            TRouter4D.Link.&To('Login');
                          except
                            on E: Exception do
                              raise Exception.Create('Erro durante navegação para a página de login. ' + E.Message);
                          end;
                          raise Exception.Create
                            ('Não foi possível validar as suas credenciais de acesso. Suas credenciais expiraram ou são inválidas.');
                        end;
                    end
                  else
                    begin
                      try
                        TRouter4D.Link.&To('Login');
                      except
                        on E: Exception do
                          raise Exception.Create('Erro durante navegação para a página de login. ' + E.Message);
                      end;
                      raise Exception.Create('Não foi possível encontrar as suas credenciais de acesso.');
                    end;
                end
              else
                begin
                  try
                    TRouter4D.Link.&To('Login');
                  except
                    on E: Exception do
                      raise Exception.Create('Erro durante navegação para a página de login. ' + E.Message);
                  end;
                  raise Exception.Create
                    ('Não foi possível encontrar nenhuma credencial de acesso, por favor, efetue login.');
                end;

            except
              on E: Exception do
                raise Exception.Create(E.Message);
            end;
          finally
            qryConsultaUsuario.Free;
            ServiceConnection.Free;
          end;
        end);
    end);
end;

end.
