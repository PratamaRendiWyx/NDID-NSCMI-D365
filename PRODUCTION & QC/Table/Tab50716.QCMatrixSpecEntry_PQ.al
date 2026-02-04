table 50716 QCMatrixSpecEntry_PQ
{
    // version QC7

    Caption = 'Quality Matrix Spec Entry';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Type"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Variant Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(5; "ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Measure Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Customer No.", Type, "Measure Code", ID)
        {
        }
    }

    fieldgroups
    {
    }
}

