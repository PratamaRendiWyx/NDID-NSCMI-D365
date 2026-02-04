pageextension 51125 "General Journal_AF" extends "General Journal"
{
    layout
    {
        addafter("External Document No.")
        {
            field("PIB/PEB No"; Rec."PIB/PEB No")
            {
                ApplicationArea = All;
            }
        }
    }
}
