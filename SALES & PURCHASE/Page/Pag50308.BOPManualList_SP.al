page 50308 "BOPManualList_SP"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BOPManualHeader_SP";
    Caption = 'Manual BOP Documents';
    CardPageId = "BOPManual_SP";
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Customer PO No."; Rec."Customer PO No.")
                {
                    ApplicationArea = All;
                }
                field("Status Approval"; Rec."Status Approval")
                {
                    ApplicationArea = All;
                }
                field("Approval Date"; Rec."Approval Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }


}