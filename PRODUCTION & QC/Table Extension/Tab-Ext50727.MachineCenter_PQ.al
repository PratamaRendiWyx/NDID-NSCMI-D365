tableextension 50727 MachineCenter_PQ extends "Machine Center"
{

    fields
    {
        field(50700; "Current Capacity Need"; Decimal)
        {
            CalcFormula = Sum ("Prod. Order Capacity Need"."Needed Time" WHERE (Type = CONST ("Machine Center"),
                                                                               "No." = FIELD ("No.")));
            Caption = 'Current Capacity Need';
            Description = 'Sum("Prod. Order Capacity Need"."Needed Time" WHERE (Type=CONST(Machine Center),No.=FIELD(No.)))';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50701; "Allocated Time"; Decimal)
        {
            CalcFormula = Sum ("Prod. Order Capacity Need"."Allocated Time" WHERE ("No." = FIELD ("No.")));
            Caption = ' Allocated Time';
            Description = 'MP7.0.05 FlowField Added';
            FieldClass = FlowField;
        }
    }
}

