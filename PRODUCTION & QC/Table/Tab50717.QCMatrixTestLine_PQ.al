table 50717 QCMatrixTestLine_PQ
{
    // version QC7

    // //QC37.05  Changed the field Lot No. to "Lot/Serial No."
    // //QC3.7b  QC37.05b     Changed the Upper, Lower, Nominal and Actual values
    //                        to a decimal setting of 2:5

    Caption = 'Quality Matrix Test Line';

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
        field(3; "Measure Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Variant Code"; Code[20])
        {
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;
        }
        field(10; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;
        }
        field(11; "Description"; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(12; "Nominal Value"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Lot/Serial No.", "Measure Code")
        {
        }
    }

    fieldgroups
    {
    }
}

