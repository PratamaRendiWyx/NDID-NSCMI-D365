tableextension 50706 LotNoInformation_PQ extends "Lot No. Information"
{

    fields
    {
        field(50700; "Lot Test Exists"; Boolean)
        {

            CalcFormula = Exist(QualityTestHeader_PQ WHERE("Item No." = FIELD("Item No."),
                                                                 "Lot No./Serial No." = FIELD("Lot No.")));
            Caption = 'Lot Test Exists';
            Description = 'QC';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50701; "Qty on Hand"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Remaining Quantity" WHERE("Item No." = FIELD("Item No."),
                                                                              "Variant Code" = FIELD("Variant Code"),
                                                                              "Lot No." = FIELD("Lot No."),
                                                                              "Location Code" = FIELD("Location Filter"),
                                                                              "Remaining Quantity" = FILTER(<> 0)));
            Caption = 'Qty on Hand';
            DecimalPlaces = 0 : 5;
            Description = 'QC for just open item drill down.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50702; "Non-Conformance"; Boolean)
        {
            CalcFormula = Exist(QualityTestLines_PQ WHERE("Item No." = FIELD(FILTER("Item No.")),
                                                                "Lot No./Serial No." = FIELD(FILTER("Lot No.")),
                                                                "Non-Conformance" = CONST(true)));
            Caption = 'Failed';
            Description = 'QC7.2 FlowField Added';
            FieldClass = FlowField;
        }
        field(50703; "No. of Quality Tests"; Integer)
        {
            CalcFormula = count(QualityTestHeader_PQ WHERE("Item No." = FIELD("Item No."),
                                                                 "Test No." = FIELD("CCS Test No.")));
            Caption = 'No. of Quality Tests';
            Description = 'QC';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50704; "CCS Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            Description = 'Expiration Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                FunctionLibrary: Codeunit QCFunctionLibrary_PQ;
            begin
                if "CCS Expiration Date" <> 0D then
                    FunctionLibrary.UpdateILEExpirationDateFromLotNoInformation(Rec);
            end;
        }
        field(50705; "CCS Status"; Enum LotSerialStatus_PQ)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                case "CCS Status" of
                    "CCS Status"::Hold, "CCS Status"::"In Quality Inspection", "CCS Status"::Restricted:
                        Rec.Validate(Blocked, true);
                    else
                        Rec.Validate(Blocked, false);
                end;

                if xRec."CCS Status" <> Rec."CCS Status" then
                    Rec."CCS Latest Status" := xRec."CCS Status";
            end;
        }
        field(50706; "CCS Temporary Blocked"; boolean)
        {
            Caption = 'Temporary Blocked';
            DataClassification = CustomerContent;
        }
        field(50707; "CCS Latest Status"; Enum LotSerialStatus_PQ)
        {
            Caption = 'Latest Status';
            DataClassification = CustomerContent;
        }
        field(50708; "CCS Date Received"; Date)
        {
            Caption = 'Date Received';
            Description = 'Date Received';
            DataClassification = CustomerContent;
        }
        field(50709; "CCS Date Certified"; Date)
        {
            Caption = 'Date Certified';
            Description = 'Date Certified';
            DataClassification = CustomerContent;
        }
        field(50710; "CCS Test No."; Code[20])
        {
            Caption = 'Quality Test No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}
