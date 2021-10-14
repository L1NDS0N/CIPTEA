unit Pages.Dashboard;

interface

uses
  Services.Card,
  System.Threading,
  Router4D.Interfaces,
  System.SysUtils,
  FMX.DialogService,
  FMX.Dialogs,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  Router4D.Props,
  System.Types,
  FireDAC.Comp.Client,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Ani,
  FMX.Effects,
  FMX.Edit,
  FMX.ComboEdit,
  FMX.Layouts;

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
    procedure vsbCarteirasViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
    procedure ComboEditChange(Sender: TObject);
    private
      LServiceCard: TServiceCard;
      procedure OnDeleteCarteira(const ASender: TFrame; const AId: string);
      procedure OnUpdateCarteira(const ASender: TFrame; const AId: string);
      procedure OnPrintCarteira(const ASender: TFrame; const AId: string);
      procedure NavegarPara(const ALocation: string; const AProps: TProps = nil);
      procedure ListarCarteiras;
      procedure ListagemFiltrada(AFilter: string);
      procedure RelistarCarteiras;
      procedure RenderizarCarteiras(AQuery: TFDMemTable);
    public
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
  ToastMessage;

procedure TPageDashboard.RelistarCarteiras;
begin
  try
    RenderizarCarteiras(LServiceCard.mtPesquisaCarteiraPTEA);
  except
    on E: Exception do
      TToastMessage.show(E.Message, ttDanger);
  end;
end;

procedure TPageDashboard.ListagemFiltrada(AFilter: string);
begin
  TTask.Run(
      procedure
    begin
      TThread.Synchronize(TThread.Current,
          procedure
        begin
          try
            if LServiceCard.Filtrar(AFilter) then
              begin
                RenderizarCarteiras(LServiceCard.mtFiltrarCarteiraPTEA);
              end;
          except
            on E: Exception do
              TToastMessage.show(E.Message, ttDanger);
          end;
        end);
    end);
end;

procedure TPageDashboard.ListarCarteiras;
begin
  TTask.Run(
    procedure
    begin
      TThread.Synchronize(TThread.Current,
          procedure
        begin
          try
            if LServiceCard.ListarPagina then
              begin
                RenderizarCarteiras(LServiceCard.mtPesquisaCarteiraPTEA);
              end;
          except
            on E: Exception do
              TToastMessage.show(E.Message, ttDanger);
          end;
        end);
    end);
end;

function TPageDashboard.Render: TFMXObject;
begin
  Result := lytDashboard;

  LServiceCard := TServiceCard.Create(self);
  if LServiceCard.mtPesquisaCarteiraPTEA.IsEmpty then
    ListarCarteiras
  else
    RelistarCarteiras;

end;

procedure TPageDashboard.RenderizarCarteiras(AQuery: TFDMemTable);
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

      ComboEdit.Clear;
      LServiceCard.GetFiles;

      AQuery.First;
      while not AQuery.Eof do
        begin
          LFrame := TFrameDashboardDetail.Create(vsbCarteiras);
          LFrame.Parent := vsbCarteiras;
          LFrame.Align := TAlignLayout.Top;
          LFrame.Position.x := vsbCarteiras.Content.ControlsCount * LFrame.Height;

          LFrame.Id := AQuery.fieldbyname('id').AsString;
          LFrame.Name := LFrame.ClassName + AQuery.fieldbyname('id').AsString;
          LFrame.lblNomeTitular.Text := AQuery.fieldbyname('NomeTitular').AsString;
          LFrame.lblCPFTitular.Text := AQuery.fieldbyname('CpfTitular').AsString;
          LFrame.lblID.Text := '#' + AQuery.fieldbyname('id').AsString;
          LFrame.lblCipteaID.Text := AQuery.fieldbyname('cipteaid').AsString;

          LStream := LServiceCard.GetImageStreamById(AQuery.fieldbyname('id').Value);
          if LStream.Size > 0 then
            LFrame.Imagem.Bitmap.LoadFromStream(LStream);

          LFrame.OnDelete := self.OnDeleteCarteira;
          LFrame.OnUpdate := self.OnUpdateCarteira;
          LFrame.OnPrint := self.OnPrintCarteira;

          ComboEdit.Items.Add(AQuery.fieldbyname('NomeTitular').AsString);
          AQuery.Next;
        end;

    except
      on E: Exception do
        Exception.Create(E.Message);
    end;
  finally
    vsbCarteiras.EndUpdate;
    LStream := nil;
  end;

end;

procedure TPageDashboard.UnRender;
begin
  LServiceCard.Free;
end;

procedure TPageDashboard.vsbCarteirasViewportPositionChange(Sender: TObject;
const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
begin
  with vsbCarteiras do
    begin
      if (NewViewportPosition.Y) >= ((ContentBounds.Height - Height) / 1.2) then
        begin
          ListarCarteiras;
        end;
    end;
end;

procedure TPageDashboard.ComboEditChange(Sender: TObject);
begin
  if ComboEdit.Text <> EmptyStr then
    ListagemFiltrada(ComboEdit.Text);
end;

procedure TPageDashboard.ComboEditChangeTracking(Sender: TObject);
begin
  if ComboEdit.Text = EmptyStr then
    RelistarCarteiras;
end;

procedure TPageDashboard.ComboEditClick(Sender: TObject);
begin
  ComboEdit.SelectAll;
  ComboEdit.DropDown;
end;

procedure TPageDashboard.ComboEditTyping(Sender: TObject);
begin
  try
    if not(FloatAnimation1.Running) then
      FloatAnimation1.Start;

    TTask.Run(
      procedure
      begin
        TThread.Synchronize(TThread.Current,
            procedure
          begin
            if ComboEdit.Text = EmptyStr then
              RelistarCarteiras
            else if LServiceCard.FiltrarNomes(ComboEdit.Text) then
              begin
                ComboEdit.Clear;
                LServiceCard.mtNomesFiltrados.First;
                while not(LServiceCard.mtNomesFiltrados.Eof) do
                  begin
                    ComboEdit.Items.Add(LServiceCard.mtNomesFiltradosnome.Value);
                    LServiceCard.mtNomesFiltrados.Next;
                  end;
                if not(ComboEdit.DroppedDown) then
                  ComboEdit.DropDown;
              end;
          end);
      end);
  except
    on E: Exception do
      TToastMessage.show(E.Message, ttDanger);
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
  ComboEditChange(nil);
end;

procedure TPageDashboard.retBtnNewClick(Sender: TObject);
begin
  NavegarPara('New');
end;

procedure TPageDashboard.SpeedButton1Click(Sender: TObject);
begin
  ComboEdit.Text := EmptyStr;
  RelistarCarteiras;
end;

end.
