table 50718 QCMatrixTestEntry_PQ
{
    // version QC7

    // //QC37.05  Changed the field Lot No. to "Lot/Serial No."

    Caption = 'Quality Matrix Test Entry';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(2; "Lot/Serial No."; Code[20])
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
        key(Key1; "Item No.", "Lot/Serial No.", "Measure Code", ID)
        {
        }
    }

    fieldgroups
    {
    }
}

