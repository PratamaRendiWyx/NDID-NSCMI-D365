table 50305 SaleShipmentLineCOAQC_SP
{
    Caption = 'Shipment Line BOP - QC (Approvals)';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Open - Qty"; Integer)
        {
            CalcFormula = count("Sales Shipment Line" where("Status Approval" = const(Open),
            "Item Category Code" = filter('FINISHED GOOD')));
            Caption = 'Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "In-Process - Qty"; Integer)
        {
            CalcFormula = count("Sales Shipment Line" where("Status Approval" = const("In Process"),
            "Item Category Code" = filter('FINISHED GOOD')));
            Caption = 'In-Process';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Ready for Review - Qty"; Integer)
        {
            CalcFormula = count("Sales Shipment Line" where("Status Approval" = const("Ready for Review"),
            "Item Category Code" = filter('FINISHED GOOD')));
            Caption = 'Ready for Review';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}
