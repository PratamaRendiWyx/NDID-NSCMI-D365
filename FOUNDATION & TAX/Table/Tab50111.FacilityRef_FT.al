table 50111 FacilityRef_FT
{
    Caption = 'Facility Ref. Tax';
    DrillDownPageID = "Facility Ref.";
    LookupPageID = "Facility Ref.";

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
