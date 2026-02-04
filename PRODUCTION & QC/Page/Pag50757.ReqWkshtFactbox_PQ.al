page 50757 ReqWkshtFactbox_PQ
{
    Caption = 'Req Wksht Factbox';
    PageType = CardPart;
    SourceTable = "Requisition Line";

    layout
    {
        area(content)
        {
            field("Worksheet Total"; WorksheetTotal)
            {
                ApplicationArea = All;
                Caption = 'Worksheet Total';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        TotalCostAmount(Rec);
    end;

    var
        ReqLine: Record "Requisition Line";
        TotalAmount: Decimal;
        JournalTotal: Decimal;
        TotalRunTime: Decimal;
        TotalSetupTime: Decimal;
        TotalOutputQty: Decimal;
        PlanningAmount: Decimal;
        PlannedAmount: Decimal;
        WorksheetTotal: Decimal;

    procedure TotalCostAmount(var Rec: Record "Requisition Line")
    var
        ReqWkSheet: Record "Requisition Line";
    begin
        WorksheetTotal := 0;
        ReqWkSheet.SetCurrentKey("Worksheet Template Name", "Journal Batch Name", "Planning Line Origin", "Replenishment System");
        ReqWkSheet.SetFilter("Worksheet Template Name", Rec."Worksheet Template Name");
        ReqWkSheet.SetFilter("Journal Batch Name", Rec."Journal Batch Name");
        ReqWkSheet.CalcSums("Cost Amount");
        WorksheetTotal := ReqWkSheet."Cost Amount";
    end;

    procedure UpdateFactBox(var RequisitionLine: Record "Requisition Line")
    var
        SavedRec: Record "Requisition Line";
    begin
        TotalCostAmount(RequisitionLine);
        CurrPage.Update(false); //Called from Page in which this FB is Embedded
    end;
}

