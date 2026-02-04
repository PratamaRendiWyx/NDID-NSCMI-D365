pageextension 50532 "Warehouse Put-aways_WE" extends "Warehouse Put-aways"
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
        }
    }
}
