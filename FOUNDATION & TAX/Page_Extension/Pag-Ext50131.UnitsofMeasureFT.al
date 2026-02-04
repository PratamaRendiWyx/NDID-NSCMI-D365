pageextension 50131 UnitsofMeasure_FT extends "Units of Measure"
{
    layout
    {
        addafter(Description)
        {
            field("UOM Code TAX"; Rec."UOM Code TAX")
            {
                ApplicationArea = All;
            }
        }
    }
}
