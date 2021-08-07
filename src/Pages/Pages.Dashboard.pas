unit Pages.Dashboard;

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
  Data.Bind.DBScope;

type
  TPageDashboard = class(TForm, iRouter4DComponent)
    lytDashboard: TLayout;
    Layout1: TLayout;
    btnNew: TButton;
    Label1: TLabel;
    Grid1: TGrid;
    DataSource: TDataSource;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure btnNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    private
      serviceNew: TServiceNew;
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
  Router4D;

procedure TPageDashboard.btnNewClick(Sender: TObject);
begin
  TRouter4D.Link.&To('New');
end;

procedure TPageDashboard.FormCreate(Sender: TObject);
begin
  ListarCarteiras;
end;

procedure TPageDashboard.ListarCarteiras;
begin
  if serviceNew <> nil then
    serviceNew.Free;

  serviceNew := Services.New.TServiceNew.Create(nil);
  serviceNew.Listar;
end;

function TPageDashboard.Render: TFMXObject;
begin
  Result := lytDashboard;
end;

procedure TPageDashboard.UnRender;
begin

end;

end.
