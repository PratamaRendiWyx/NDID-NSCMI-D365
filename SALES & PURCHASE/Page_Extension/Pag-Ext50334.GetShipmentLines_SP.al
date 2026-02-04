pageextension 50334 "Get Shipment Lines_SP" extends "Get Shipment Lines"
{
    layout
    {
        addafter("Unit of Measure")
        {
            field("Cust. PO No."; Rec."Cust. PO No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
