namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Purchases.Payables;

tableextension 51115 VendorLedgerEntry_AF extends "Vendor Ledger Entry"
{
    fields
    {
        field(51100; "Document No. Before Posting"; Code[20])
        {
            Caption = 'Document No. Before Posting';
            DataClassification = ToBeClassified;
        }
        field(51101; "Gen. Jnl. Line No"; Integer)
        {
            Caption = 'Gen. Jnl. Line No';
            DataClassification = ToBeClassified;
        }
        field(51112; "PIB/PEB No"; Text[100])
        {
            Caption = 'PIB/PEB No';
        }
    }
}
