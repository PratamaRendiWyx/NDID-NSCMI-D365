tableextension 50506 WarehouseSetup_WE extends "Warehouse Setup"
{
    fields
    {
        field(50500; "Packing Nos."; Code[20])
        {
            Caption = 'Packing Nos.';
            TableRelation = "No. Series";
        }
        field(50501; "Ship Mark Nos."; Code[20])
        {
            Caption = 'Ship Mark Nos.';
            TableRelation = "No. Series";
        }

    }
}
