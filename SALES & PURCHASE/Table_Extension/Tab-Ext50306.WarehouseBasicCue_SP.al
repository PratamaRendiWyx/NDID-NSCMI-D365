tableextension 50306 WarehouseBasicCue_SP extends "Warehouse Basic Cue"
{
    fields
    {
        field(60100; "Rel. Purch. Orders Until Today"; Integer)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         Status = filter(Released),
                                                         IsClose = const(false),
                                                         "Location Code" = field("Location Filter")));
            Caption = 'Rel. Purch. Orders Until Today';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}