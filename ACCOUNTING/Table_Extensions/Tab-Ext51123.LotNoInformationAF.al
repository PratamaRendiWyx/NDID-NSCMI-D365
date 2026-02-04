tableextension 51123 "Lot No. Information_AF" extends "Lot No. Information"
{
    fields
    {
        field(51123; Inventory1; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."),
                                                                  "Variant Code" = field("Variant Code"),
                                                                  "Lot No." = field("Lot No."),
                                                                  "Posting Date" = field("Date Filter")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
