unit Pages.New;

interface

uses
  Services.New,
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
      serviceNew: TServiceNew;
      procedure listarCarteiras;
    public
      function Render: TFmxObject;
      procedure UnRender;
  end;

var
  PageNew: TPageNew;

implementation

uses
  Pages.Dashboard,
  Router4D;

{$R *.fmx}
{ TPageNew }

procedure TPageNew.btnSalvarClick(Sender: TObject);
begin
  try
    serviceNew := TServiceNew.Create(nil);
    try
      if (serviceNew.mtCadastroCarteiraPTEAid.AsInteger > 0) then
        serviceNew.mtCadastroCarteiraPTEA.Edit
      else
        serviceNew.mtCadastroCarteiraPTEA.Append;

      serviceNew.mtCadastroCarteiraPTEANomeResponsavel.AsString := edtNomeResponsavel.Text;
      serviceNew.mtCadastroCarteiraPTEADataNascimento.Value := edtDataNascimento.Date;
      serviceNew.mtCadastroCarteiraPTEACpfResponsavel.Value := edtCpfResponsavel.Text;
      serviceNew.mtCadastroCarteiraPTEANumeroContato.Value := edtNumeroContato.Text;
      serviceNew.mtCadastroCarteiraPTEARgResponsavel.Value := edtRgResponsavel.Text;
      serviceNew.mtCadastroCarteiraPTEAEmailContato.Value := edtEmailContato.Text;
      serviceNew.mtCadastroCarteiraPTEANomeTitular.Value := edtNomeTitular.Text;
      serviceNew.mtCadastroCarteiraPTEACpfTitular.Value := edtCpfTitular.Text;
      serviceNew.mtCadastroCarteiraPTEARgTitular.Value := edtRgTitular.Text;
      serviceNew.Salvar;
    except
      on E: Exception do
        raise Exception.Create('Error Message: ' + E.Message);
    end;
  finally
    serviceNew.Free;
    TRouter4D.Link.&To('Dashboard');
  end;

end;

procedure TPageNew.btnVoltarClick(Sender: TObject);
begin
  TRouter4D.Link.&To('Dashboard');
end;

procedure TPageNew.listarCarteiras;
var
  pageDashboard: TPageDashboard;
begin
  try
    pageDashboard := TPageDashboard.Create(nil);
    pageDashboard.listarCarteiras;
  finally
    pageDashboard.Free;
  end;

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
