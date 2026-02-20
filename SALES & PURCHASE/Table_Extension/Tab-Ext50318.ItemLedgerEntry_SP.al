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

    trigger OnInsert()
    var
        myInt: Integer;
        LotInformation: Record "Lot No. Information";
    begin
        if "USDFS Code" = '' then begin
            LotInformation.SetRange("Lot No.", "Lot No.");
            LotInformation.SetRange("Item No.", "Item No.");
            if LotInformation.FindFirst() then
                Rec."USDFS Code" := LotInformation."USDFS Code";
        end;
    end;
}
