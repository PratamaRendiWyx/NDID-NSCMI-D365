pageextension 50525 "Physical Inventory Order_WE" extends "Physical Inventory Order"
{
    layout
    {
        modify("Person Responsible")
        {
            Visible = false;
        }
        addafter("Shortcut Dimension 1 Code")
        {
            field("Person Responsible1"; Rec."Person Responsible")
            {
                ApplicationArea = All;
            }
            field("Person Responsible Name"; Rec."Person Responsible Name")
            {
                ApplicationArea = All;
            }
        }
    }
}
