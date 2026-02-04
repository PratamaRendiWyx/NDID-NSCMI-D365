tableextension 50736 PurchaseLine_PQ extends "Purchase Line"
{
    fields
    {
        field(50700; "CCS QC Required"; Boolean)
        {
            Caption = 'Quality Test Mandatory';
            Description = 'Informational only';
            DataClassification = CustomerContent;
        }
        field(50701; "Test No."; Code[20])
        {
            CalcFormula = lookup(QualityTestHeader_PQ."Test No." WHERE("Source Type" = const("Purchase Order"),
                                                                "Source No." = FIELD("Document No."),
                                                                 "Source Line No." = field("Line No."),
                                                                 "Item No." = field("No.")));
            Caption = 'Quality Test No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50702; "No. of Quality Tests"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = COUNT(QualityTestHeader_PQ WHERE("Source No." = FIELD("Document No."),
                                                                "Source Line No." = FIELD("Line No.")));
            Caption = 'No. of Quality Tests';
        }
    }

}
