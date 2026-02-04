page 51104 "Log Entries Inventory Aging"
{
    ApplicationArea = All;
    Caption = 'Log Entries Inventory Aging';
    PageType = List;
    SourceTable = "Log Entries Invt. Aging";
    UsageCategory = History;
    Editable = false;
    SourceTableView = sorting(GuidID, Sequence) order(ascending);

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(GuidID; Rec.GuidID)
                {
                    ApplicationArea = All;
                }
                field("As Of Date"; Rec."As Of Date")
                {
                    ApplicationArea = All;
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Date Time"; Rec."Date Time")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
