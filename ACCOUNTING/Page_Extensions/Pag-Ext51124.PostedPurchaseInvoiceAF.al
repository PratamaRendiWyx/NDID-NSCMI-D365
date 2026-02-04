pageextension 51124 "Posted Purchase Invoice_AF" extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("PIB/PEB No"; Rec."PIB/PEB No")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
