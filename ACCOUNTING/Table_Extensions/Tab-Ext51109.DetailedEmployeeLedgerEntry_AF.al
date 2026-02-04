namespace ACCOUNTING.ACCOUNTING;

using Microsoft.HumanResources.Payables;

tableextension 51109 DetailedEmployeeLedgerEntry_AF extends "Detailed Employee Ledger Entry"
{
    fields
    {
        // field(51100; "Posting Group"; Code[20])
        // {
        //     Caption = 'Posting Group';
        //     CalcFormula = lookup("Employee Ledger Entry"."Employee Posting Group"
        //     where("Entry No." = field("Employee Ledger Entry No."), "Employee No." = field("Employee No.")));
        //     FieldClass = FlowField;
        // }
    }
}
