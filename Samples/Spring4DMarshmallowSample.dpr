program Spring4DMarshmallowSample;

uses
  Vcl.Forms,
  Unit2 in 'Unit2.pas' {Form2},
  StockModel in 'StockModel.pas',
  MyDatabase in 'MyDatabase.pas',
  Yeahbah.FastReportObjects in '..\Yeahbah.FastReportObjects.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
