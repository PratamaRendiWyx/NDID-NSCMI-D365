table 50112 CountryRef_FT
{
    Caption = 'Country Ref. Tax';
    DrillDownPageID = "Country Ref.";
    LookupPageID = "Country Ref.";

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
