pageextension 50325 PurchaseQuoteSubform_SP extends "Purchase Quote Subform"
{
    layout
    {
        addafter("Unit of Measure")
        {
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
            }
        }
    }
}
