pageextension 50533 "Warehouse Entries_WE" extends "Warehouse Entries"
{
    layout
    {
        addafter("Variant Code")
        {
            field(Operator; Rec.Operator)
            {
                ApplicationArea = All;
            }
            field("Operator Name"; Rec."Operator Name")
            {
                ApplicationArea = All;
            }
        }
    }
}
