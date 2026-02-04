pageextension 51131 "Lot No. Information List_AF" extends "Lot No. Information List"
{
    layout
    {
        addafter(Description)
        {
            field(Inventory1; Rec.Inventory1)
            {
                ApplicationArea = All;
                Caption = 'Inventory.';
            }
        }
    }
}
