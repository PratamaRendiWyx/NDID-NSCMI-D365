namespace ACCOUNTING.ACCOUNTING;

using Microsoft.HumanResources.Employee;
using Microsoft.HumanResources.Setup;

pageextension 51105 EmployeeCard_AF extends "Employee Card"
{
    layout
    {
        addafter("Employee Posting Group")
        {
            // field("Allow Multiple Posting Groups"; Rec."Allow Multiple Posting Groups")
            // {
            //     ApplicationArea = Basic, Suite;
            //     Importance = Additional;
            //     ToolTip = 'Specifies if multiple posting groups can be used for posting business transactions for this employee.';
            //     Visible = IsAllowMultiplePostingGroupsVisible;
            // }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        HrSetup.Get();
        IsAllowMultiplePostingGroupsVisible := HrSetup."Allow Multiple Posting Groups";
    end;

    var
        IsAllowMultiplePostingGroupsVisible: Boolean;
        HrSetup: Record "Human Resources Setup";
}
