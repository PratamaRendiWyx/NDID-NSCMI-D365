pageextension 50341 "Posted Item Tracking Lines SP" extends "Posted Item Tracking Lines"
{
    layout
    {
        addafter("Package No.")
        {
            field("Shipping Mark No."; Rec."Shipping Mark No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Box Qty."; Rec."Box Qty.")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("USDFS Code"; Rec."USDFS Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
