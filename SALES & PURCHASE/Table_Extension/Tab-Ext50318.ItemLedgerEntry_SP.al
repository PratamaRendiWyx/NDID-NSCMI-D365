tableextension 50318 ItemLedgerEntry_SP extends "Item Ledger Entry"
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
            // AllowInCustomizations = Always;
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
