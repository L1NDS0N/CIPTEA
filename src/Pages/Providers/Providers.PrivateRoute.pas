unit Providers.PrivateRoute;

interface

uses
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
  ToastMessage,
  System.SysUtils;

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
                      TToastMessage.show('Erro durante navegação para a página #' + ARoute + '. ' + E.Message,
                        ttDanger);
                  end;

                end
              else if LResponse.StatusCode = 401 then
                begin
                  TToastMessage.show
                    ('Não foi possível validar as suas credenciais de acesso. Suas credenciais expiraram ou são inválidas.',
                    ttWarning);
                  try
                    TRouter4D.Link.&To('Login');
                  except
                    on E: Exception do
                      TToastMessage.show('Erro durante navegação para a página de login. ' + E.Message, ttDanger);
                  end;
                end;
            end
          else
            begin
              TToastMessage.show('Não foi possível encontrar as suas credenciais de acesso.', ttWarning);
              try
                TRouter4D.Link.&To('Login');
              except
                on E: Exception do
                  TToastMessage.show('Erro durante navegação para a página de login. ' + E.Message, ttDanger);
              end;
            end;
        end
      else
        begin
          TToastMessage.show('Não foi possível encontrar nenhuma credencial de acesso, por favor, efetue login.',
            ttWarning);
          try
            TRouter4D.Link.&To('Login');
          except
            on E: Exception do
              TToastMessage.show('Erro durante navegação para a página de login. ' + E.Message, ttDanger);
          end;
        end;

    except
      on E: Exception do
        TToastMessage.show(E.Message, ttDanger);
    end;
  finally
    qryConsultaUsuario.Free;
    ServiceConnection.Free;
  end;
end;

end.
