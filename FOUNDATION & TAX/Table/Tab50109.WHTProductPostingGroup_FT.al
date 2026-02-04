table 50109 WHTProductPostingGroup_FT
{
    Caption = 'WHT Product Posting Group';
    LookupPageID = WHTProductPostingGroup_FT;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }
}
