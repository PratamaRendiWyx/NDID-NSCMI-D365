tableextension 50734 ProductionBOMVersion_PQ extends "Production BOM Version"
{

    fields
    {
        field(50700; "Base BOM Comment"; Boolean)
        {
            CalcFormula = Exist ("Manufacturing Comment Line" WHERE ("Table Name" = CONST ("Production BOM Header"),
                                                                    "No." = FIELD ("Production BOM No.")));
            Caption = 'Base BOM Comment';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}