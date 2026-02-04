tableextension 50710 WorkCenter_PQ extends "Work Center"
{
    fields
    {
        field(50700; "CCS Quality"; Boolean)
        {
            Caption = 'Quality';
            DataClassification = CustomerContent;
        }
        field(50701; "CCS Spec. Type ID"; Code[20])
        {
            Caption = 'Specification No.';
            Description = 'QC 200.02';
            DataClassification = CustomerContent;
            TableRelation = QCSpecificationHeader_PQ.Type where(Status = filter(Certified));
        }
        field(50702; "Current Capacity Need"; Decimal)
        {
            CalcFormula = Sum ("Prod. Order Capacity Need"."Needed Time" WHERE (Type = CONST ("Work Center"),
                                                                               "Work Center No." = FIELD ("No.")));
            Caption = 'Current Capacity Need';
            Description = 'Sum Flow Field to Prod. Order Capacity Need Table.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50703; "Machine Center Count"; Integer)
        {
            CalcFormula = Count ("Machine Center" WHERE ("Work Center No." = FIELD ("No.")));
            Caption = 'Machine Center Count';
            Description = 'Count Flow Field';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50704; "Allocated Time"; Decimal)
        {
            CalcFormula = Sum ("Prod. Order Capacity Need"."Allocated Time" WHERE (Type = CONST ("Machine Center"),
                                                                                  "Work Center No." = FIELD ("No.")));
            Caption = 'Allocated Time';
            Description = 'MP7.0.05 Flowfield Added';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}