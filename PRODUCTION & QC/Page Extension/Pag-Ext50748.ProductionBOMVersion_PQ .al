pageextension 50748 ProductionBOMVersion_PQ extends "Production BOM Version"
{

    layout
    {
        modify(Status)
        {
            Style = Strong;
            StyleExpr = TRUE;
        }
        addafter(Description)
        {
            field("Base BOM Comment"; Rec."Base BOM Comment")
            {
                ApplicationArea = All;
                Caption = 'Base BOM Comment';
            }
        }
    }
   
}

