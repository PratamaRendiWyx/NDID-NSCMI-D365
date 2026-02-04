pageextension 50108 ItemCharges_FT extends "Item Charges"
{
    layout
    {
        addafter("Search Description")
        {
            field("WHT Prod. Posting Group"; Rec."WHT Prod. Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
}
