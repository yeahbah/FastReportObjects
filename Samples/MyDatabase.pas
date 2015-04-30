unit MyDatabase;

interface

uses
  SQLiteTable3,
  Spring.Persistence.Core.Interfaces,
  Spring.Persistence.Core.Session,
  Spring.Persistence.Mapping.Attributes;


type
  TMyDatabase = class
  private
    fConnection: IDBConnection;
    fDatabase: TSQLiteDatabase;
    fSession: TSession;
  public
    constructor Create;
    destructor Destroy; override;
    property Database: TSQLiteDatabase read fDatabase write fDatabase;
    property Connection: IDBConnection read fConnection write fConnection;
    property Session: TSession read fSession write fSession;
  end;

implementation

uses
  Spring.Persistence.Adapters.SQLite;

{ TPSEAlertDatabase }

constructor TMyDatabase.Create;
begin
  fDatabase := TSQLiteDatabase.Create;
  fDatabase.Filename := 'psestocks.s3db';
  fConnection := TSQLiteConnectionAdapter.Create(fDatabase);
  fConnection.AutoFreeConnection := true;
  fConnection.Connect;

  fSession := TSession.Create(fConnection);
end;

destructor TMyDatabase.Destroy;
begin
  fSession.Free;
  inherited;
end;

end.
