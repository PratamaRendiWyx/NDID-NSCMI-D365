pageextension 50518 PostedPurchaseReceiptLines_WE extends "Posted Purchase Receipt Lines"
{
    layout
    {
        addafter("Order No.")
        {
            field("Vendor Shipment No."; Rec."Vendor Shipment No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
