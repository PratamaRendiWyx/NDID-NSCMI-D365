table 50110 AddInfoRef_FT
{
    Caption = 'Add Info Ref. Tax';
    DrillDownPageID = "Add Info Ref.";
    LookupPageID = "Add Info Ref.";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[150])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
