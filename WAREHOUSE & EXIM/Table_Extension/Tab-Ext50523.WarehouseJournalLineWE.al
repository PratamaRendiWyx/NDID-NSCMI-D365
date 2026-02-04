tableextension 50523 "Warehouse Journal Line_WE" extends "Warehouse Journal Line"
{
    fields
    {
        field(50303; "Operator"; Code[20])
        {
            Editable = false;
        }
        field(50304; "Operator Name"; Code[250])
        {
            Editable = false;
        }
    }
}
