tableextension 50119 ProductionOrder_FT extends "Production Order"
{
    fields
    {
        field(50100; "Item Category"; Code[20])
        {
            Caption = 'Item Category';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("Source No.")));
        }
    }
}
