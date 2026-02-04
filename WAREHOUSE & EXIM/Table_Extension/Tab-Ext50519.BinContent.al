tableextension 50519 "Bin Content" extends "Bin Content"
{
    fields
    {
        field(50500; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Editable = false;
        }
    }
}
