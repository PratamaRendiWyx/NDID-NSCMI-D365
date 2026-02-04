table 50114 UnitRef_FT
{
    Caption = 'Unit Ref. Tax';
    DrillDownPageID = "Unit Ref.";
    LookupPageID = "Unit Ref.";

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
