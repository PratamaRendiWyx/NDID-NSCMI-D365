table 50719 QCQualityMeasureOptions_PQ
{
    // version QC10.1

    // //QC7.2 Changed Name of FIeld "Pass" (5) to "Non-Conformance", and changed "Phase" of variable to agree with that.
    // 
    // QC7.4
    //   - Changed "Quality Measure Code" Field Length from 10 to 20 to match with rest of QC System

    Caption = 'Quality Measure Options';

    fields
    {
        field(1; "Quality Measure Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = QualityControlMeasures_PQ;
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Code"; Code[10])
        {
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(4; "Description"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Non-Conformance"; Boolean)
        {
            Description = 'QC7.2 Changed Name from "Pass"';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Quality Measure Code", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

