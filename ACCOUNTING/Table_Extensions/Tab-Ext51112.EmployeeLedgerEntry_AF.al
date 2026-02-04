namespace ACCOUNTING.ACCOUNTING;

using Microsoft.HumanResources.Payables;

tableextension 51112 EmployeeLedgerEntry_AF extends "Employee Ledger Entry"
{

    procedure DrillDownOnEntries(var DtldEmpLedgEntry: Record "Detailed Employee Ledger Entry")
    var
        EmpLedgEntry: Record "Employee Ledger Entry";
        DrillDownPageID: Integer;
    begin
        EmpLedgEntry.Reset();
        DtldEmpLedgEntry.CopyFilter("Employee No.", EmpLedgEntry."Employee No.");
        DtldEmpLedgEntry.CopyFilter("Currency Code", EmpLedgEntry."Currency Code");
        DtldEmpLedgEntry.CopyFilter("Initial Entry Global Dim. 1", EmpLedgEntry."Global Dimension 1 Code");
        DtldEmpLedgEntry.CopyFilter("Initial Entry Global Dim. 2", EmpLedgEntry."Global Dimension 2 Code");
        EmpLedgEntry.SetCurrentKey("Employee No.", "Posting Date");
        EmpLedgEntry.SetRange(Open, true);
        OnBeforeDrillDownEntries(EmpLedgEntry, DtldEmpLedgEntry, DrillDownPageID);
        PAGE.Run(DrillDownPageID, EmpLedgEntry);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDrillDownEntries(var EmployeeLedgerEntry: Record "Employee Ledger Entry"; var DetailedEmployeeLedgEntry: Record "Detailed Employee Ledger Entry"; var DrillDownPageID: Integer)
    begin
    end;
}
