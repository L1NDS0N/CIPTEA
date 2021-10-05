unit Pages.Dashboard;

interface

uses
  Services.Card,
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
  FMX.Effects,
  FMX.Edit,
  FMX.ComboEdit,
  Router4D.Props;

type
  TPageDashboard = class(TForm, iRouter4DComponent)
    lytDashboard: TLayout;
    lytHeader: TLayout;
    Label1: TLabel;
    vsbCarteiras: TVertScrollBox;
    retBtnNew: TRectangle;
    lblNovo: TLabel;
    ColorAnimation1: TColorAnimation;
    ShadowEffect1: TShadowEffect;
    lytTitle: TLayout;
    lytSearchBox: TLayout;
    ComboEdit: TComboEdit;
    rectSearchBox: TRoundRect;
    Line2: TLine;
    rectLupa: TRoundRect;
    Path1: TPath;
    FloatAnimation1: TFloatAnimation;
    ColorAnimation2: TColorAnimation;
    SpeedButton1: TSpeedButton;
    ShadowEffect4: TShadowEffect;
    procedure retBtnNewClick(Sender: TObject);
    procedure ComboEditClick(Sender: TObject);
    procedure ComboEditTyping(Sender: TObject);
    procedure rectLupaClick(Sender: TObject);
    procedure ComboEditChangeTracking(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    private
      LServiceCard: TServiceCard;
      procedure OnDeleteCarteira(const ASender: TFrame; const AId: string);
      procedure OnUpdateCarteira(const ASender: TFrame; const AId: string);
      procedure OnPrintCarteira(const ASender: TFrame; const AId: string);
      procedure NavegarPara(const ALocation: string; const AProps: TProps = nil);

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
  Providers.PrivateRoute,
  Frames.DashboardDetail,
  Pages.Update,
  ToastMessage,
  Data.DB;

function TPageDashboard.Render: TFMXObject;
begin
  Result := lytDashboard;
  LServiceCard := TServiceCard.Create(self);
  self.ListarCarteiras;
end;

procedure TPageDashboard.UnRender;
begin
  LServiceCard.Free;
end;

procedure TPageDashboard.ComboEditChangeTracking(Sender: TObject);
begin
  ComboEdit.OnTyping(nil);
end;

procedure TPageDashboard.ComboEditClick(Sender: TObject);
begin
  ComboEdit.SelectAll;
  ComboEdit.DropDown;
end;

procedure TPageDashboard.ComboEditTyping(Sender: TObject);
begin
  FloatAnimation1.Start;
  with LServiceCard do
    begin
      mtPesquisaCarteiraPTEA.Filtered := false;
      mtPesquisaCarteiraPTEA.FilterOptions := [foCaseInsensitive];

      mtPesquisaCarteiraPTEA.Filter := 'NomeTitular like ' + QuotedStr('%' + ComboEdit.Text + '%') +
        'or CpfTitular like' + QuotedStr('%' + ComboEdit.Text + '%');
      mtPesquisaCarteiraPTEA.Filtered := true;
      ListarCarteiras;
      mtPesquisaCarteiraPTEA.Filtered := false;
    end;
end;

procedure TPageDashboard.ListarCarteiras;
var
  LFrame: TFrameDashboardDetail;
  I: Integer;
  LStream: TStream;
begin

  vsbCarteiras.BeginUpdate;
  try
    try
      for I := Pred(vsbCarteiras.Content.ControlsCount) downto 0 do
        vsbCarteiras.Content.Controls[I].DisposeOf;

      LServiceCard.Listar;
      LServiceCard.GetFiles;
      ComboEdit.Clear;

      LServiceCard.mtPesquisaCarteiraPTEA.First;
      while not LServiceCard.mtPesquisaCarteiraPTEA.Eof do
        begin
          LFrame := TFrameDashboardDetail.Create(vsbCarteiras);
          LFrame.Parent := vsbCarteiras;
          LFrame.Align := TAlignLayout.Top;
          LFrame.Position.x := vsbCarteiras.Content.ControlsCount * LFrame.Height;

          LFrame.Id := LServiceCard.mtPesquisaCarteiraPTEAid.AsString;
          LFrame.Name := LFrame.ClassName + LServiceCard.mtPesquisaCarteiraPTEAid.AsString;
          LFrame.lblNomeTitular.Text := LServiceCard.mtPesquisaCarteiraPTEANomeTitular.AsString;
          LFrame.lblCPFTitular.Text := LServiceCard.mtPesquisaCarteiraPTEACpfTitular.AsString;
          LFrame.lblID.Text := '#' + LServiceCard.mtPesquisaCarteiraPTEAid.AsString;

          LStream := LServiceCard.GetImageStreamById(LServiceCard.mtPesquisaCarteiraPTEAid.Value);
          if LStream.Size > 0 then
            LFrame.Imagem.Bitmap.LoadFromStream(LStream);

          LFrame.OnDelete := self.OnDeleteCarteira;
          LFrame.OnUpdate := self.OnUpdateCarteira;
          LFrame.OnPrint := self.OnPrintCarteira;

          ComboEdit.Items.Add(LServiceCard.mtPesquisaCarteiraPTEANomeTitular.AsString);
          LServiceCard.mtPesquisaCarteiraPTEA.Next;
        end;
    except
      on E: Exception do
        TToastMessage.show(E.Message, ttDanger);
    end;
  finally
    vsbCarteiras.EndUpdate;
    LStream.Free;
  end;

end;

procedure TPageDashboard.NavegarPara(const ALocation: string; const AProps: TProps);
begin
  try
    OpenPrivateRoute(ALocation, AProps);
  except
    on E: Exception do
      TToastMessage.show(E.Message, ttDanger);
  end;
end;

procedure TPageDashboard.OnDeleteCarteira(const ASender: TFrame; const AId: string);
var
  LService: TServiceCard;
begin
  try
    try
      LService := TServiceCard.Create(nil);
      TDialogService.MessageDialog('Tem certeza que deseja deletar?', TMsgDlgType.mtConfirmation, FMX.Dialogs.mbYesNo,
        TMsgDlgBtn.mbNo, 0,
          procedure(const AResult: TModalResult)
        begin
          if AResult <> mrYes then
            TToastMessage.show('Deleção da carteirinha #' + AId + ' cancelada.')
          else
            begin
              LService.Delete(AId);
              ASender.DisposeOf;
              TToastMessage.show('Carteirinha #' + AId + ' deletada com sucesso!', ttSuccess);
            end;
        end);
    finally
      LService.Free;
    end;
  except
    on E: Exception do
      TToastMessage.show('Erro durante deleção - ' + E.Message, ttDanger);
  end;
end;

procedure TPageDashboard.OnPrintCarteira(const ASender: TFrame; const AId: string);
begin
  NavegarPara('Print', TProps.Create.PropString(AId).Key('IdCarteiraToPrintFromDashboard'));
end;

procedure TPageDashboard.OnUpdateCarteira(const ASender: TFrame; const AId: string);
begin
  NavegarPara('Update', TProps.Create.PropString(AId).Key('IdCarteiraToUpdate'));
end;

procedure TPageDashboard.rectLupaClick(Sender: TObject);
begin
  ComboEdit.OnTyping(nil);
end;

procedure TPageDashboard.retBtnNewClick(Sender: TObject);
begin
  NavegarPara('New');
end;

procedure TPageDashboard.SpeedButton1Click(Sender: TObject);
begin
  ComboEdit.Text := EmptyStr;
end;

end.
