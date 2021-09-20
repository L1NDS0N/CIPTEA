unit Pages.Dashboard;

interface

uses
  Services.New,
  Router4D.Interfaces,
  System.SysUtils,
  System.Types,
  FMX.DialogService,
  FMX.Dialogs,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  System.Rtti,
  FMX.Grid.Style,
  FMX.ScrollBox,
  FMX.Grid,
  Data.DB,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  FMX.Bind.Grid,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.Components,
  Data.Bind.Grid,
  Data.Bind.DBScope,
  FMX.ListBox,
  FMX.Memo,
  FMX.TabControl,
  FMX.Objects,
  FMX.Ani,
  FMX.Effects;

type
  TPageDashboard = class(TForm, iRouter4DComponent)
    lytDashboard: TLayout;
    Layout1: TLayout;
    Label1: TLabel;
    vsbCarteiras: TVertScrollBox;
    retBtnNew: TRectangle;
    lblNovo: TLabel;
    ColorAnimation1: TColorAnimation;
    ShadowEffect1: TShadowEffect;
    procedure retBtnNewClick(Sender: TObject);
    private
      procedure OnDeleteCarteira(const ASender: TFrame; const AId: string);
      procedure OnUpdateCarteira(const ASender: TFrame; const AId: string);
      procedure OnPrintCarteira(const ASender: TFrame; const AId: string);
    public
      procedure ListarCarteiras;
      function Render: TFMXObject;
      procedure UnRender;

  end;

var
  PageDashboard: TPageDashboard;

implementation

{$R *.fmx}

{ TfrmDashboard }
uses
  Router4D,
  Frames.DashboardDetail,
  Pages.Update,
  Router4D.Props,
  ToastMessage;

procedure TPageDashboard.ListarCarteiras;
var
  serviceNew: TServiceNew;
  LFrame: TFrameDashboardDetail;
  I: Integer;
  LStream: TStream;
begin
  serviceNew := TServiceNew.Create(Self);
  vsbCarteiras.BeginUpdate;
  try
    try
      for I := Pred(vsbCarteiras.Content.ControlsCount) downto 0 do
        vsbCarteiras.Content.Controls[I].DisposeOf;

      serviceNew.Listar;
      serviceNew.GetFiles;

      serviceNew.mtPesquisaCarteiraPTEA.First;
      while not serviceNew.mtPesquisaCarteiraPTEA.Eof do
        begin
          LFrame := TFrameDashboardDetail.Create(vsbCarteiras);
          LFrame.Parent := vsbCarteiras;
          LFrame.Align := TAlignLayout.Top;
          LFrame.Position.x := vsbCarteiras.Content.ControlsCount * LFrame.Height;

          LFrame.Id := serviceNew.mtPesquisaCarteiraPTEAid.AsString;
          LFrame.Name := LFrame.ClassName + serviceNew.mtPesquisaCarteiraPTEAid.AsString;
          LFrame.lblNomeTitular.Text := serviceNew.mtPesquisaCarteiraPTEANomeTitular.AsString;
          LFrame.lblCPFTitular.Text := serviceNew.mtPesquisaCarteiraPTEACpfTitular.AsString;
          LFrame.lblID.Text := '#' + serviceNew.mtPesquisaCarteiraPTEAid.AsString;

          LStream := serviceNew.GetImageStreamById(serviceNew.mtPesquisaCarteiraPTEAid.Value);
          if LStream.Size > 0 then
            LFrame.Imagem.Bitmap.LoadFromStream(LStream);

          LFrame.OnDelete := Self.OnDeleteCarteira;
          LFrame.OnUpdate := Self.OnUpdateCarteira;
          LFrame.OnPrint := Self.OnPrintCarteira;
          serviceNew.mtPesquisaCarteiraPTEA.Next;
        end;
    finally
      vsbCarteiras.EndUpdate;
      serviceNew.Free;
    end;
  except
    on E: Exception do
      TToastMessage.show(E.Message, ttDanger);
  end;

end;

procedure TPageDashboard.OnDeleteCarteira(const ASender: TFrame; const AId: string);
var
  serviceNew: TServiceNew;
begin
  try
    try
      serviceNew := TServiceNew.Create(nil);
      TDialogService.MessageDialog('Tem certeza que deseja deletar?', TMsgDlgType.mtConfirmation, FMX.Dialogs.mbYesNo,
        TMsgDlgBtn.mbNo, 0,
          procedure(const AResult: TModalResult)
        begin
          if AResult <> mrYes then
            TToastMessage.show('Dele��o da carteirinha #' + AId + ' cancelada.')
          else
            begin
              serviceNew.Delete(AId);
              ASender.DisposeOf;
              TToastMessage.show('Carteirinha #' + AId + ' deletada com sucesso!', ttSuccess);
            end;
        end);
    finally
      serviceNew.Free;
    end;
  except
    on E: Exception do
      TToastMessage.show('Erro durante dele��o - ' + E.Message, ttDanger);
  end;
end;

procedure TPageDashboard.OnPrintCarteira(const ASender: TFrame; const AId: string);
begin
  try
    TRouter4D.Link.&To('Print', TProps.Create.PropString(AId).Key('IdCarteiraToPrint'));
  except
    on E: Exception do
      begin
        TToastMessage.show('Erro durante navega��o para p�gina de impress�o - ' + E.Message, ttDanger);
      end;
  end;
end;

procedure TPageDashboard.OnUpdateCarteira(const ASender: TFrame; const AId: string);
begin
  try
    TRouter4D.Link.&To('Update', TProps.Create.PropString(AId).Key('IdCarteiraToUpdate'));
  except
    on E: Exception do
      begin
        TToastMessage.show('Erro durante navega��o para p�gina de edi��o - ' + E.Message, ttDanger);
      end;
  end;
end;

function TPageDashboard.Render: TFMXObject;
begin
  Result := lytDashboard;
  Self.ListarCarteiras;
end;

procedure TPageDashboard.retBtnNewClick(Sender: TObject);
begin
  try
    TRouter4D.Link.&To('New');
  except
    on E: Exception do
      TToastMessage.show('Erro durante navega��o para p�gina de nova carteira - ' + E.Message, ttDanger);
  end;
end;

procedure TPageDashboard.UnRender;
begin

end;

end.
