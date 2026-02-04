tableextension 50715 WarehouseActivityLine_PQ extends "Warehouse Activity Line"
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
        field(50301; "CCS Latest Lot No."; Code[50])
        {
            Caption = 'Latest Lot No.';
            DataClassification = CustomerContent;
        }
        field(50302; "CCS Latest Serial No."; Code[50])
        {
            Caption = 'Latest Serial No.';
            DataClassification = CustomerContent;
        }
    }
}