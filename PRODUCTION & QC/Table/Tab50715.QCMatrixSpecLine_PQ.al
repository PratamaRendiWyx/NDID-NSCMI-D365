table 50715 QCMatrixSpecLine_PQ
{
    // version QC7

    // //QC3.7b  QC37.05b     Changed the Upper, Lower, Nominal and Actual values
    //                        to a decimal setting of 2:5

    Caption = 'Quality Matrix Spec Line';

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
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;
        }
        field(5; "Measure Code"; Code[20])
        {
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
        field(20; "Base Measure"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Customer No.", Type, "Measure Code")
        {
        }
    }

    fieldgroups
    {
    }
}

