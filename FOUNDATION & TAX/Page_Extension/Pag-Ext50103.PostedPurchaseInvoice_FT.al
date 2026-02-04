pageextension 50103 PostedPurchaseInvoice_FT extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("Tax Number";Rec."Tax Number_FT")
            {
                ApplicationArea = All;
            }
            field("Tax Date";Rec."Tax Date_FT")
            {
                ApplicationArea = All;
            }
        }
    }
}
