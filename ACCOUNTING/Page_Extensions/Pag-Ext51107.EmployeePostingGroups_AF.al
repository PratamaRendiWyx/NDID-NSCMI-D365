pageextension 51107 EmployeePostingGroups_AF extends "Employee Posting Groups"
{
    actions
    {
        addlast(Processing)
        {
            // group("&Posting Group")
            // {
            //     Caption = '&Posting Group';
            //     action(Alternative)
            //     {
            //         ApplicationArea = Basic, Suite;
            //         Caption = 'Alternative Groups';
            //         Image = Relationship;
            //         RunObject = Page "Alt. Employee Posting Groups";
            //         RunPageLink = "Employee Posting Group" = field(Code);
            //         ToolTip = 'Specifies alternative Employee posting groups.';
            //         Visible = AltPostingGroupsVisible;
            //     }
            // }
        }
    }

    trigger OnOpenPage()
    begin
        HRSetup.Get();
        AltPostingGroupsVisible := HRSetup."Allow Multiple Posting Groups";
    end;

    var
        HRSetup: Record "Human Resources Setup";
        PmtDiscountVisible: Boolean;
        PmtToleranceVisible: Boolean;
        InvRoundingVisible: Boolean;
        ApplnRoundingVisible: Boolean;
        AltPostingGroupsVisible: Boolean;
        ShowAllAccounts: Boolean;
}
