pageextension 50526 "Phys. Inventory Record List_WE" extends "Phys. Inventory Recording List"
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
