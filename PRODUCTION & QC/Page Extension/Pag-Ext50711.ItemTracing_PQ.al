pageextension 50711 ItemTracing_PQ extends "Item Tracing" 
{
  layout
  {
    addafter("Item Description")
    {
      field("Quality Test";Rec."Quality Test")
      {
        ToolTip = 'Specifies the number of Quality Tests associated';
        ApplicationArea = All;
        

        trigger OnDrillDown();
        var
            QCTestHeader: Record QualityTestHeader_PQ;
            QCTestPage: Page QCLotTestHeader_PQ;
        begin
          Rec.CalcFields("Quality Test");
          Clear(QCTestPage);
          QCTestHeader.SetRange("Test No.", Rec."Quality Test");
          QCTestPage.SetTableView(QCTestHeader);
          QCTestPage.DisableDefaultFilter(true);
          QCTestPage.Run();
        end;
      }
    }
  }
}

