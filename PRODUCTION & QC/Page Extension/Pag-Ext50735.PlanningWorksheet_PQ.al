pageextension 50735 PlanningWorksheet_PQ extends "Planning Worksheet"
{
    layout
    {
        modify("Due Date")
        {
            Visible = false;
        }
        modify("Starting Date-Time")
        {
            Caption = 'Starting Date-Time (Estimation)';
        }
        modify("Ending Date-Time")
        {
            Caption = 'Ending Date-Time (Estimation)';
        }
        modify(Control11)
        {
            Visible = false;
        }
        modify(Control15)
        {
            Visible = false;
        }
        addfirst(FactBoxes)
        {
            part(ItemSupply; ItemSupplyFactbox_PQ)
            {
                Caption = 'Item Supply Factbox';
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No."),
                              "Location Filter" = FIELD("Location Code");
            }
            part(ItemDemand; ItemDemandFactbox_PQ)
            {
                Caption = 'Item Demand Factbox';
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No."),
                              "Location Filter" = FIELD("Location Code");
            }
            part(PlanWorksheetTotalsFactbox; PlanWorksheetTotalsFac_PQ)
            {
                Caption = 'Plan. Worksheet Totals Factbox';
                ApplicationArea = All;
                SubPageLink = "Worksheet Template Name" = FIELD("Worksheet Template Name"),
                              "Journal Batch Name" = FIELD("Journal Batch Name"),
                              "Line No." = FIELD("Line No.");
            }
        }

        addbefore(Quantity)
        {
            field("Is Subcon (?)"; Rec."Is Subcon (?)")
            {
                ApplicationArea = All;
            }
        }
        addafter("Vendor No.")
        {
            field("Vendor Posting Group"; Rec."Vendor Posting Group")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
        addafter(Quantity)
        {
            field(Shift; Rec.Shift)
            {
                ApplicationArea = All;
            }
            field("Production Line"; Rec."Production Line")
            {
                ApplicationArea = All;

                trigger OnLookup(Var Text: Text): Boolean
                var
                    ProdLine: Record "Production Line";
                    ProductionLines: page "Production Lines";
                    XData: Record "Production Line";
                begin
                    if Not (Rec."Ref. Order Type" = Rec."Ref. Order Type"::"Prod. Order") then
                        exit;
                    Clear(ProductionLines);
                    Clear(ProdLine);
                    XData.SetRange("Item No.", Rec."No.");
                    ProductionLines.SetRecord(XData);
                    ProductionLines.SetTableView(XData);
                    ProductionLines.LookupMode := true;
                    if ProductionLines.RunModal() = Action::LookupOK then begin
                        ProductionLines.SetSelectionFilter(ProdLine);
                        if ProdLine.FindSet() then begin
                            Rec."Production Line" := ProdLine.Code;
                            Rec."Capacity Line" := ProdLine."Capacity Line";
                            Rec."Capacity Mix" := ProdLine."Capacity Mix";
                        end;
                    end;
                end;

                trigger OnValidate()
                var
                    myInt: Integer;
                begin
                    if Rec."Production Line" = '' then begin
                        Rec."Capacity Line" := 0;
                    end;
                end;
            }
            field("Capacity Line"; Rec."Capacity Line")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Starting Date (Plan)"; Rec."Starting Date (Plan)")
            {
                ApplicationArea = All;
            }
            field("Capacity Mix"; Rec."Capacity Mix")
            {
                ApplicationArea = All;
            }
            field("Qty. to Plan Order"; Rec."Qty. to Plan Order")
            {
                ApplicationArea = All;
                StyleExpr = MarkingQtyPlan;
                trigger OnValidate()
                var
                    myInt: Integer;
                    RemainQty: Decimal;
                begin
                    if Rec."Remain Qty." = 0 then
                        RemainQty := Rec.Quantity
                    else
                        RemainQty := Rec."Remain Qty.";
                    //validation check 
                    if Rec."Qty. to Plan Order" > RemainQty then
                        Error('Can''t input qty greather than remain qty [%1]', Rec."Remain Qty.");
                    //-
                    MarkingPerRecordQtyPlanOrder();
                end;
            }
            field("Remain Qty."; getRemainQty())
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

        addafter(CarryOutActionMessage)
        {
            action(CarryOutActionMessage0)
            {
                ApplicationArea = Planning;
                Caption = 'Carry &Out Action Message (Production)';
                Ellipsis = true;
                Image = CarryOutActionMessage;
                ToolTip = 'Use a batch job to help you create actual supply orders from the order proposals.';

                trigger OnAction()
                begin
                    CarryOutActionMsgProd();
                    CurrPage.Update(true);
                end;
            }
            action(CarryOutActionMessage1)
            {
                ApplicationArea = Planning;
                Caption = 'Carry &Out Production Order';
                Ellipsis = true;
                Image = CarryOutActionMessage;
                Visible = false;
                ToolTip = 'Use a batch job to help you create actual supply orders from the order proposals.';
                trigger OnAction()
                var
                    SplitproductionOrder: Report SplitProductionOrderV2_PQ;
                begin
                    SplitproductionOrder.UseRequestPage(true);
                    SplitproductionOrder.setParameter(Rec, Rec.Quantity);
                    SplitproductionOrder.RunModal();
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Clear(MarkingQtyPlan);
        MarkingPerRecordQtyPlanOrder();
    end;

    local procedure MarkingPerRecordQtyPlanOrder()
    begin
        if Rec."Qty. to Plan Order" = 0 then
            MarkingQtyPlan := 'Unfavorable'
        else
            MarkingQtyPlan := 'Favorable';
    end;

    var
        MarkingQtyPlan: Text[100];

    local procedure getRemainQty(): Decimal
    begin
        if Rec."Ref. Order Type" = Rec."Ref. Order Type"::"Prod. Order" then begin
            if Rec."Remain Qty." = 0 then
                exit(Rec.Quantity)
            else
                exit(Rec."Remain Qty.");
        end;
        exit(0);
    end;

    local procedure CarryOutActionMsgProd()
    var
        CarryOutActionMsgPlan: Report "Carry Out Prod. Ord. Plan Wrk";
        Ishandled: Boolean;
    begin
        CarryOutActionMsgPlan.SetReqWkshLine(Rec);
        CarryOutActionMsgPlan.RunModal();
    end;

}

