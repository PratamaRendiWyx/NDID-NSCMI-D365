pageextension 50700 UserSetup_PQ extends "User Setup"
{

    layout
    {
        addafter("Time Sheet Admin.")
        {
            field("Quality Manager"; Rec."CCS Quality Manager")
            {
                ToolTip = 'Indicates if the User is a Quality Control Manager (for approvals if necessary)';
                ApplicationArea = All;
            }
        }
    }

}