pageextension 50345 "Lot No. Information Card_SP" extends "Lot No. Information Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("USDFS Code"; Rec."USDFS Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
