pageextension 50502 WhseShipmentSubform_WE extends "Whse. Shipment Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Completely Packing"; Rec."Completely Packing")
            {
                ApplicationArea = Warehouse;
                Editable = false;
            }
            field("Completely Shipping Mark"; Rec."Completely Shipping Mark")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Customer PO No."; Rec."Customer PO No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {

    }
}
