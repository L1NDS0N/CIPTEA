unit Pages.New;

interface

uses
  Router4D.Interfaces,
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
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.DateTimeCtrls,
  FMX.Ani;

type
  TPageNew = class(TForm, iRouter4DComponent)
    lytNew: TLayout;
    btnSalvar: TButton;
    edtEmailContato: TEdit;
    lblemailContato: TLabel;
    lytInterno: TLayout;
    lblrgTitular: TLabel;
    edtNomeTitular: TEdit;
    lblcpfResponsavel: TLabel;
    edtCpfResponsavel: TEdit;
    lblRgResponsavel: TLabel;
    edtNomeResponsavel: TEdit;
    lblnomeTitular: TLabel;
    edtRgResponsavel: TEdit;
    lblnomeResponsavel: TLabel;
    edtCpfTitular: TEdit;
    lblcpfTitular: TLabel;
    edtRgTitular: TEdit;
    lbldataNascimento: TLabel;
    edtDataNascimento: TDateEdit;
    edtNumeroContato: TEdit;
    lblnumeroContato: TLabel;
    lytAnexos: TLayout;
    rctFotoRosto: TRectangle;
    rctLaudoMedico: TRectangle;
    dlgFotoRosto: TOpenDialog;
    dlgLaudoMedico: TOpenDialog;
    VertScrollBox: TVertScrollBox;
    lytHeader: TLayout;
    btnVoltar: TSpeedButton;
    FloatAnimation: TFloatAnimation;
    procedure btnSalvarClick(Sender: TObject);
    procedure rctFotoRostoClick(Sender: TObject);
    procedure rctLaudoMedicoClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    private
      { Private declarations }
    public
      function Render: TFmxObject;
      procedure UnRender;
  end;

var
  PageNew: TPageNew;

implementation

uses
  Router4D;

{$R *.fmx}
{ TPageNew }

procedure TPageNew.btnSalvarClick(Sender: TObject);
begin
  TRouter4D.Link.&To('Dashboard');
end;

procedure TPageNew.btnVoltarClick(Sender: TObject);
begin
  TRouter4D.Link.&To('Dashboard');
end;

procedure TPageNew.rctFotoRostoClick(Sender: TObject);
begin
  dlgFotoRosto.Execute;
end;

procedure TPageNew.rctLaudoMedicoClick(Sender: TObject);
begin
  dlgLaudoMedico.Execute;
end;

function TPageNew.Render: TFmxObject;
begin
  Result := lytNew;
end;

procedure TPageNew.UnRender;
begin
  //
end;

end.
