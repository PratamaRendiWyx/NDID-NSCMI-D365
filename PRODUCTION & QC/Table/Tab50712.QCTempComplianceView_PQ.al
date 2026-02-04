table 50712 QCTempComplianceView_PQ
{
    // version QC80.1

    // //QC3.7b  QC37.05b     Changed the Upper, Lower, Nominal and Actual values
    //                        to a decimal setting of 2:5
    // //QC4.3  Added two fields 50& 51  Result and Result Type
    // 
    // QC80.1
    //   - Added Field "Test Line Complete"

    Caption = 'Quality Control Temp Compliance View';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Version Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Lower Limit"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
        field(5; "Upper Limit"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
        field(6; "Nominal Value"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
        field(7; "Actual Value"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
        field(8; "Non Compliance"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Quality Measure"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Description"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Method"; Code[20])
        {
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
    }

    keys
    {
        key(Key1; "Item No.", "Quality Measure")
        {
        }
    }

    fieldgroups
    {
    }
}

