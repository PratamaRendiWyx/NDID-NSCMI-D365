pageextension 50337 "Posted Sales Invoice Subfrm SP" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Part Number"; Rec."Part Number")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Part Name"; Rec."Part Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Cust. PO No."; Rec."Cust. PO No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
