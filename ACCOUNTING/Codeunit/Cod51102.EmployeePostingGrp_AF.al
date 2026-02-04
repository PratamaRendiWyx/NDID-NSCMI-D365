codeunit 51102 EmployeePostingGrp_AF
{
    var
        CannotChangePostingGroupErr: Label 'You cannot change the value %1 to %2 because %3 has not been filled in.', Comment = '%1 = old posting group; %2 = new posting group; %3 = tablecaption of Subst. Vendor/Customer Posting Group';

    procedure CheckPostingGroupChangeInGenJnlLine(NewPostingGroup: Code[20]; OldPostingGroup: Code[20]; var GenJournalLine: Record "Gen. Journal Line")
    begin
        case GenJournalLine."Account Type" of
            GenJournalLine."Account Type"::Employee:
                CheckEmployeePostingGroupChangeAndEmployee(NewPostingGroup, OldPostingGroup, GenJournalLine."Account No.");
            else
                GenJournalLine.FieldError(GenJournalLine."Account Type");
        end;
    end;

    procedure CheckAllowChangeEmployeeSetup()
    var
        HrSetup: Record "Human Resources Setup";
    begin
        HrSetup.Get();
        HrSetup.TestField("Allow Multiple Posting Groups");
        HrSetup.TestField("Check Multiple Posting Groups", HrSetup."Check Multiple Posting Groups"::"Alternative Groups");
    end;

    procedure HasEmployeeSamePostingGroup(NewPostingGroup: Code[20]; EmployeeNo: Code[20]): Boolean
    var
        Employee: Record Employee;
    begin
        if Employee.Get(EmployeeNo) then
            exit(NewPostingGroup = Employee."Employee Posting Group");
        exit(false);
    end;

    local procedure CheckEmployeePostingGroupChangeAndEmployee(NewPostingGroup: Code[20]; OldPostingGroup: Code[20]; EmployeeNo: Code[20])
    begin
        CheckAllowChangeEmployeeSetup();
        if not HasEmployeeSamePostingGroup(NewPostingGroup, EmployeeNo) then
            CheckEmployeePostingGroupSubstSetup(NewPostingGroup, OldPostingGroup);
    end;

    local procedure CheckEmployeePostingGroupSubstSetup(NewPostingGroup: Code[20]; OldPostingGroup: Code[20])
    var
        AltEmployeePostingGroup: Record "Alt. Employee Posting Group";
    begin
        if not AltEmployeePostingGroup.Get(OldPostingGroup, NewPostingGroup) then
            Error(CannotChangePostingGroupErr, OldPostingGroup, NewPostingGroup, AltEmployeePostingGroup.TableCaption());
    end;
}
