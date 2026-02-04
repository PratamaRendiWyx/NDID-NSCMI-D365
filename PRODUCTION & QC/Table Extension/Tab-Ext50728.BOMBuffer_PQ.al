tableextension 50728 BOMBuffer_PQ extends "BOM Buffer"
{
    fields
    {
        field(50700; "Vendor No."; code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(50701; "Item Inventory"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No.")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50702; "Item Variant Inventory"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                 "Variant Code" = FIELD("Variant Code")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50703; "Reordering Policy"; Enum "Reordering Policy")
        {
            DataClassification = CustomerContent;
            Caption = 'Reordering Policy';
        }
    }

}