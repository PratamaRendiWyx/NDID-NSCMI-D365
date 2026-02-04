pageextension 51127 "Vendor Ledger Entries_AF" extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("External Document No.")
        {
            field("PIB/PEB No"; Rec."PIB/PEB No")
            {
                ApplicationArea = All;
                Editable = true;
            }
        }
    }
}
