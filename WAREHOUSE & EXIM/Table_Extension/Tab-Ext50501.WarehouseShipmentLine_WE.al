tableextension 50501 WarehouseShipmentLine_WE extends "Warehouse Shipment Line"
{
    fields
    {
        field(50501; "Shipping Mark"; Code[20])
        {

        }
        field(50502; "Completely Packing"; Boolean)
        {

        }
        field(50503; "Shipping Mark Date"; Date)
        {

        }
        field(50504; "Packing List No."; Code[20])
        {

        }
        field(50505; "Customer PO No."; Text[35])
        {
            Caption = 'Customer PO No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."External Document No." where("No." = field("Source No.")));
        }
        field(50506; "Completely Shipping Mark"; Boolean)
        {

        }
    }

    trigger OnBeforeDelete()
    var
        myInt: Integer;
    begin
        if Rec."Completely Packing" then
            Error('Can''t delete warehouse shipment line, cause already completely packing.');
    end;
}
