pageextension 50339 "Posted Return Shipment Sub._SP" extends "Posted Return Shipment Subform"
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
