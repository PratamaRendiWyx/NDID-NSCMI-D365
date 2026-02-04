pageextension 50722 PlannedProductionOrders_PQ extends "Planned Production Orders"
{

    layout
    {
        addafter("Last Date Modified")
        {
            field("Production Line"; Rec."Production Line")
            {
                ApplicationArea = All;
            }
            field(Index; Rec.Index)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(Shift; Rec.Shift)
            {
                ApplicationArea = All;
            }
            field("Vacum Cycle"; Rec."Vacum Cycle")
            {
                ApplicationArea = All;
            }
            field("Capacity Line"; Rec."Capacity Line")
            {
                ApplicationArea = All;
            }
            field("Capacity Mix"; Rec."Capacity Mix")
            {
                ApplicationArea = All;
            }
        }
        modify("Search Description")
        {
            Visible = false;
        }
        addfirst(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(5405),
                              "No." = FIELD("No."),
                              "Production Order Status" = FIELD(Status);
            }
            part(Control1240070003; ExpectedCostFactbox_PQ)
            {
                Caption = 'Expected Cost Factbox';
                ApplicationArea = All;
                SubPageLink = Status = FIELD(Status),
                              "No." = FIELD("No.");
            }
            part(Control1240070004; ActualCostFactbox_PQ)
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
    }
}
