table 50728 MassCalcErrorLog_PQ
{
   
    Caption = 'Mass Calc Error Log';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Item No."; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Item Description"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Calculation date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; Error; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

