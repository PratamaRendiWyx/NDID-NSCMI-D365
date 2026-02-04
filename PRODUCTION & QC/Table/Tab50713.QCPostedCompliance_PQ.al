table 50713 QCPostedCompliance_PQ
{
    // version QC11.01

    // //QC37.05  Changed the field Lot No. to "Lot/Serial No."
    // //QC3.7b  QC37.05b     Changed the Upper, Lower, Nominal and Actual values
    //                        to a decimal setting of 2:5
    // //QC4.30  Added two fields 50 & 51  Result and Result Type
    // 
    // //QC6.2  Changed Primary key to allow for both Lot and Serial Nos. on an Item Ledger Entry
    // 
    // QC7.6
    //   - Added Options '>=' and '<=' to the "Optional Display Prefix" Field (See also, "Quality Test Lines" Table)
    // 
    // QC80.1 
    //   - Added Field "Test Line Complete"

    Caption = 'Quality Posted Compliance View';

    fields
    {
        field(1; "Item Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Lot/Serial No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Version Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(8; "Lower Limit"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
        field(9; "Upper Limit"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
        field(10; "Nominal Value"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
        field(11; "Actual Value"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
        field(12; "Non Compliance"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Quality Measure"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Measure Description"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Method"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(16; "Test No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Optional Display Prefix"; Option)
        {
            Description = '=,>,<,>=,<=';
            OptionCaption = '=,>,<,>=,<=';
            OptionMembers = "=",">","<",">=","<=";
            DataClassification = CustomerContent;
        }
        field(31; "Optional Display Value"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(32; "PrintActualMeasure"; Text[20])
        {
            Description = 'Used on reports';
            DataClassification = CustomerContent;
        }
        field(50; "Result"; Code[10])
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                LineNo: Integer;
                Results: Record QCQualityMeasureOptions_PQ;
            begin
            end;
        }
        field(51; "Result Type"; Option)
        {
            OptionMembers = Numeric,List;
            DataClassification = CustomerContent;
        }
        field(52; "Test Line Complete"; Boolean)
        {
            Description = 'QC80.1 Added';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(53; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Item Entry No.", "Lot/Serial No.", "Quality Measure", "Line No.")
        {
        }
        key(Key2; "Document No.", "Lot/Serial No.")
        {
        }
    }

    fieldgroups
    {
    }
}

