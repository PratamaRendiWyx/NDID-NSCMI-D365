pageextension 50750 ProdOrderRouting_PQ extends "Prod. Order Routing"
{
    layout
    {
        modify("Prod. Order No.")
        {
            ApplicationArea = All;
            Visible = true;
        }
        addafter("Operation No.")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
            }
            field("Routing No."; Rec."Routing No.")
            {
                ApplicationArea = All;
            }
            field("Routing Reference No."; Rec."Routing Reference No.")
            {
                ApplicationArea = All;
            }
        }
        modify("Starting Date-Time")
        {
            Visible = false;
        }
        modify("Ending Date-Time")
        {
            Visible = false;
        }
        addafter("Move Time")
        {
            field("Spec. Type ID"; Rec."CCS Spec. Type ID")
            {
                ApplicationArea = All;
                Visible = false;

                trigger OnDrillDown()
                var
                    SpecificationHeader: Record QCSpecificationHeader_PQ;
                    SpecificationHeaderPage: Page QCSpecificationHeader_PQ;
                begin
                    if Rec."CCS Spec. Type ID" <> '' then begin
                        SpecificationHeader.SetRange("Item No.", Rec."Routing No.");
                        SpecificationHeader.SetRange("Customer No.", '');
                        SpecificationHeader.SetRange(Type, Rec."CCS Spec. Type ID");
                        SpecificationHeaderPage.SetTableView(SpecificationHeader);
                        SpecificationHeaderPage.RunModal();
                    end;
                end;
            }
            field("Quality Test No."; Rec."CCS Quality Test No.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Item Output"; Rec."Item Output")
            {
                //
                ApplicationArea = All;
            }
            field("Finished Qty."; Rec."Finished Qty.")
            {
                ApplicationArea = All;
            }
            field("Lot Size Item"; getInfoItemLotSize(Rec."Item Output"))
            {
                ApplicationArea = All;
            }
        }

        addafter(Description)
        {
            field("PQ Routing Status"; Rec."Routing Status")
            {
                ApplicationArea = All;
            }
        }

        addafter("Ending Date")
        {
            field("Input Quantity"; Rec."Input Quantity")
            {
                Caption = 'Input Quantity';
                ApplicationArea = All;
            }
            field("Actual Output Qty"; Rec."Actual Output Qty")
            {
                Caption = 'Actual Output Qty';
                ApplicationArea = All;
            }
            field(AMRemainingQty; Rec."Input Quantity" - Rec."Actual Output Qty")
            {
                ApplicationArea = All;
                Caption = 'Remaining Quantity';
            }
        }
        addafter("Unit Cost per")
        {
            field("Actual Time Qty"; Rec."Actual Time Qty")
            {
                ApplicationArea = All;
                Caption = 'Actual Time Qty';
            }
        }
        addafter("Expected Capacity Ovhd. Cost")
        {
            field("Unit Cost Calculation"; Rec."Unit Cost Calculation")
            {
                ApplicationArea = All;
                Caption = 'Unit Cost Calculation';
            }
        }
    }

    actions
    {
        modify("Co&mments")
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify(Tools)
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify(Personnel)
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify("Quality Measures")
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify("Allocated Capacity")
        {
            Promoted = true;
            PromotedCategory = Process;
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Rec.SetAutoCalcFields("Item Output");
    end;

    local procedure getInfoItemLotSize(iNo: Code[20]): Decimal
    var
        Item: Record Item;
    begin
        Clear(Item);
        Item.Reset();
        Item.SetRange("No.", iNo);
        if Item.Find('-') then
            exit(Item."Lot Size");
        exit(0);
    end;
}