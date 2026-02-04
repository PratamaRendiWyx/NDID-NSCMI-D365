pageextension 50715 WhseShipmentSubform_PQ extends "Whse. Shipment Subform"
{
    layout
    {
        addafter("Qty. per Unit of Measure")
        {

            field("Quality Tests"; Rec."Quality Tests")
            {
                ToolTip = 'Specifies the number of Quality Tests associated';
                ApplicationArea = All;
            }
        }
    }
}