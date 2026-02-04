tableextension 50319 ItemJournalLine_SP extends "Item Journal Line"
{
    fields
    {
        field(50302; "USDFS Code"; Text[100])
        {
            // AllowInCustomizations = Always;
            Editable = false;
        }
        field(50301; "Box Qty."; Decimal)
        {
            //  AllowInCustomizations = Always;
            Editable = false;
        }
        field(50300; "Shipping Mark No."; Code[20])
        {
            Caption = 'Shipping Mark No.';
            // AllowInCustomizations = Always;
            Editable = false;
        }
    }
}
