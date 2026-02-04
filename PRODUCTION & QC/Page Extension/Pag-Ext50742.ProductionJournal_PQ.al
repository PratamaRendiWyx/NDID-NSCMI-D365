pageextension 50742 ProductionJournal_PQ extends "Production Journal"
{

    layout
    {

        addafter(Quantity)
        {

            field("Inventory"; Rec."Inventory")
            {
                ApplicationArea = All;
            }
        }
        addafter("Setup Time")
        {
            field("Stop Code"; Rec."Stop Code")
            {
                ApplicationArea = All;
            }
            field("Stop Time"; Rec."Stop Time")
            {
                ApplicationArea = All;
            }
            field(IsRemainQty; Rec.IsRemainQty)
            {
                ApplicationArea = All;
            }
        }
        addbefore("Run Time")
        {
            field("Setup-time (Planning)"; calculateSetuptimePlanning())
            {
                ApplicationArea = All;
                Editable = false;
                HideValue = SetupTimeHideValue;
                DecimalPlaces = 0 : 5;
            }
            field("Runtime (Planning)"; calculateRuntimePlanning())
            {
                ApplicationArea = All;
                Editable = false;
                HideValue = SetupTimeHideValue;
                DecimalPlaces = 0 : 5;
            }
        }
    }

    actions
    {
        addafter("Bin Contents")
        {
            action(ItemsByLocation)
            {
                ApplicationArea = All;
                Caption = 'Items b&y Location';
                Image = ItemAvailbyLoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
        }
        addafter(PreviewPosting)
        {
            action(PreviewPosting1)
            {
                ApplicationArea = Manufacturing;
                Caption = 'Preview Posting (V1)';
                Image = ViewPostedOrder;
                ShortCutKey = 'Ctrl+Alt+F9';
                ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';
                trigger OnAction()
                var
                    ItemJnlLine: Record "Item Journal Line";
                begin
                    CurrPage.SetSelectionFilter(ItemJnlLine);
                    if ItemJnlLine.FindSet() then begin
                        MarkRelevantRec(ItemJnlLine);
                        ItemJnlLine.PreviewPostItemJnlFromProduction1();

                        SetFilterGroup();
                        CurrPage.Update(false);
                    end;
                end;
            }
        }

    }

    local procedure calculateSetuptimePlanning(): Decimal
    var
        prodRoutingLine: Record "Prod. Order Routing Line";
        o_result: Decimal;
    begin
        Clear(prodRoutingLine);
        prodRoutingLine.Reset();
        prodRoutingLine.SetRange(Type, Rec.Type);
        prodRoutingLine.SetRange("Operation No.", Rec."Operation No.");
        prodRoutingLine.SetRange("No.", Rec."No.");
        prodRoutingLine.SetRange("Routing Reference No.", Rec."Order Line No.");
        prodRoutingLine.SetRange("Prod. Order No.", Rec."Order No.");
        if prodRoutingLine.Find('-') then begin
            o_result := prodRoutingLine."Setup Time";
            if prodRoutingLine."Fixed Run Time" then
                o_result := prodRoutingLine."Setup Time";
        end;
        //rounding  
        o_result := Round(o_result, 1, '>');
        //-
        exit(o_result);
    end;

    local procedure calculateRuntimePlanning(): Decimal
    var
        prodRoutingLine: Record "Prod. Order Routing Line";
        o_result: Decimal;
    begin
        Clear(prodRoutingLine);
        prodRoutingLine.Reset();
        prodRoutingLine.SetRange(Type, Rec.Type);
        prodRoutingLine.SetRange("Operation No.", Rec."Operation No.");
        prodRoutingLine.SetRange("No.", Rec."No.");
        prodRoutingLine.SetRange("Routing Reference No.", Rec."Order Line No.");
        prodRoutingLine.SetRange("Prod. Order No.", Rec."Order No.");
        if prodRoutingLine.Find('-') then begin
            o_result := Rec."Output Quantity" * prodRoutingLine."Run Time";
            if prodRoutingLine."Fixed Run Time" then
                o_result := prodRoutingLine."Run Time";
        end;
        //rounding 
        o_result := Round(o_result, 1, '>');
        //-
        exit(o_result);
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Entry Type" = Rec."Entry Type"::Consumption then begin
            Rec.SetRange("Entry No Filter")
        end else begin
            Rec."Inventory" := 0;
            Rec.SetFilter("Entry No Filter", '%1', 0);
        end;
    end;
}

