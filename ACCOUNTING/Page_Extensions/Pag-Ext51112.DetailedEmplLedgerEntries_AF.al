namespace ACCOUNTING.ACCOUNTING;

using Microsoft.HumanResources.Payables;

pageextension 51112 DetailedEmplLedgerEntries_AF extends "Detailed Empl. Ledger Entries"
{
    layout
    {
        addafter("Currency Code")
        {
            // field("Posting Group"; Rec."Posting Group")
            // {
            //     ApplicationArea = All;
            //     Editable = false;
            // }
        }
    }
}
