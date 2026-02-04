pageextension 50305 PurchaseOrderSubform_SP extends "Purchase Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Planning Status"; Rec."Planning Status")
            {
                Enabled = FinishEnable;
                Visible = FinishEnable;
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the line planning status.';
            }
        }
        addbefore(Quantity)
        {
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
            }
        }
        addbefore("Qty. to Receive")
        {
            field("Qty. to Ship"; Rec."Qty. to Ship")
            {
                ApplicationArea = Suite;
                Editable = (Rec.Type = Rec.Type::Item);
            }
            field("Quantity Shipped"; Rec."Quantity Shipped")
            {
                Editable = false;
                ApplicationArea = Suite;
            }
            field("Price Unit Before"; Rec."Price Unit Before")
            {
                ApplicationArea = All;
            }
            field(getPriceAmountBefore; getPriceAmountBefore)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Price Amount Before';
            }
            field(getDiffAmountBefore; getDiffAmountBefore)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Total Difference';
            }
        }
    }

    local procedure getPriceAmountBefore(): Decimal
    begin
        exit(Rec.Quantity * Rec."Price Unit Before");
    end;

    local procedure getDiffAmountBefore(): Decimal
    begin
        exit((Rec."Price Unit Before" * Rec.Quantity) - Rec."Line Amount");
    end;

    trigger OnOpenPage()
    var
        EnableOrderCompletion: Codeunit EnableOrderCompletion_SP;
    begin
        FinishEnable := EnableOrderCompletion.FinishOrdersPurchaseEnabled();
    end;

    var
        FinishEnable: Boolean;
}