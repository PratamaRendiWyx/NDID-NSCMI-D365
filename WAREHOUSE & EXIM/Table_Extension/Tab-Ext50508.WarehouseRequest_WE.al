tableextension 50508 WarehouseRequest_WE extends "Warehouse Request"
{
    fields
    {
        field(50501; "Gen. Bus. Posting Group"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Gen. Bus. Posting Group" where("No." = field("Source No.")));
        }
    }
}
