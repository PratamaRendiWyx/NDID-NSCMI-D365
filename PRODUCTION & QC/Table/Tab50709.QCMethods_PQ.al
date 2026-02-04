table 50709 QualityControlMethods_PQ
{
    // version QC7

    Caption = 'Quality Control Methods';
    LookupPageID = QCControlMethods_PQ;

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

