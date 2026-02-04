pageextension 50356 "Payment Terms" extends "Payment Terms"
{
    layout
    {
        addafter("Due Date Calculation")
        {
            field("Day Number"; Rec."Day Number")
            {
                ApplicationArea = All;
            }
        }
    }
}
