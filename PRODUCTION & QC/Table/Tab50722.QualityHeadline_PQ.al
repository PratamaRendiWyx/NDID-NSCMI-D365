table 50722 QualityHeadline_PQ
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Key"; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Workdate for computations"; Date)
        {
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Key")
        {
            Clustered = true;
        }
    }
}