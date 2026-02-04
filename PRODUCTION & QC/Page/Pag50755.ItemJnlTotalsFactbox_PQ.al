page 50755 ItemJnlTotalsFactbox_PQ
{

    Caption = 'Item Jnl. Totals';
    PageType = CardPart;
    SourceTable = "Item Journal Line";

    layout
    {
        area(content)
        {
            field(TotalQty; TotalQty)
            {
                ApplicationArea = All;
                Caption = 'Total Quantity';
                ToolTip = 'Total Quantity of Items in Journal';
            }
            field(TotalAmount; TotalAmount)
            {
                ApplicationArea = All;
                Caption = 'Total Amount';
                ToolTip = 'Total Line Amount of journal lines';
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
        TotalQty: Decimal;

    procedure TotalCostAmount(var Rec: Record "Item Journal Line")
    var
        ItemJnlLine: Record "Item Journal Line";
    begin
        TotalQty := 0;
        TotalAmount := 0;

        //MP
        ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if ItemJnlLine.FindSet then
            repeat
                TotalQty += ItemJnlLine.Quantity;
                TotalAmount += ItemJnlLine.Quantity * ItemJnlLine."Unit Amount";
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

