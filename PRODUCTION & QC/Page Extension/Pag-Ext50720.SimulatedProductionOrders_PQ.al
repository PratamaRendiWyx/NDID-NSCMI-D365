pageextension 50720 SimulatedProductionOrders_PQ extends "Simulated Production Orders"
{

    layout
    {
        modify("Search Description")
        {
            Visible = false;
        }
        addfirst(FactBoxes)
        {
            part(AMControl1240070002; ExpectedCostFactbox_PQ)
            {
                Caption = 'Expected Cost Factbox';
                ApplicationArea = All;
                SubPageLink = Status = FIELD(Status),
                              "No." = FIELD("No.");
            }
            part(AMControl1240070003; ActualCostFactbox_PQ)
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
    }
    actions
    {
    }
}

