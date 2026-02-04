pageextension 50302 SalesOrder_SP extends "Sales Order"
{
    layout
    {
        addafter(Status)
        {
            field(IsClose; Rec.IsClose)
            {
                ApplicationArea = Basic, Suite;
                Enabled = false;
            }
        }

        addafter(Status)
        {
            field("Approved By"; Rec."Approved By")
            {
                ApplicationArea = All;
            }
            field("Approver Name"; Rec."Approver Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("Checked By"; Rec."Checked By")
            {
                ApplicationArea = All;
            }
            field("Checker Name"; Rec."Checker Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
        }

        modify("Shipment Method Code")
        {
            Caption = 'Incoterms';
        }

        modify("Shipment Method")
        {
            Visible = false;
        }
        addbefore("Shipment Method")
        {
            field("Sales Type"; Rec."Sales Type")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("&Print")
        {
            action("&Print1")
            {
                ApplicationArea = Suite;
                Caption = '&Print.';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    CurrPage.SetSelectionFilter(SalesHeader);
                    REPORT.Run(REPORT::"Sales Order", true, false, SalesHeader);
                end;
            }
        }
        addlast(processing)
        {
            action("Finish")
            {
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Process;
                Image = ChangeTo;
                Enabled = FinishEnable;
                Visible = FinishEnable;
                Caption = 'Close Sales Order';
                ToolTip = 'Finalize the order quantities.';

                trigger OnAction()
                begin
                    Rec.Finish();
                    CurrPage.Update();
                end;
            }
        }

        modify(release)
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

        addafter("F&unctions")
        {
            action("CheckCLOD")
            {
                ApplicationArea = Suite;
                Caption = 'Check Credit Limit & Overdue.';
                Image = CreateReminders;
                ToolTip = 'Validation Credit Limit & Overdue.';
                //Enabled = Not (Rec.Status = Rec.Status::Released);
                trigger OnAction()
                var
                    checkCreditLimit: boolean;
                begin
                    CheckSalesHeaderPendingApproval(Rec);
                    validationCheck();
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        SalesManagement: Codeunit SalesManagement_SP;
    begin
        SetControlVisibility();
        if not Rec.IsClose then begin
            Clear(SalesManagement);
            SalesManagement.checkCountCompleteInvoicedSO(Rec."No.");
        end;
    end;

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
            if (checkCreditLimit = true) then begin
                rec.Status := enum::"Sales Document Status"::Released;
                rec.Modify();
            end
            else begin
                Message('Sorry, transaction is pending and cannot be released.');
                rec.Modify();
            end;
            exit(checkCreditLimit);
        end;
    end;

    local procedure CheckSalesHeaderPendingApproval(var SalesHeader: Record "Sales Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        IsHandled: Boolean;
    begin
        if ApprovalsMgmt.IsSalesHeaderPendingApproval(SalesHeader) then
            Error(Text002);
    end;

    trigger OnOpenPage()
    var
        EnableOrderCompletion: Codeunit EnableOrderCompletion_SP;
    begin
        FinishEnable := EnableOrderCompletion.FinishOrdersSalesEnabled();
        SetControlVisibility();
    end;



    var
        FinishEnable: Boolean;
        validation: Codeunit CLODValidation_SP;
        CanRequestApprovalForFlow: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CanCancelApprovalForFlow: Boolean;

        Text002: Label 'This document can only be released when the approval process is complete.';


}