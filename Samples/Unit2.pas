unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frxClass, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    frxReport1: TfrxReport;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses MyDatabase, StockModel, Generics.Collections, Spring.Collections, Yeahbah.FastReportObjects;

procedure TForm2.Button1Click(Sender: TObject);
var
  db: TMyDatabase;
  stocks: TList<TStockModel>;
  s: IList<TStockModel>;
  stockDataset: TFastReportObjects<TStockModel>;
begin
  stocks := TList<TStockModel>.Create;
  db := TMyDatabase.Create;
  try
    stocks.AddRange(db.Session.FindAll<TStockModel>.ToArray);
    stockDataset := TFastReportObjects<TStockModel>.Create(self, 'Stocks', stocks);
    try

      frxReport1.DataSets.Add(stockDataset);
      TfrxMasterData(frxReport1.FindObject('MasterData1')).DataSet := stockDataset;
      frxReport1.ShowReport;
    finally
      stockDataset.Free;
    end;
  finally
    db.Free;
    stocks.Free;
  end;
end;

end.
