tableextension 51121 "Item Ledger Entry_WH" extends "Item Ledger Entry"
{
    keys
    {
        key(K0; "Posting Date") { }
        key(K99; "Item No.", "Posting Date", "Lot No.") { }
        key(K88; "Posting Date", "Lot No.") { }
    }
}
