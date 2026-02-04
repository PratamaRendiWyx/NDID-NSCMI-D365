pageextension 50734 MachineCenterList_PQ extends "Machine Center List"
{

    PromotedActionCategories = 'New,Process,Report,Mach. Ctr.,Planning';
    layout
    {
        modify("Search Name")
        {
            Visible = false;
        }
        modify("Direct Unit Cost")
        {
            Visible = true;
        }
        modify("Indirect Cost %")
        {
            Visible = true;
        }
        modify("Unit Cost")
        {
            Visible = true;
        }
        modify("Overhead Rate")
        {
            Visible = true;
        }
        modify("Flushing Method")
        {
            Visible = true;
        }
        addfirst(FactBoxes)
        {
            part(Control1240070001; MachineCenterStatsFactb_PQ)
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
            PromotedIsBig = true;
            PromotedCategory = Category4;
        }
        modify(Statistics)
        {
            Promoted = true;
            PromotedCategory = Category4;
            PromotedIsBig = true;
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
            PromotedCategory = Category5;
            PromotedIsBig = true;
        }
    }
}

