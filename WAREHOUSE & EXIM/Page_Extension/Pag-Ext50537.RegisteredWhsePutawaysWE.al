pageextension 50537 "Registered Whse. Put-aways_WE" extends "Registered Whse. Put-aways"
{
    layout
    {
        addafter("No. Series")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
