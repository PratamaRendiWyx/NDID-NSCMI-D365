pageextension 50358 "Inventory Setup_SP" extends "Inventory Setup"
{
    layout
    {
        addafter("Default Location QC")
        {
            field("Ignore Package No. for Exp.Qty"; Rec."Ignore Package No. for Exp.Qty")
            {
                ApplicationArea = All;
            }
        }
    }
}
