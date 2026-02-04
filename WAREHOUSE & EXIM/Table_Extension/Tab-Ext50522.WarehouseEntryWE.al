tableextension 50522 "Warehouse Entry_WE" extends "Warehouse Entry"
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
