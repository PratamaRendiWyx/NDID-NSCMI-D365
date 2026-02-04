pageextension 50338 "Purchase Rtrn Order Subform_SP" extends "Purchase Return Order Subform"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
            }
        }
    }
}
