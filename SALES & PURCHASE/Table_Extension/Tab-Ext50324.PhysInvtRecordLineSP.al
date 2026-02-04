tableextension 50324 "Phys. Invt. Record Line_SP" extends "Phys. Invt. Record Line"
{
    fields
    {
        field(50302; "USDFS Code"; Text[100])
        {
            // AllowInCustomizations = Always;
            // Editable = false;
        }
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
                ItemLedgerEntry: Record "Item Ledger Entry";
            begin
                Clear(ItemLedgerEntry);
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
                ItemLedgerEntry.SetRange("Location Code", Rec."Location Code");
                ItemLedgerEntry.SetRange("Lot No.", Rec."Lot No.");
                ItemLedgerEntry.SetFilter("Package No.", '<>%1', '');
                if ItemLedgerEntry.FindFirst() then
                    "Package No." := ItemLedgerEntry."Package No.";

                Clear(ItemLedgerEntry);
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
                ItemLedgerEntry.SetRange("Location Code", Rec."Location Code");
                ItemLedgerEntry.SetRange("Lot No.", Rec."Lot No.");
                ItemLedgerEntry.SetFilter("USDFS Code", '<>%1', '');
                if ItemLedgerEntry.FindFirst() then
                    "USDFS Code" := ItemLedgerEntry."USDFS Code";
            end;
        }
    }
}
