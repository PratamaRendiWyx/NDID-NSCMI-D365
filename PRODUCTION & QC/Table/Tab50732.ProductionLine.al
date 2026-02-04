table 50732 "Production Line"
{
    Caption = 'Production Line';
    DrillDownPageID = "Production Lines";
    LookupPageID = "Production Lines";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; "Capacity Line"; Decimal)
        {
            Caption = 'Capacity Line';
        }
        field(5; "Capacity Mix"; Decimal)
        {
            Caption = 'Capacity Mix';
        }
    }
    keys
    {
        key(PK; "Item No.", Code)
        {
            Clustered = true;
        }
    }
}
