pageextension 50757 WorkShifts_PQ extends "Work Shifts"
{
    layout
    {
        addafter(Description)
        {
            field("Starting Time"; Rec."Starting Time")
            {
                ApplicationArea = All;
            }
            field("Ending Time"; Rec."Ending Time")
            {
                ApplicationArea = All;
            }
            field("Default Shift"; Rec."Default Shift")
            {
                ApplicationArea = All;
            }
        }
    }
}
