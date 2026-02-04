tableextension 50116 WarehouseBasicCue_FT extends "Warehouse Basic Cue"
{
    fields
    {
        // Add changes to table fields here

        field(50200; "Shipments - Today"; Integer)
        {
            CalcFormula = count("Warehouse Shipment Header" where("Shipment Date" = field("Date Filter"),
                                                                   "Location Code" = field("Location Filter")));
            Caption = 'Shipments - Today';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50201; "TO-Today"; Integer)
        {
            CalcFormula = count("Transfer Header");
            Caption = 'TO - All';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}