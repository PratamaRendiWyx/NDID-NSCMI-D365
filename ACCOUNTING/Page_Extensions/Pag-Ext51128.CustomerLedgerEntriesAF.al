pageextension 51128 "Customer Ledger Entries_AF" extends "Customer Ledger Entries"
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
