unit Yeahbah.FastReportObjects;

interface

uses
  frxClass, Generics.Collections, Classes, Rtti, SysUtils, Generics.Defaults;

type
  IFastReportUserDataset = interface
    ['{2293FB63-4BC4-45B8-B430-B5E11A293EF6}']
    procedure DatasetFirst(Sender: TObject);
    procedure DatasetCheckEOF(Sender: TObject; var Eof: Boolean);
    procedure DatasetPrior(Sender: TObject);
    procedure DatasetNext(Sender: TObject);
    procedure DatasetGetValue(const VarName: String;
      var Value: Variant);

    function GetCurrentIndex: integer;
    property CurrentIndex: integer read GetCurrentIndex;
  end;

  TFastReportObjects<T: class> = class (TfrxUserDataSet, IFastReportUserDataset)
  private
    fCurrentIndex: integer;
    function GetCurrentIndex: integer;
  protected
    fData: TList<T>;
    fDetailDatasets: TDictionary<IFastReportUserDataset, TProc<T>>;

    // IFastReportUserDataset
    procedure DatasetFirst(Sender: TObject);
    procedure DatasetCheckEOF(Sender: TObject; var Eof: Boolean);
    procedure DatasetPrior(Sender: TObject);
    procedure DatasetNext(Sender: TObject);
    procedure DatasetGetValue(const VarName: String;
      var Value: Variant);
    property CurrentIndex: integer read GetCurrentIndex;
    //

    function GetDataPropertyValue(aInstance: T; const aPropName: string): TValue;
    procedure InitializeDetailDatasets;
  public
    constructor Create(aOwner: TComponent; const aDatasetName: string); reintroduce; overload;
    constructor Create(aOwner: TComponent; const aDatasetName: string; const aData: TList<T>); reintroduce; overload;
    procedure AttachDetailDataset(aDetailDataset: IFastReportUserDataset;
      aOnGetDetailDataProc: TProc<T>);
    property Data: TList<T> read fData write fData;
  end;

implementation

{ TFastReportObjects<T> }

procedure TFastReportObjects<T>.AttachDetailDataset(
  aDetailDataset: IFastReportUserDataset; aOnGetDetailDataProc: TProc<T>);
begin
  fDetailDatasets.Add(aDetailDataset, aOnGetDetailDataProc);
end;

constructor TFastReportObjects<T>.Create(aOwner: TComponent;
  const aDatasetName: string; const aData: TList<T>);
begin
  Create(aOwner, aDatasetName);
  fData := aData;

  RangeEndCount := aData.Count;
end;

constructor TFastReportObjects<T>.Create(aOwner: TComponent; const aDatasetName: string);
begin
  inherited Create(aOwner);

  Name := aDatasetName;
  UserName := aDatasetName;

  // hook events
  OnCheckEOF := DatasetCheckEOF;
  OnFirst := DatasetFirst;
  OnGetValue := DatasetGetValue;
  OnNext := DatasetNext;
  OnPrior := DatasetPrior;

  RangeBegin := rbFirst;
  RangeEnd := reLast;

  fDetailDatasets := TDictionary<IFastReportUserDataset, TProc<T>>.Create;
end;

procedure TFastReportObjects<T>.DatasetCheckEOF(Sender: TObject;
  var Eof: Boolean);
begin
  Eof := fCurrentIndex >= fData.Count
end;

procedure TFastReportObjects<T>.DatasetFirst(Sender: TObject);
begin
  fCurrentIndex := 0;
  InitializeDetailDatasets;
end;

procedure TFastReportObjects<T>.DatasetGetValue(const VarName: String;
  var Value: Variant);
var
  fieldData: TValue;
begin
  fieldData := GetDataPropertyValue(fData[fCurrentIndex], VarName);
  Value := fieldData.AsVariant;
end;

procedure TFastReportObjects<T>.DatasetNext(Sender: TObject);
var
  detailDatasetPair: TPair<IFastReportUserDataset, TProc<T>>;
begin
  Inc(fCurrentIndex);
  if Eof then
    Exit;

  InitializeDetailDatasets;
end;

procedure TFastReportObjects<T>.DatasetPrior(Sender: TObject);
begin
  Dec(fCurrentIndex);
  InitializeDetailDatasets;
end;

function TFastReportObjects<T>.GetCurrentIndex: integer;
begin
  result := fCurrentIndex;
end;

function TFastReportObjects<T>.GetDataPropertyValue(aInstance: T;
  const aPropName: string): TValue;
var
  t: TRttiType;
  p: TRttiProperty;
  ctx: TRttiContext;
begin
  t := ctx.GetType(aInstance.ClassType);
  try
    p := t.GetProperty(aPropName);
    Assert(Assigned(p), aPropName + ' not found.');

    result := p.GetValue(Pointer(aInstance));

  finally
    ctx.Free;
  end;
end;

procedure TFastReportObjects<T>.InitializeDetailDatasets;
var
  detailDatasetPair: TPair<IFastReportUserDataset, TProc<T>>;
begin
  for detailDatasetPair in fDetailDatasets do
  begin
    detailDatasetPair.Value(Data[fCurrentIndex]);
  end;
end;

end.
