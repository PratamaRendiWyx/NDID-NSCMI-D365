pageextension 50333 "Posted Sales Shpt. Subform_SP" extends "Posted Sales Shpt. Subform"
{
    layout
    {
        addafter("Location Code")
        {
            field("Cust. PO No."; Rec."Cust. PO No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
