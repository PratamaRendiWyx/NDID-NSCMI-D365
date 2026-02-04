pageextension 50355 "Phys. Invt. Recording Subf_SP" extends "Phys. Invt. Recording Subform"
{
    layout
    {
        modify("Package No.")
        {
            Visible = true;
        }
        addafter("Lot No.")
        {
            field("USDFS Code"; Rec."USDFS Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
