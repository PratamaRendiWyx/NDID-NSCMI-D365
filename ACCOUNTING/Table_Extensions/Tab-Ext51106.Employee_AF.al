namespace ACCOUNTING.ACCOUNTING;

using Microsoft.HumanResources.Employee;
using Microsoft.HumanResources.Payables;

tableextension 51106 Employee_AF extends Employee
{
    fields
    {
        // field(51103; "Allow Multiple Posting Groups"; Boolean)
        // {
        //     Caption = 'Allow Multiple Posting Groups';
        //     DataClassification = SystemMetadata;
        // }
    }

    procedure OpenEmployeeLedgerEntries(FilterOnDueEntries: Boolean)
    var
        DetailedEmployeeLedgEntry: Record "Detailed Employee Ledger Entry";
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        IsHandled: Boolean;
    begin
        OnBeforeOpenEmployeeLedgerEntries(Rec, DetailedEmployeeLedgEntry);
        DetailedEmployeeLedgEntry.SetRange("Employee No.", "No.");
        CopyFilter("Global Dimension 1 Filter", DetailedEmployeeLedgEntry."Initial Entry Global Dim. 1");
        CopyFilter("Global Dimension 2 Filter", DetailedEmployeeLedgEntry."Initial Entry Global Dim. 2");
        if FilterOnDueEntries and (GetFilter("Date Filter") <> '') then begin
            DetailedEmployeeLedgEntry.SetFilter("Posting Date", '<=%1', GetRangeMax("Date Filter"));
        end;
        CopyFilter("Currency Filter", DetailedEmployeeLedgEntry."Currency Code");
        IsHandled := false;
        OnOpenVendorLedgerEntriesOnBeforeDrillDownEntries(DetailedEmployeeLedgEntry, FilterOnDueEntries, IsHandled);
        if not IsHandled then
            EmployeeLedgerEntry.DrillDownOnEntries(DetailedEmployeeLedgEntry);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOpenEmployeeLedgerEntries(var Employee: Record Employee; var DetailedEmployeeLedgEntry: Record "Detailed Employee Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnOpenVendorLedgerEntriesOnBeforeDrillDownEntries(var DetailedEmployeeLedgEntry: Record "Detailed Employee Ledger Entry"; FilterOnDueEntries: Boolean; var IsHandled: Boolean)
    begin
    end;

}
