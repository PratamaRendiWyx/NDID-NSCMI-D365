pageextension 50129 FALedgerEntries_FT extends "FA Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Serial No."; Rec."Serial No.")
            {
                ApplicationArea = FixedAssets;
                Editable = false;
            }
        }
    }
}
