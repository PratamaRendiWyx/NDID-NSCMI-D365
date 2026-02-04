pageextension 51123 "Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("PIB/PEB No"; Rec."PIB/PEB No")
            {
                ApplicationArea = All;
            }
        }
    }
}
