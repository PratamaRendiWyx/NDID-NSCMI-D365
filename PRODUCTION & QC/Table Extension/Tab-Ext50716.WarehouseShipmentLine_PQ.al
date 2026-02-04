tableextension 50716 WarehouseShipmentLine_PQ extends "Warehouse Shipment Line"
{
    fields
    {
        // Add changes to table fields here
        field(50700; "Quality Tests"; Integer)
        {
            Caption = 'Quality Tests';
            Description = 'It will show a quality test no. if there is an specification that requires it.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count(QualityTestHeader_PQ where("Source No." = field("Source No."),
                                                                "Source Line No." = field("Source Line No.")));
        }
    }
}