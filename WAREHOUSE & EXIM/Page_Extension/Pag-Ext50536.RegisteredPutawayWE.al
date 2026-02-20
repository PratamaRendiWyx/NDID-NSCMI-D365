pageextension 50536 "Registered Put-away_WE" extends "Registered Put-away"
{
    layout
    {
        addafter("Registering Date")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
