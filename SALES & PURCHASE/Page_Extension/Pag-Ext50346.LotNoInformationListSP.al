pageextension 50346 "Lot No. Information List_SP" extends "Lot No. Information List"
{
    layout
    {
        addafter(Blocked)
        {
            field("USDFS Code"; Rec."USDFS Code")
            {
                ApplicationArea = All;
                Enabled = false;
            }
        }
    }
}
