namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Purchases.History;

pageextension 51113 PostedPurchaseReceiptLines_AF extends "Posted Purchase Receipt Lines"
{
    layout
    {
        addafter("Buy-from Vendor No.")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
