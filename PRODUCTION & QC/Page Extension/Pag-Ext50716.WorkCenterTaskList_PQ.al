pageextension 50716 WorkCenterTaskList_PQ extends "Work Center Task List"
{

    PromotedActionCategories = 'New,Process,Report,Work Ctr.,Function';
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
        addafter("Fixed Scrap Quantity")
        {
            field("Expected Capacity Need"; Rec."Expected Capacity Need")
            {
                Caption = 'Expected Capacity Need';
                ApplicationArea = All;
                ToolTip = 'Displays the Expected Capacity need from Production Orders';
            }
        }
        addfirst(FactBoxes)
        {
            part(AMControl1240070003; WorkCenterStatsFactbox_PQ)
            {
                Caption = 'Work Center Statistics';
                ApplicationArea = All;
                Enabled = false;
                SubPageLink = "No." = FIELD(FILTER("Work Center No."));
                Visible = false;
            }
        }
    }
    actions
    {
        modify("Capacity Ledger E&ntries")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category4;
        }
        modify("Co&mments")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category4;
        }
        modify("Lo&ad")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category4;
        }
        modify(Statistics)
        {
            Promoted = true;
            PromotedCategory = Category4;
            PromotedIsBig = true;
        }
        modify("&Move")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category5;
        }
        modify("Order &Tracking")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category5;
        }
    }
}


