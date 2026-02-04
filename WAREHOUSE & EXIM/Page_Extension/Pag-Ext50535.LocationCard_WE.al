pageextension 50535 "Location Card_WE" extends "Location Card"
{
    layout
    {
        addafter("Use As In-Transit")
        {
            field("No Handling Direct Transfer"; Rec."No Handling Direct Transfer")
            {
                ApplicationArea = All;
            }
        }
    }
}
