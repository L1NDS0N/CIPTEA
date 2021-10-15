unit Pages.Config;

interface

uses
  System.Types,
  System.UITypes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts,
  FMX.Objects,
  FMX.Effects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  Router4D.Interfaces,
  FMX.Ani,
  Configs.GLOBAL,
  System.Classes;

type
  TPageConfig = class(TForm, iRouter4dcomponent)
    rect_novousuario: TRectangle;
    HorzScrollBox: THorzScrollBox;
    Line1: TLine;
    ShadowEffect1: TShadowEffect;
    IconUser: TPath;
    lblNovoUsuario: TLabel;
    lytPageConfig: TLayout;
    ColorAnimation1: TColorAnimation;
    rect_atualizarusuario: TRectangle;
    Line2: TLine;
    IconAtualizarUsuario: TPath;
    ShadowEffect3: TShadowEffect;
    lblAtualizarUsuario: TLabel;
    ColorAnimation2: TColorAnimation;
    lytHeader: TLayout;
    Label1: TLabel;
    btnVoltar: TRectangle;
    ColorAnimation3: TColorAnimation;
    ColorAnimation4: TColorAnimation;
    rect_configlocal: TRectangle;
    Line3: TLine;
    Path1: TPath;
    ShadowEffect2: TShadowEffect;
    Label2: TLabel;
    ColorAnimation5: TColorAnimation;
    FloatAnimation1: TFloatAnimation;
    FloatAnimation2: TFloatAnimation;
    FloatAnimation3: TFloatAnimation;
    FloatAnimation4: TFloatAnimation;
    iconVoltar: TPath;
    rect_excluircache: TRectangle;
    Line4: TLine;
    Path2: TPath;
    ShadowEffect4: TShadowEffect;
    Label3: TLabel;
    ColorAnimation6: TColorAnimation;
    FloatAnimation5: TFloatAnimation;
    rect_downloaddb: TRectangle;
    Line5: TLine;
    Path3: TPath;
    ShadowEffect5: TShadowEffect;
    Label4: TLabel;
    ColorAnimation7: TColorAnimation;
    FloatAnimation6: TFloatAnimation;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    rect_efetuarlogin: TRectangle;
    Line6: TLine;
    Path4: TPath;
    ShadowEffect6: TShadowEffect;
    Label9: TLabel;
    ColorAnimation8: TColorAnimation;
    FloatAnimation7: TFloatAnimation;
    procedure rect_novousuarioClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure rect_atualizarusuarioClick(Sender: TObject);
    procedure rect_excluircacheClick(Sender: TObject);
    procedure rect_configlocalClick(Sender: TObject);
    procedure rect_downloaddbClick(Sender: TObject);
    procedure rect_efetuarloginClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    private
      Config: TConfigGlobal;
      procedure RemoverDBExcedente;
    public
      function Render: TFmxObject;
      procedure Unrender;
  end;

var
  PageConfig: TPageConfig;

implementation

uses
  Router4D.Props,
  Providers.PrivateRoute,
  ToastMessage,
  Router4D,
  Services.Card,
  FMX.DialogService,
  Services.User,
  System.SysUtils;

{$R *.fmx}
{ TPageConfig }

procedure TPageConfig.btnVoltarClick(Sender: TObject);
begin
  try
    TRouter4D.Link.&To('Dashboard');
  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para a página principal - ' + E.Message, ttDanger);
  end;
end;

procedure TPageConfig.Button1Click(Sender: TObject);
begin
  RemoverDBExcedente;
end;

procedure TPageConfig.rect_atualizarusuarioClick(Sender: TObject);
begin
  try
    OpenPrivateRoute('NewUser', TProps.create.PropString('edit').Key('IdUserToUpdate'));
  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para a página de edição de usuário - ' + E.Message, ttDanger);
  end;
end;

procedure TPageConfig.rect_configlocalClick(Sender: TObject);
begin
  try
    TRouter4D.Link.&To('NetConfig');

  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para página de configurações locais' + E.Message, ttDanger);
  end;
