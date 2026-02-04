pageextension 50714 WorkCenterList_PQ extends "Work Center List"
{

    PromotedActionCategories = 'New,Process,Report,Work Ctr.,Planning';
    layout
    {
        modify("Alternate Work Center")
        {
            Visible = false;
        }
        modify("Search Name")
        {
            Visible = false;
        }

        addfirst(FactBoxes)
        {
            part(WCSF; WorkCenterStatsFactbox_PQ)
            {
                Caption = 'Work Center Statistics';
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
        modify("Calculate Work Center Calendar")
        {
            Promoted = true;
            PromotedCategory = Category5;
            PromotedIsBig = true;
        }
    }
}

