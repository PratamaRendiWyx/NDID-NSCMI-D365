pageextension 50351 "Posted Purch. Invoice - Upd_SP" extends "Posted Purch. Invoice - Update"
{
    layout
    {
        addafter("Tax Number_FT")
        {
            field("PIB/PEB No"; Rec."PIB/PEB No")
            {
                ApplicationArea = All;
            }
        }
    }
}
