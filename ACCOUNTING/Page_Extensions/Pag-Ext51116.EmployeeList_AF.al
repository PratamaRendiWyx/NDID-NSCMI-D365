namespace ACCOUNTING.ACCOUNTING;

using Microsoft.HumanResources.Employee;

pageextension 51116 EmployeeList_AF extends "Employee List"
{
    layout
    {
        modify("Balance (LCY)")
        {
            trigger OnDrillDown()
            begin
                Rec.OpenEmployeeLedgerEntries(false);
            end;
        }
    }
}
