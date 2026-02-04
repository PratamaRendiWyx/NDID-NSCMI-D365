pageextension 51126 "Cash Receipt Journal_AF" extends "Cash Receipt Journal"
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
