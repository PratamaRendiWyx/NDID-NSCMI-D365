namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Purchases.History;

pageextension 51118 PostedPurchInvoiceUpd_AF extends "Posted Purch. Invoice - Update"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Tax Number_FT"; Rec."Tax Number_FT")
            {
                ApplicationArea = All;
            }
            field("Tax Date_FT"; Rec."Tax Date_FT")
            {
                ApplicationArea = All;
            }
        }
    }
}
