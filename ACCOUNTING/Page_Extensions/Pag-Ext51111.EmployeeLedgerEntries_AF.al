namespace ACCOUNTING.ACCOUNTING;

using Microsoft.HumanResources.Payables;

pageextension 51111 EmployeeLedgerEntries_AF extends "Employee Ledger Entries"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Employee Posting Group"; Rec."Employee Posting Group")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
