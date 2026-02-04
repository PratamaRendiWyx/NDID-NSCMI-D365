pageextension 50335 "Posted Sales Inv. - Update_SP" extends "Posted Sales Inv. - Update"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Tax No."; Rec."Tax No.")
            {
                ApplicationArea = All;
            }
            field("PEB No"; Rec."PEB No")
            {
                ApplicationArea = All;
            }
        }
    }
}
