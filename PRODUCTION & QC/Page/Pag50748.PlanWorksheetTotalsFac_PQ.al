page 50748 PlanWorksheetTotalsFac_PQ
{
    // version MP13.0.00

    // MP7.1.09
    //   - Code Changes to Make Record Link work
    // 
    // MP8.0.08
    //   - Added Function "UpdateFactbox" to allow Pages that have embedded this Factbox to FORCE a Recalc/Update from their OnAfterGetCurrRecord Triggers
    //   - Removed Code in OnAfterGetRecord Trigger that was interfering with calling-code in Page "Planning Worksheet"

    Caption = 'Plan. Worksheet Totals';
    Editable = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "Requisition Line";

    layout
    {
        area(content)
        {
            field(TotalProdOrd; TotalProdOrd)
            {
                ApplicationArea = All;
                Caption = 'Production Orders';
                Editable = false;
                ToolTip = 'Total Cost for Production Orders';
            }
            field(TotalPurchOrd; TotalPurchOrd)
            {
                ApplicationArea = All;
                Caption = 'Purchase Orders';
                Editable = false;
                ToolTip = 'Total Cost for Purchase Orders';
            }
            field(TotalTransfOrd; TotalTransfOrd)
            {
                ApplicationArea = All;
                Caption = 'Transfer Orders';
                Editable = false;
                ToolTip = 'Total Cost for Transfers Orders';
            }
            field(WorksheetTotal; WorksheetTotal)
            {
                ApplicationArea = All;
                Caption = 'Worksheet Total';
                Editable = false;
                ToolTip = 'Total cost on the worksheet.';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        TotalCostAmount(Rec);
        CurrPage.Update(false);
    end;

    var
        ReqWkSheet: Record "Requisition Line";
        WorksheetTotal: Decimal;
        TotalPurchOrd: Decimal;
        TotalProdOrd: Decimal;
        TotalTransfOrd: Decimal;

    procedure TotalCostAmount(Rec: Record "Requisition Line")
    begin
        ReqWkSheet.Reset;
        ReqWkSheet.SetCurrentKey(ReqWkSheet."Worksheet Template Name", ReqWkSheet."Journal Batch Name", ReqWkSheet."Planning Line Origin", ReqWkSheet."Replenishment System");
        ReqWkSheet.SetFilter(ReqWkSheet."Worksheet Template Name", Rec."Worksheet Template Name");
        ReqWkSheet.SetFilter(ReqWkSheet."Journal Batch Name", Rec."Journal Batch Name");
        ReqWkSheet.SetFilter(ReqWkSheet."Replenishment System", 'Prod. Order');
        ReqWkSheet.CalcSums(ReqWkSheet."Cost Amount");
        TotalProdOrd := ReqWkSheet."Cost Amount";

        ReqWkSheet.SetFilter(ReqWkSheet."Replenishment System", 'Purchase');
        ReqWkSheet.CalcSums(ReqWkSheet."Cost Amount");
        TotalPurchOrd := ReqWkSheet."Cost Amount";

        ReqWkSheet.SetFilter(ReqWkSheet."Replenishment System", 'Transfer');
        ReqWkSheet.CalcSums(ReqWkSheet."Cost Amount");
        TotalTransfOrd := ReqWkSheet."Cost Amount";

        WorksheetTotal := TotalProdOrd + TotalPurchOrd + TotalTransfOrd;
    end;

    procedure UpdateFactBox(Rec: Record "Requisition Line")
    var
        SavedRec: Record "Requisition Line";
    begin
        TotalCostAmount(Rec);
        CurrPage.Update(false); //Called from Page in which this FB is Embedded
    end;
}

