table 51105 "Log Entries Invt. Aging"
{
    Caption = 'Log Entries Invt. Aging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; GuidID; Guid)
        {
            Caption = 'GuidID';
        }
        field(2; "As Of Date"; Date)
        {
            Caption = 'As Of Date';
        }
        field(4; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(5; "Date Time"; DateTime) { }
        field(3; Sequence; Integer) { }
    }
    keys
    {
        key(PK; GuidID)
        {
            Clustered = true;
        }
        key(AK; Sequence) { }
    }
}
