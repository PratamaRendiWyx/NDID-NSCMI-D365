tableextension 50317 ReservationEntry_SP extends "Reservation Entry"
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

        }
        field(50300; "Shipping Mark No."; Code[20])
        {
            Caption = 'Shipping Mark No.';
            // AllowInCustomizations = Always;
            Editable = false;
        }
    }
}
