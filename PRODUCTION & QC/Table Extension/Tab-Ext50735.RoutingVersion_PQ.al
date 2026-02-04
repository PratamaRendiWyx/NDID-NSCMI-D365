tableextension 50735 RoutingVersion_PQ extends "Routing Version"
{
    fields
    {
        field(50700; "Base Routing Comments"; Boolean)
        {
            CalcFormula = Exist ("Manufacturing Comment Line" WHERE ("Table Name" = CONST ("Routing Header"),
                                                                    "No." = FIELD ("Routing No.")));
            Caption = 'Base Routing Comments';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}