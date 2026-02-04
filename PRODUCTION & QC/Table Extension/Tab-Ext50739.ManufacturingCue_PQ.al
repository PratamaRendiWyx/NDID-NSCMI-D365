tableextension 50739 ManufacturingCue_PQ extends "Manufacturing Cue"
{
    fields
    {

        field(50700; "Prod. Ord. - CWS"; Integer)
        {
            CalcFormula = count("Production Order" where(Status = const(Released), "Item Category" = filter('FG BEFORE VACUUM'),"Product Type" = filter('STD')));
            Caption = 'Released Prod. Orders';
            FieldClass = FlowField;
        }
        field(50701; "Prod. Ord. - CWBV"; Integer)
        {
            CalcFormula = count("Production Order" where(Status = const(Released), "Item Category" = filter('FG BEFORE VACUUM'),"Product Type" = filter('BFA'|'VA')));
            Caption = 'Released Prod. Orders';
            FieldClass = FlowField;
        } 
    }
}