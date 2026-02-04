pageextension 50511 ItemCard_WE extends "Item Card"
{
    layout
    {
        addafter("Item Category Code")
        {
            field("Shipping Lot No."; Rec."Shipping Lot No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
