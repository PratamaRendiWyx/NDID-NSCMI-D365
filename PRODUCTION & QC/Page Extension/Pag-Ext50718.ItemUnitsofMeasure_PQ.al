pageextension 50718 ItemUnitsofMeasure_PQ extends "Item Units of Measure"
{
    layout
    {
        addafter(Code)
        {
            field("Default Transfer UOM";Rec."Default Transfer UOM")
            {
                ApplicationArea = All;
            }
        }
    }
}
