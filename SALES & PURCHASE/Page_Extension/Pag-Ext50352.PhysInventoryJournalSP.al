pageextension 50352 "Phys. Inventory Journal_SP" extends "Phys. Inventory Journal"
{
    layout
    {
        addafter("Location Code")
        {
            field("USDFS Code"; Rec."USDFS Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
