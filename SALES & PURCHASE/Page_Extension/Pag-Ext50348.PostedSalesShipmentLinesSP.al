pageextension 50348 "Posted Sales Shipment Lines_SP" extends "Posted Sales Shipment Lines"
{
    layout
    {
        addafter("Quantity Invoiced")
        {
            field("Status Approval"; Rec."Status Approval")
            {
                ApplicationArea = All;
            }
            //QC Worker info
            field("QC By"; Rec."QC By")
            {
                ApplicationArea = All;
                Visible = GlbCheckQCWorkerPermission;
            }
            field("QC Date"; Rec."QC Date")
            {
                ApplicationArea = All;
                Visible = GlbCheckQCWorkerPermission;
            }
            field("Comment Line QC Worker"; Rec."Comment Line QC Worker")
            {
                ApplicationArea = All;
                Visible = GlbCheckQCWorkerPermission;
            }
            //-
            //Approver info
            field("Approval By"; Rec."Approval By")
            {
                ApplicationArea = All;
                Visible = GlbCheckApproverPermission;
            }
            field("Approval Date"; Rec."Approval Date")
            {
                ApplicationArea = All;
                Visible = GlbCheckApproverPermission;
            }
            field("Comment Line"; Rec."Comment Line")
            {
                ApplicationArea = All;
                Visible = GlbCheckApproverPermission;
            }
            //-
        }
    }

    actions
    {
        addafter(Dimensions)
        {
            action(ApproverAction)
            {
                ApplicationArea = All;
                Caption = 'Approval Action';
                Image = Approvals;
                ToolTip = 'Approval Action (Approve | Reject).';
                Visible = GlbCheckApproverPermission;
                trigger OnAction()
                var
                    myInt: Integer;
                    ApproverAction: Report ApproverActionSalesShipment_PQ;
                    salesShipmentLines: Record "Sales Shipment Line";
                    glbTest: Integer;
                begin
                    CurrPage.SetSelectionFilter(salesShipmentLines);
                    // salesShipmentLines.Copy(Rec);
                    salesShipmentLines.SetRange("Status Approval", salesShipmentLines."Status Approval"::"Ready for Review");
                    glbTest := salesShipmentLines.Count();
                    if salesShipmentLines.FindSet() then begin
                        ApproverAction.UseRequestPage(true);
                        ApproverAction.setParameter(salesShipmentLines);
                        ApproverAction.RunModal();
                    end else begin
                        Message('Nothing to handle.');
                    end;
                end;
            }
            action(QCWorkerAction)
            {
                ApplicationArea = All;
                Caption = 'QC Worker Action';
                Image = QualificationOverview;
                ToolTip = 'Flagging status - Sales Shipment Line.';
                Visible = GlbCheckQCWorkerPermission;
                trigger OnAction()
                var
                    myInt: Integer;
                    QcWorkerAction: Report QCActionSalesShipment_PQ;
                    salesShipmentLines: Record "Sales Shipment Line";
                    glbTest: Integer;
                begin
                    CurrPage.SetSelectionFilter(salesShipmentLines);
                    salesShipmentLines.Setfilter("Status Approval", '%1|%2|%3|%4', salesShipmentLines."Status Approval"::Open, salesShipmentLines."Status Approval"::"In Process", salesShipmentLines."Status Approval"::Rejected, salesShipmentLines."Status Approval"::"Ready for Review");
                    glbTest := salesShipmentLines.Count();
                    if salesShipmentLines.FindSet() then begin
                        QcWorkerAction.UseRequestPage(true);
                        QcWorkerAction.setParameter(salesShipmentLines);
                        QcWorkerAction.RunModal();
                    end else begin
                        Message('Nothing to handle.');
                    end;
                end;
            }
        }
    }

    local procedure checkApproval(): Boolean
    var
        userSetup: Record "User Setup";
    begin
        if userSetup.Get(UserId) then begin
            if userSetup."Is Approver COA" then
                GlbCheckApproverPermission := true;
        end;
    end;

    local procedure mainProcess()
    begin
        checkApproval();
        checkQCWorkerPermission();
    end;

    local procedure checkQCWorkerPermission(): Boolean
    var
        userSetup: Record "User Setup";
    begin
        if userSetup.Get(UserId) then begin
            if userSetup."QC Worker" then
                GlbCheckQCWorkerPermission := true;
        end;
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        mainProcess();
    end;

    var
        GlbCheckApproverPermission: Boolean;
        GlbCheckQCWorkerPermission: Boolean;
}
