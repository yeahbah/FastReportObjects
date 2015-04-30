unit StockModel;

interface

uses
  System.SysUtils,
  Spring,
  Spring.Persistence.Mapping.Attributes;

type
  [Entity]
  [Table('STOCKS')]
  TStockModel = class
  private
    fSymbol: string;
    fPercentChange: single;
    fLastTradedPrice: single;
    fDescription: string;
    fLastTradedDate: TDate;
    fSecurityId: integer;
    fMarketCapitalization: single;
    fCompanyId: integer;
    fFreeFloatLevel: single;
    fOutstandingShares: single;
  public
    constructor Create;
    [Column('SYMBOL', [cpRequired, cpPrimaryKey])]
    property Symbol: string read fSymbol write fSymbol;
    [Column('DESCRIPTION')]
    property Description: string read fDescription write fDescription;
    [Column('SECURITY_ID')]
    property SecurityId: integer read fSecurityId write fSecurityId;
    [Column('COMPANY_ID')]
    property CompanyId: integer read fCompanyId write fCompanyId;
    [Column('LAST_TRADED_PRICE')]
    property LastTradedPrice: single read fLastTradedPrice write fLastTradedPrice;
    [Column('LAST_TRADED_DATE')]
    property LastTradedDate: TDate read fLastTradedDate write fLastTradedDate;
    [Column('FREE_FLOAT_LEVEL')]
    property FreeFloatLevel: single read fFreeFloatLevel write fFreeFloatLevel;
    [Column('MARKET_CAPITALIZATION')]
    property MarketCapitalization: single read fMarketCapitalization write fMarketCapitalization;
    [Column('OUTSTANDING_SHARES')]
    property OutstandingShares: single read fOutstandingShares write fOutstandingShares;
  end;


implementation

{ TStockModel }

constructor TStockModel.Create;
begin
  fPercentChange := 0;
  fLastTradedPrice := 0;
  fFreeFloatLevel := 0;
  fMarketCapitalization := 0;
  fOutstandingShares := 0;
end;

end.
