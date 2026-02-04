tableextension 50118 UnitofMeasure_FT extends "Unit of Measure"
{
    fields
    {
        field(50100; "UOM Code TAX"; Code[20])
        {
            Caption = 'UOM Code TAX';
            TableRelation = UnitRef_FT.Code;
        }
    }
}
