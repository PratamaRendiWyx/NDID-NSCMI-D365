pageextension 50719 SimulatedProductionOrder_PQ extends "Simulated Production Order"
{

    layout
    {
        addafter("Assigned User ID")
        {
            field("Creation Date"; Rec."Creation Date")
            {
                Caption = 'Creation Date';
                ApplicationArea = All;
            }
        }
        addafter("Last Date Modified")
        {
            field(Status; Rec.Status)
            {
                Caption = 'Status';
                ApplicationArea = All;
                Editable = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
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
    }
    actions
    {
    }

}

