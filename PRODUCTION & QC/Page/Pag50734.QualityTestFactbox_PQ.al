page 50734 QualityTestFactbox_PQ
{
  PageType = ListPart;
  SourceTable = QualityTestHeader_PQ;
  Caption = 'Quality Test';
  
  layout
  {
    area(Content)
    {
      group(Parent)
      {
        ShowCaption = false;

        repeater(Control1)
        {
          field("Operation No.";Rec."Operation No.")
          {
            ApplicationArea = All;
          }
          field(Description;Rec."Operation Description")
          {
            ApplicationArea = All;
          }
          field("Test No.";Rec."Test No.")
          {
            ApplicationArea = All;

            trigger OnDrillDown();
            var
                AMQCTestHeader: Record QualityTestHeader_PQ;
                AMQCTestPage: Page QCLotTestHeader_PQ;
            begin
              Clear(AMQCTestPage);
              AMQCTestHeader.SetRange("Test No.", Rec."Test No.");
              AMQCTestPage.SetTableView(AMQCTestHeader);
              AMQCTestPage.DisableDefaultFilter(true);
              AMQCTestPage.Run();
            end;
          }
        }
      }
    }
  }

  trigger OnAfterGetRecord()
  begin
    Rec.CalcFields("Operation No.");
  end;
}