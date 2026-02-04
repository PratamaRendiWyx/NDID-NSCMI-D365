pageextension 50310 PurchaseLines_SP extends "Purchase Lines"
{
    layout
    {
        addafter("Buy-from Vendor No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
            }
            field("Order Date (Header)"; Rec."Order Date (Header)")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Location Code")
        {
            field(IsClose; Rec.IsClose)
            {
                ApplicationArea = All;
            }
        }
        addafter("Direct Unit Cost")
        {
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
}
