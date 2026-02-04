table 50304 SaleShipmentLineCOA_SP
{
    Caption = 'Shipment Line BOP (Approvals)';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Need to Approve - Qty"; Integer)
        {
            CalcFormula = count("Sales Shipment Line" where("Status Approval" = const("Ready for Review"),
            "Item Category Code" = filter('FINISHED GOOD')));
            Caption = 'Need to Approve';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Approved - Qty"; Integer)
        {
            CalcFormula = count("Sales Shipment Line" where("Status Approval" = const(Approved),
            "Item Category Code" = filter('FINISHED GOOD')));
            Caption = 'Approved';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Rejected - Qty"; Integer)
        {
            CalcFormula = count("Sales Shipment Line" where("Status Approval" = const(Rejected),
            "Item Category Code" = filter('FINISHED GOOD')));
            Caption = 'Rejected';
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
