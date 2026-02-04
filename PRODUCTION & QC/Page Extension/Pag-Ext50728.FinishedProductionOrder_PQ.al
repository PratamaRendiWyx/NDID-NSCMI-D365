pageextension 50728 FinishedProductionOrder_PQ extends "Finished Production Order"
{
    layout
    {
        modify("Source No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                restrictLine();
            end;
        }
        addafter(Quantity)
        {
            field("Is Subcon (?)"; Rec."Is Subcon (?)")
            {
                ApplicationArea = All;
            }
        }
        addafter("Last Date Modified")
        {
            field(Shift; Rec.Shift)
            {
                ApplicationArea = All;
                Caption = 'Shift Code';
                Enabled = glbRestric;
            }
            field("Production Line"; Rec."Production Line")
            {
                ApplicationArea = All;
                Caption = 'Production Line';
                Enabled = glbRestric;
            }
            field("Capacity Line"; Rec."Capacity Line")
            {
                ApplicationArea = All;
                Caption = 'Capacity Line';
                Enabled = glbRestric;
            }
        }
        addafter("Due Date")
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
                Style = Strong;
                StyleExpr = TRUE;
            }
        }
        addfirst(FactBoxes)
        {
            // part("Attached Documents"; "Document Attachment Factbox")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Attachments';
            //     SubPageLink = "Table ID" = CONST(5405),
            //                   "No." = FIELD("No."),
            //                   "ProductionOrderStatus_PQ = FIELD(Status);
            // }
            part(Control1240070002; ExpectedCostFactbox_PQ)
            {
                Caption = 'Expected Cost Factbox';
                ApplicationArea = All;
                SubPageLink = Status = FIELD(Status),
                              "No." = FIELD("No.");
            }
            part(Control1240070001; ActualCostFactbox_PQ)
            {
                Caption = 'Actual Cost Factbox';
                ApplicationArea = All;
                SubPageLink = Status = FIELD(Status),
                              "No." = FIELD("No.");
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
        addafter("Due Date")
        {
            field("Start Date-Time (Production)"; Rec."Start Date-Time (Production)")
            {
                ApplicationArea = All;
            }
            field("End Date-Time (Production)"; Rec."End Date-Time (Production)")
            {
                ApplicationArea = All;
            }

            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
                MultiLine = true;
            }
        }
        modify(Schedule)
        {
            Visible = false;
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
        modify("Value Entries")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Process;
        }
        modify("&Warehouse Entries")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Process;
        }
        addafter(ReopenFinishedProdOrder)
        {
            action(ReopenFinishedProdOrder1)
            {
                ApplicationArea = Manufacturing;
                Caption = 'Reopen.';
                Image = ReOpen;
                ToolTip = 'Reopen the production order to change it after it has been finished.';

                trigger OnAction()
                var
                    ProdOrderStatusManagement: Codeunit "Prod. Order Status Management.";
                begin
                    ProdOrderStatusManagement.ReopenFinishedProdOrder(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        restrictLine();
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        restrictLine();
    end;

    local procedure restrictLine()
    begin
        glbRestric := true;
        // Rec.CalcFields("Is Subcon (?)");
        // if Rec."Is Subcon (?)" then
        //     glbRestric := false;
    end;

    var
        glbRestric: Boolean;
}
