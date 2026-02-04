pageextension 50322 SalesOrderList_SP extends "Sales Order List"
{
    actions
    {
        modify(Release)
        {
            trigger OnAfterAction()
            var
                checkCreditLimit: boolean;
            begin
                checkCreditLimit := true;
                if (validation.checkCreditLimit(Rec."No.", Rec."Document Type") = false) then begin
                    rec.Status := enum::"Sales Document Status"::"Pending Credit Limit";
                    rec.Modify();
                    checkCreditLimit := false;
                end;
                if (checkCreditLimit = true) then begin
                    if (validation.checkOverdueBalance(Rec."No.", Rec."Document Type") = false) then begin
                        rec.Status := enum::"Sales Document Status"::"Pending Overdue";
                        rec.Modify();
                        checkCreditLimit := false;
                    end;
                end;
                if (checkCreditLimit = true) then begin
                    rec.Status := enum::"Sales Document Status"::Released;
                    rec.Modify();
                end
                else begin
                    Message('Sorry, transaction is pending and cannot be released.');
                    rec.Modify();
                end;
                CurrPage.Update();
            end;
        }

        addafter(SendApprovalRequest)
        {
            action(SendApprovalRequest1)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request.';
                Enabled = not OpenApprovalEntriesExist and CanRequestApprovalForFlow;
                Image = SendApprovalRequest;
                ToolTip = 'Request approval of the document.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    //validation check credit limir
                    if not validationCheck() then begin
                        CurrPage.Update();
                        exit;
                    end;
                    //-
                    if ApprovalsMgmt.CheckSalesApprovalPossible(Rec) then
                        ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                end;
            }
        }

        modify(SendApprovalRequest)
        {
            Visible = false;
        }

        addafter("Pla&nning")
        {
            action("CheckCLOD")
            {
                ApplicationArea = Planning;
                Caption = 'Check Credit Limit & Overdue.';
                Image = CreateReminders;
                ToolTip = 'Validation Credit Limit & Overdue.';

                trigger OnAction()
                var
                    checkCreditLimit: boolean;
                begin
                    validationCheck();
                    CurrPage.Update();
                end;
            }
        }
    }

    local procedure SetControlVisibility()
    var
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        Clear(ApprovalsMgmt);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;

    local procedure validationCheck(): Boolean
    var
        checkCreditLimit: Boolean;
    begin
        begin
            checkCreditLimit := true;
            if (validation.checkCreditLimit(Rec."No.", Rec."Document Type") = false) then begin
                rec.Status := enum::"Sales Document Status"::"Pending Credit Limit";
                checkCreditLimit := false;
            end;
            if (checkCreditLimit = true) then begin
                if (validation.checkOverdueBalance(Rec."No.", Rec."Document Type") = false) then begin
                    rec.Status := enum::"Sales Document Status"::"Pending Overdue";
                    checkCreditLimit := false;
                end;
            end;
            if not checkCreditLimit then begin
                Message('Sorry, transaction is pending and cannot be released.');
                rec.Modify();
            end;
            exit(checkCreditLimit);
        end;
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        SetControlVisibility();
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        SetControlVisibility();
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        SalesManagement: Codeunit SalesManagement_SP;
    begin
        if not Rec.IsClose then begin
            Clear(SalesManagement);
            SalesManagement.checkCountCompleteInvoicedSO(Rec."No.");
        end;
    end;

    var
        validation: Codeunit CLODValidation_SP;
        FinishEnable: Boolean;
        CanRequestApprovalForFlow: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CanCancelApprovalForFlow: Boolean;
}
