pageextension 50753 ProductionOrderList_PQ extends "Production Order List"
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
    }
    actions
    {
    }
}
