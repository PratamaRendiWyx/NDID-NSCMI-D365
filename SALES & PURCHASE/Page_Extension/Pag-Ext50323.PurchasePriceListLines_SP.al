pageextension 50323 PurchasePriceListLines_SP extends "Purchase Price List Lines"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("Quote No."; Rec."Quote No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
