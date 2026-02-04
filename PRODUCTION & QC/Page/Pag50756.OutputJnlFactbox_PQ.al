page 50756 OutputJnlFactbox_PQ
{
    // version MP13.0.00

    Caption = 'Output Jnl Factbox';
    PageType = CardPart;
    SourceTable = "Item Journal Line";

    layout
    {
        area(content)
        {
            field("<TotalSetupTime>"; TotalSetupTime)
            {
                ApplicationArea = All;
                Caption = 'Total Setup Time';
            }
            field(TotalRunTime; TotalRunTime)
            {
                ApplicationArea = All;
                Caption = 'Total Run Time';
            }
            field(TotalOutputQty; TotalOutputQty)
            {
                ApplicationArea = All;
                Caption = 'Total Output Qty';
            }
            field("<TotalAmount>"; TotalAmount)
            {
                ApplicationArea = All;
                Caption = 'Total Amount';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        UpdateFactBox(Rec);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        UpdateFactBox(Rec);
    end;

    var
        ItemJnl: Record "Item Journal Line";
        TotalAmount: Decimal;
        JournalTotal: Decimal;
        TotalRunTime: Decimal;
        TotalSetupTime: Decimal;
        TotalOutputQty: Decimal;

        [InDataSet]
        IsGood: Boolean;


    procedure TotalCostAmount(var Rec: Record "Item Journal Line")
    var
        ItemJnlLine: Record "Item Journal Line";
    begin
        TotalRunTime := 0;
        TotalSetupTime := 0;
        TotalOutputQty := 0;
        TotalAmount := 0;
        //MP
        ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if ItemJnlLine.FindSet then
            repeat
                TotalRunTime += ItemJnlLine."Run Time";
                TotalSetupTime += ItemJnlLine."Setup Time";
                TotalOutputQty += ItemJnlLine."Output Quantity";
                TotalAmount += ItemJnlLine.Amount;
            until ItemJnlLine.Next = 0;
    end;

    procedure UpdateFactBox(var ItemJournalLineT: Record "Item Journal Line")
    var
        SavedRec: Record "Requisition Line";
    begin
        TotalCostAmount(ItemJournalLineT);
        CurrPage.Update(false); //Called from Page in which this FB is Embedded
    end;
}

