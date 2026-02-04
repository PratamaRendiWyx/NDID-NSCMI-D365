tableextension 50312 ItemBudgetEntry_SP extends "Item Budget Entry"
{
    fields
    {
        field(50202; "Desc. Item"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
    }
}
