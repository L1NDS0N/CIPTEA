unit ToastMessage;

interface

uses
  System.SysUtils,
  System.UITypes,
  System.Classes,
  System.DateUtils,
  FMX.Ani,
  FMX.Types,
  FMX.Forms,
  FMX.Layouts,
  FMX.DialogService,
  FMX.Dialogs,
  FMX.Objects;

type
  TToastPosition = (tpTop, tpBottom);
  TTypeToast = (ttInfo, ttDanger, ttWarning, ttSuccess);
  TMyColor = type Cardinal;

  TMyColorRec = record
    const
      Alpha = TMyColor($FF000000);
      CINZAESCURO_HEXDISC = TMyColor($FF202225);
      CINZAMEDIO_HEXDISC = TMyColor($FF2F3136);
      CINZACLARO_HEXDISC = TMyColor($FF36393F);
      CINZAESCUROTEXTO_HEXDISC = TMyColor($FF878B88);
      CINZAMEDIOTEXTO_HEXDISC = TMyColor($FFBBB4B2);
      BRANCOTEXTO_HEXDISC = TMyColor($FFFFFFFF);
      VERDEESCURO_HEXDISC = TMyColor($378D54);
      VERDEMEDIO_HEXDISC = TMyColor($FF3BA55D);
      VERMELHOMEDIO_HEXDISC = TMyColor($FFED4245);
      CINZAICONES_HEXDISC = TMyColor($FFB8BABD);
      LARANJAESCURO_HEX = TMyColor($FFF9A820);
  end;

  TToastMessage = class
    published
      class procedure show(text: String; Second: Integer = 3; Height: Integer = 41;
        ToastType: TTypeToast = TTypeToast.ttInfo; position: TToastPosition = TToastPosition.tpTop);
  end;

implementation

Var
  lyContainer: TLayout;
  lyBorder: TRectangle;
  flAnimation: TFloatAnimation;
  txMessage: TText;
  { TToastMessage }

class procedure TToastMessage.show(text: String; Second: Integer = 3; Height: Integer = 41;
  ToastType: TTypeToast = TTypeToast.ttInfo; position: TToastPosition = TToastPosition.tpTop);
Var
  TextCollor: TMyColor;
  BalloonCollor: TMyColor;
  thr: TThread;
  newName: string;
  timeNow, timeFinish: TTime;
  last: TLayout;
begin

  if ToastType = TTypeToast.ttInfo then
    begin
      TextCollor := TMyColorRec.CINZAICONES_HEXDISC;
      BalloonCollor := TMyColorRec.CINZACLARO_HEXDISC;
    end
  else if ToastType = TTypeToast.ttDanger then
    begin
      TextCollor := TMyColorRec.BRANCOTEXTO_HEXDISC;
      BalloonCollor := TMyColorRec.VERMELHOMEDIO_HEXDISC;
    end
  else if ToastType = TTypeToast.ttSuccess then
    begin
      TextCollor := TMyColorRec.BRANCOTEXTO_HEXDISC;
      BalloonCollor := TMyColorRec.VERDEMEDIO_HEXDISC;
    end
  else if ToastType = TTypeToast.ttWarning then
    begin
      TextCollor := TMyColorRec.BRANCOTEXTO_HEXDISC;
      BalloonCollor := TMyColorRec.LARANJAESCURO_HEX;
    end;

  if (screen.ActiveForm <> nil) then
    begin
      //HIDE CONTROLS IF EXISTS
      if (assigned(lyBorder)) then
        lyBorder.Visible := false;
      if (assigned(lyContainer)) then
        lyContainer.Visible := false;

      //CREATE NOTIFICATION
      if not assigned(lyContainer) then
        lyContainer := TLayout.Create(screen.ActiveForm);
      lyContainer.Parent := screen.ActiveForm;
      lyContainer.Width := (screen.ActiveForm.ClientWidth * 80) / 100;
      lyContainer.Height := Height;
      lyContainer.Align := TAlignLayout.Scale;
      lyContainer.position.X := (screen.ActiveForm.ClientWidth * 10) / 100;
      lyContainer.Tag := 0; { 0 = ABRINDO NOVA MENSAGEM | 1 = AINDA EM EXECUCAO }

      if (position = TToastPosition.tpTop) then
        lyContainer.position.Y := 9
      else if (position = TToastPosition.tpBottom) then
        lyContainer.position.Y := screen.ActiveForm.ClientHeight - lyContainer.Height - 9;

      lyContainer.Visible := true;
      if not(assigned(lyBorder)) then
        lyBorder := TRectangle.Create(lyContainer);
      lyBorder.Parent := lyContainer;
      lyBorder.Align := TAlignLayout.Center;
      lyBorder.Stroke.Thickness := 0.1;
      lyBorder.XRadius := 5;
      lyBorder.YRadius := 5;
      lyBorder.Stroke.Color := TAlphaColorRec.White;
      lyBorder.fill.Color := BalloonCollor;
      lyBorder.Height := lyContainer.Height;
      lyBorder.Visible := true;

      if not(assigned(flAnimation)) then
        flAnimation := TFloatAnimation.Create(lyBorder);
      flAnimation.Enabled := false;
      flAnimation.Inverse := false;
      flAnimation.Parent := lyBorder;
      flAnimation.AnimationType := TAnimationType.InOut;
      flAnimation.Interpolation := TInterpolationType.Exponential;
      flAnimation.PropertyName := 'Width';
      flAnimation.Duration := 0.5;
      flAnimation.StartValue := 40;
      flAnimation.StopValue := lyContainer.Width - 10;
      flAnimation.Start;

      if not(assigned(txMessage)) then
        txMessage := TText.Create(lyBorder);
      txMessage.Visible := false;
      txMessage.Parent := lyBorder;
      txMessage.Align := TAlignLayout.Client;
      txMessage.TextSettings.FontColor := TextCollor;
      txMessage.TextSettings.Font.Size := 14;
      txMessage.TextSettings.Font.Style := [];
      txMessage.TextSettings.WordWrap := true;
      txMessage.text := text;

      thr := TThread.CreateAnonymousThread(
          procedure
        begin
          Sleep(300);
          TThread.Synchronize(nil,
              procedure
            begin
              txMessage.Visible := true;
            end);

          timeNow := time;
          timeFinish := time;
          timeFinish := IncSecond(timeFinish, Second);
          lyContainer.Tag := 1;
          while (timeFinish >= timeNow) and (lyContainer.Tag = 1) do
            begin
              Sleep(100);
              timeNow := time;
            end;

          if (lyContainer.Tag = 1) then { SÓ FINALIZA O COMPONENTE SE NÃO FOI SOBREPOSTO POR OUTRA MENSAGEM }
            begin
              TThread.Synchronize(nil,
                procedure
                begin
                  flAnimation.Inverse := true;
                  flAnimation.Start;
                  txMessage.Visible := false;
                end);

              Sleep(350);
              TThread.Synchronize(nil,
                procedure
                begin
                  lyContainer.Visible := false;
                end);
            end;
        end);
      thr.FreeOnTerminate := true;
      thr.Start;
    end
  else
    MessageDlg(text, TMsgDlgType.mtwarning, [TMsgDlgBtn.mbok], 0);
end;

end.
