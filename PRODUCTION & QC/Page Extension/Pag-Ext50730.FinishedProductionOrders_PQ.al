pageextension 50730 FinishedProductionOrders_PQ extends "Finished Production Orders"
{
    layout
    {
        addfirst(FactBoxes)
        {
            part(Control1240070002; ExpectedCostFactbox_PQ)
            {
                Caption = 'Expected Cost Factbox';
                ApplicationArea = All;
                SubPageLink = Status = FIELD(Status),
                              "No." = FIELD("No.");
            }
            part(Control1240070000; ActualCostFactbox_PQ)
            {
                Caption = 'Actual Cost Factbox';
                ApplicationArea = All;
                SubPageLink = Status = FIELD(Status),
                              "No." = FIELD("No.");
            }
        }
        modify("Routing No.")
        {
            Visible = false;
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
        addafter("Production Order Statistics")
        {
            action("Estimate vs Actual Detail")
            {
                ApplicationArea = All;
                Caption = 'Estimate vs Actual Detail';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                end;
            }
        }
    }
}
