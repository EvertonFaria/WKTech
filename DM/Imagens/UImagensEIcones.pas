unit UImagensEIcones;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection;

type
  TdtmImagensEIcones = class(TDataModule)
    imcIcones: TImageCollection;
    vilIcones: TVirtualImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmImagensEIcones: TdtmImagensEIcones;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
