pageextension 50515 UserSetup_WE extends "User Setup"
{
    layout
    {
        addafter("Time Sheet Admin.")
        {
            field("Allow Update Qty. to Receive"; Rec."Allow Update Qty. to Receive")
            {
                ApplicationArea = All;
            }
        }
    }
}
