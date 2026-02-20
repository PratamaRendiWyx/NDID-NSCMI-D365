tableextension 50521 "Registered Whse. Activity Hdr." extends "Registered Whse. Activity Hdr."
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
        field(50305; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
    }
}
