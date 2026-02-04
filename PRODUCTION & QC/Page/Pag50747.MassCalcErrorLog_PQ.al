page 50747 MassCalcErrorLog_PQ
{
    ApplicationArea = All;
    Caption = 'Mass Calc Error Log';
    CardPageID = MassCalcErrorLog_PQ;
    Editable = false;
    PageType = List;
    SourceTable = MassCalcErrorLog_PQ;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    LookupPageID = "Item Card";
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field("Calculation date"; Rec."Calculation date")
                {
                    ApplicationArea = All;
                }
                field(Error; Rec.Error)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

