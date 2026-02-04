pageextension 50531 "Warehouse Put-away_WE" extends "Warehouse Put-away"
{
    layout
    {
        addbefore("Sorting Method")
        {
            field(Operator; Rec.Operator)
            {
                ApplicationArea = All;
            }
            field("Operator Name"; Rec."Operator Name")
            {
                ApplicationArea = All;
            }
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
