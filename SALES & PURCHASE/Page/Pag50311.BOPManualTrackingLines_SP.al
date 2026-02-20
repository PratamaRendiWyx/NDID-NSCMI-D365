page 50311 "BOPManualTrackingLines_SP"
{
    PageType = Worksheet;
    SourceTable = "BOPManualTracking_SP";
    AutoSplitKey = true;
    DelayedInsert = true;
    Caption = 'Item Tracking Lines';
    PopulateAllFields = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Input Lot Number manually or select from the list.';
                }
            }
        }
    }
}