pageextension 50732 FirmPlannedProdOrders_PQ extends "Firm Planned Prod. Orders"
{
    layout
    {
        modify("Search Description")
        {
            Visible = false;
        }
        addfirst(FactBoxes)
        {
            part(Control1240070002; ExpectedCostFactbox_PQ)
            {
                Caption = 'Expected Cost Factbox';
                ApplicationArea = All;
                SubPageLink = Status = FIELD(Status),
                              "No." = FIELD("No.");
            }
            part(Control1240070003; ActualCostFactbox_PQ)
            {
                Caption = 'Actual Cost Factbox';
                ApplicationArea = All;
                SubPageLink = Status = FIELD(Status),
                              "No." = FIELD("No.");
            }
        }
        addafter(Status)
        {
            field(Shift; Rec.Shift)
            {
                ApplicationArea = All;
                Caption = 'Shift Code';
            }
            field("Production Line"; Rec."Production Line")
            {
                ApplicationArea = All;
                Caption = 'Production Line';
            }
            field("Capacity Line"; Rec."Capacity Line")
            {
                ApplicationArea = All;
                Caption = 'Capacity Line';
            }
        }
        //Add mod 19 Feb 2025
        modify("Due Date")
        {
            Visible = false;
        }
        modify("Starting Date-Time")
        {
            Visible = false;
        }
        modify("Ending Date-Time")
        {
            Visible = false;
        }
        addafter("Ending Date-Time")
        {
            field("Start Date-Time (Production)"; Rec."Start Date-Time (Production)")
            {
                ApplicationArea = All;
            }
            field("End Date-Time (Production)"; Rec."End Date-Time (Production)")
            {
                ApplicationArea = All;
            }
            field("Is Substitute (?)"; Rec."Is Substitute (?)")
            {
                ApplicationArea = All;
            }
        }
        //-
    }
    actions
    {
        modify(ProdOrderJobCard)
        {
            Promoted = true;
            PromotedIsBig = true;
        }
        modify(ProdOrderMaterialRequisition)
        {
            Promoted = false;
        }
    }


}
