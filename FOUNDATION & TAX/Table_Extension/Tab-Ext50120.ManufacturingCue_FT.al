tableextension 50120 ManufacturingCue_FT extends "Manufacturing Cue"
{
    fields
    {
        field(50120; "Prod. Ord. - PC"; Integer)
        {
            CalcFormula = count("Production Order" where(Status = const(Released), "Item Category" = filter('MANTLE')));
            Caption = 'Released Prod. Orders';
            FieldClass = FlowField;
        }
        field(50121; "Prod. Ord. - PT"; Integer)
        {
            CalcFormula = count("Production Order" where(Status = const(Released), "Item Category" = filter('AST BFA' | 'AST CF' | 'AST FF')));
            Caption = 'Released Prod. Orders';
            FieldClass = FlowField;
        }
        field(50122; "Prod. Ord. - AF"; Integer)
        {
            CalcFormula = count("Production Order" where(Status = const(Released), "Item Category" = filter('ANTIFLOW')));
            Caption = 'Released Prod. Orders';
            FieldClass = FlowField;
        }
        field(50123; "Prod. Ord. - BPM"; Integer)
        {
            CalcFormula = count("Production Order" where(Status = const(Released), "Item Category" = filter('BP MIX')));
            Caption = 'Released Prod. Orders';
            FieldClass = FlowField;
        }
        field(50124; "Prod. Ord. - FINISHED GOOD"; Integer)
        {
            CalcFormula = count("Production Order" where(Status = const(Released), "Item Category" = filter('FINISHED GOOD')));
            Caption = 'Released Prod. Orders';
            FieldClass = FlowField;
        }
        field(50125; "NS"; Integer)
        {
            CalcFormula = count("Production Order" where(Status = const(Released), "Item Category" = filter('NS')));
            Caption = 'Released Prod. Orders';
            FieldClass = FlowField;
        }
    }
}
