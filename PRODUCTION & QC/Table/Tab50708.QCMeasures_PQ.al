table 50708 QualityControlMeasures_PQ
{
    // version QC7

    // //QC4.30  Added field 5 - Result Type

    Caption = 'Quality Control Measures';
    LookupPageID = QCControlMeasures_PQ;

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Result Type"; Option)
        {
            OptionMembers = Numeric,List;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }
}

