pageextension 50737 MachineCenterCard_PQ extends "Machine Center Card"
{

    PromotedActionCategories = 'New,Process,Report,Mach. Ctr.,Planning';
    layout
    {
        addafter("Last Date Modified")
        {
            field("Current Capacity Need"; Rec."Current Capacity Need")
            {
                ApplicationArea = All;
                Caption = 'Current Capacity Need';
                ToolTip = 'Sum of the current Capacity required of this machine';
            }
            field("Allocated Time"; Rec."Allocated Time")
            {
                ApplicationArea = All;
                Caption = 'Allocated Time';
                Editable = false;
                ToolTip = 'How much time has been assigned to the machine';
            }
        }

        modify(Warehouse)
        {
            Visible = false;
        }
        addfirst(FactBoxes)
        {
            part(Control1240070002; MachineCenterStatsFactb_PQ)
            {
                Caption = 'Machine Center Stats Factbox';
                ApplicationArea = All;
                SubPageLink = "No." = FIELD(FILTER("No."));
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
            PromotedCategory = Category4;
            PromotedIsBig = true;
        }
        modify(Statistics)
        {
            Promoted = true;
            PromotedCategory = Category4;
        }
        modify("&Calendar")
        {
            Promoted = true;
            PromotedCategory = Category5;
            PromotedIsBig = true;
        }
        modify("A&bsence")
        {
            Promoted = true;
            PromotedCategory = Category5;
            PromotedIsBig = true;
        }
        modify("Ta&sk List")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category5;
        }
    }
}

