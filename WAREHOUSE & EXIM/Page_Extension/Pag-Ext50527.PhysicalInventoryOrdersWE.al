pageextension 50527 "Physical Inventory Orders_WE" extends "Physical Inventory Orders"
{
    layout
    {
        addafter("Person Responsible")
        {
            field("Person Responsible Name"; Rec."Person Responsible Name")
            {
                ApplicationArea = All;
            }
        }
    }
}
