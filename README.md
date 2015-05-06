# FastReportObjects
Easiest way to print your objects into FastReport

Sample:

``` pascal
var
  peopleDataset: TFastReportObjects<TPerson>;
begin
  peopleDataset := TFastReportObjects.Create(self, 'PersonDataset', people);
  try
    // you have to set the band dataset
    TfrxMasterData(frxReport1.FindObject('MasterData1')).DataSet := peopleDataset;

    // you have to add the dataset to the report
    frxReport1.DataSets.Add(peopleDataset);

    frxReport1.ShowReport;
  finally
    peopleDataset.Free;
  end;
```

Use it with Spring4D/Marshmallow:

``` pascal
var
  db: TMyDatabase;
  stocks: TList<TStockModel>;
  s: IList<TStockModel>;
  stockDataset: TFastReportObjects<TStockmodel>;
begin
  stocks := TList.Create;
  db := TMyDatabase.Create;
  try
    stocks.AddRange(db.Session.FindAll.ToArray);
    stockDataset := TFastReportObjects.Create(self, 'Stocks', stocks);
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
  ```