end;

procedure TPageConfig.rect_downloaddbClick(Sender: TObject);
var
  LService: TServiceUser;
begin
  LService := TServiceUser.create(nil);

  try
    try
      TDialogService.MessageDialog
        ('Tem certeza que deseja baixar um novo banco de dados local? Será necessário fechar o aplicativo e logar novamente após a operação.',
        TMsgDlgType.mtConfirmation, FMX.Dialogs.mbYesNo, TMsgDlgBtn.mbNo, 0,
          procedure(const AResult: TModalResult)
        begin
          if AResult <> mrYes then
            TToastMessage.show('Download do banco de dados cancelado.')
          else
            begin
              LService.DownloadDatabase;
              rect_excluircache.Enabled := false;
              TToastMessage.show
                ('O novo banco de dados local foi baixado, feche e abra o aplicativo para que as alterações tenham efeito',
                ttWarning);
            end;
        end);

    except
      on E: Exception do
        TToastMessage.show('Erro durante download do banco de dados ' + E.Message, ttDanger);
    end;
  finally
    LService.Free;
  end;
end;

procedure TPageConfig.rect_efetuarloginClick(Sender: TObject);
begin
  TRouter4D.Link.&To('Login');
end;

procedure TPageConfig.rect_excluircacheClick(Sender: TObject);
var
  LService: TServiceCard;
begin
  LService := TServiceCard.create(nil);
  try
    try
      TDialogService.MessageDialog
        ('Tem certeza que deseja limpar os arquivos em cache? Será necessário logar novamente após a operação.',
        TMsgDlgType.mtConfirmation, FMX.Dialogs.mbYesNo, TMsgDlgBtn.mbNo, 0,
        procedure(const AResult: TModalResult)
        begin
          if AResult <> mrYes then
            TToastMessage.show('Limpeza de cache cancelada.')
          else
            begin
              with LService do
                begin
                  qryArquivosCarteiraPTEA.SQL.Clear;
                  qryArquivosCarteiraPTEA.SQL.Add('DELETE FROM ArquivosCarteiraPTEA');
                  qryArquivosCarteiraPTEA.ExecSQL;

                  qryUsuarioLocal.SQL.Clear;
                  qryUsuarioLocal.SQL.Add('delete from usuario');
                  qryUsuarioLocal.ExecSQL;

                  qryUsuarioLocal.SQL.Clear;
                  qryUsuarioLocal.SQL.Add('VACUUM');
                  qryUsuarioLocal.ExecSQL;

                  Self.RemoverDBExcedente;

                  TToastMessage.show((qryUsuarioLocal.RowsAffected + qryArquivosCarteiraPTEA.RowsAffected).ToString +
                      ' Registros de cache limpos no aplicativo ');

                  TRouter4D.Link.&To('Login');
                end;
            end;
        end);
    except
      on E: Exception do
        TToastMessage.show('Erro durante exclusão de cache do aplicativo ' + E.Message, ttDanger);
    end;
  finally
    LService.Free;

  end;
end;

procedure TPageConfig.rect_novousuarioClick(Sender: TObject);
begin
  try
    OpenPrivateRoute('NewUser');
  except
    on E: Exception do
      TToastMessage.show('Erro durante navegação para a página de novo usuário - ' + E.Message, ttDanger);
  end;
end;

procedure TPageConfig.RemoverDBExcedente;
Var
  Path: String;
  SR: TSearchRec;
begin
  Path := ExtractFilePath(Config.DBDir);
  if FindFirst(Path + '*.db3', faArchive, SR) = 0 then
    begin
      repeat
        if Config.DBDir <> (Path + SR.Name) then
          DeleteFile(Path + SR.Name);
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
end;

function TPageConfig.Render: TFmxObject;
begin
  Result := lytPageConfig;
end;

procedure TPageConfig.Unrender;
begin

end;

end.
