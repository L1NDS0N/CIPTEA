unit Pages.Config;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
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
  FMX.Ani;

type
  TPageConfig = class(TForm, iRouter4dcomponent)
    rect_novousuario: TRectangle;
    HorzScrollBox: THorzScrollBox;
    lytModal: TLayout;
    Line1: TLine;
    ShadowEffect1: TShadowEffect;
    rect_modal: TRectangle;
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
    procedure rect_novousuarioClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure rect_atualizarusuarioClick(Sender: TObject);
    procedure rect_excluircacheClick(Sender: TObject);
    private
      { Private declarations }
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
  FMX.DialogService;

{$R *.fmx}
{ TPageConfig }

procedure TPageConfig.btnVoltarClick(Sender: TObject);
begin
  try
    TRouter4D.Link.&To('Dashboard');
  except
    on E: Exception do
      TToastMessage.show('Erro durante navega��o para a p�gina principal - ' + E.Message, ttDanger);
  end;
end;

procedure TPageConfig.rect_atualizarusuarioClick(Sender: TObject);
begin
  try
    OpenPrivateRoute('NewUser', TProps.create.PropString('edit').Key('IdUserToUpdate'));
  except
    on E: Exception do
      TToastMessage.show('Erro durante navega��o para a p�gina de edi��o de usu�rio - ' + E.Message, ttDanger);
  end;
end;

procedure TPageConfig.rect_excluircacheClick(Sender: TObject);
var
  LService: TServiceCard;
begin
  LService := TServiceCard.create(nil);
  try
    try
      TDialogService.MessageDialog
        ('Tem certeza que deseja limpar os arquivos em cache? Ser� necess�rio logar novamente ap�s a opera��o.',
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

                  TToastMessage.show((qryUsuarioLocal.RowsAffected + qryArquivosCarteiraPTEA.RowsAffected).ToString +
                      ' Registros de cache limpos no aplicativo ');

                  TRouter4D.Link.&To('Login');
                end;
            end;
        end);
    except
      on E: Exception do
        TToastMessage.show('Erro durante exclus�o de cache do aplicativo ' + E.Message, ttDanger);
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
      TToastMessage.show('Erro durante navega��o para a p�gina de novo usu�rio - ' + E.Message, ttDanger);
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
