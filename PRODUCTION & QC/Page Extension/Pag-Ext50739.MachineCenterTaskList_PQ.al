pageextension 50739 MachineCenterTaskList_PQ extends "Machine Center Task List"
{

    PromotedActionCategories = 'New,Process,Report,Function,Mach Ctr.';
    layout
    {
        modify(Status)
        {
            Style = Strong;
            StyleExpr = TRUE;
        }
        addafter(Description)
        {
            field("Routing Status"; Rec."Routing Status")
            {
                Caption = 'Routing Status';
                ApplicationArea = All;
                Style = Strong;
                StyleExpr = TRUE;
            }
        }
        addafter("Ending Date")
        {
            field("Expected Capacity Need"; Rec."Expected Capacity Need")
            {
                Caption = 'Expected Capacity Need';
                ApplicationArea = All;
                ToolTip = 'Displays Expected Capacity need from Prod. Orders';
            }
            field("Needed Time"; Rec."Needed Time")
            {
                Caption = 'Needed Time';
                ApplicationArea = All;
            }
            field("Allocated Time"; Rec."Allocated Time")
            {
                Caption = 'Allocated Time';
                ApplicationArea = All;
            }
            field("Location Code"; Rec."Location Code")
            {
                Caption = 'Location Code';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify("Capacity Ledger E&ntries")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category5;
        }
        modify("Co&mments")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category5;
        }
        modify("Lo&ad")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category5;
        }
        modify(Statistics)
        {
            Promoted = true;
            PromotedCategory = Category5;
            PromotedIsBig = true;
        }
        modify("&Move")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category4;
        }
        modify("Order &Tracking")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category4;
        }
    }
}

