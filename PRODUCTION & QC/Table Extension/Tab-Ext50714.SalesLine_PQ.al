tableextension 50714 SalesLine_PQ extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here
        field(50700; "Quality Tests"; Integer)
        {
            Caption = 'No. of Quality Tests';
            Description = 'It will show a quality test no. if there is an specification that requires it.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count(QualityTestHeader_PQ where("Source No." = field("Document No."),
                                                                "Source Line No." = field("Line No.")));
        }

        field(50701; "CCS QC Required"; Boolean)
        {
            Caption = 'Quality Test Mandatory';
            Description = 'Informational only';
            DataClassification = CustomerContent;
        }
        field(50702; "Test No."; Code[20])
        {
            CalcFormula = lookup(QualityTestHeader_PQ."Test No." WHERE("Source Type" = const("Sales Order"),
                                                                "Source No." = FIELD("Document No."),
                                                                 "Source Line No." = field("Line No."),
                                                                 "Item No." = field("No.")));
            Caption = 'Quality Test No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}