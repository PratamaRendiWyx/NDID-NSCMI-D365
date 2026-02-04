pageextension 50726 ReleasedProductionOrders_PQ extends "Released Production Orders"
{
    layout
    {
        addfirst(FactBoxes)
        {
            part(Control1240070002; QualityTestFactbox_PQ)
            {
                Caption = 'Quality Test';
                ApplicationArea = All;
                SubPageLink = "Item No." = field("Source No."),
                          "Source No." = field("No."),
                          "Source Type" = const("Production Order");
            }
        }

        modify("Search Description")
        {
            Visible = false;
        }
        addfirst(FactBoxes)
        {
            // part("Attached Documents"; "Document Attachment Factbox")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Attachments';
            //     SubPageLink = "Table ID" = CONST(5405),
            //                   "No." = FIELD("No."),
            //                   "AM Production Order Status" = FIELD(Status);
            // }
            part(Control1240070006; ExpectedCostFactbox_PQ)
            {
                Caption = 'Expected Cost Factbox';
                ApplicationArea = All;
                SubPageLink = Status = FIELD(Status),
                              "No." = FIELD("No.");
            }
            part(Control1240070005; ActualCostFactbox_PQ)
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
            field("Is Substitute (?)"; Rec."Is Substitute (?)")
            {
                ApplicationArea = All;
            }
        }
        //-
    }

    actions
    {
        modify("Item Ledger E&ntries")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Process;
        }
        modify("Capacity Ledger Entries")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Process;
        }
        modify("Create Inventor&y Put-away/Pick/Movement")
        {
            Promoted = false;
        }
        modify("Production Order Statistics")
        {
            Promoted = false;
        }
    }
}
