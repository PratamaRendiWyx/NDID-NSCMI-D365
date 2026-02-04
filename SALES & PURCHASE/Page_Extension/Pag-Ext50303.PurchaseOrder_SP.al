pageextension 50303 PurchaseOrder_SP extends "Purchase Order"
{
    layout
    {
        addbefore(Status)
        {
            field(IsClose; Rec.IsClose)
            {
                ApplicationArea = Basic, Suite;
                Enabled = false;
            }
        }
        addafter(Status)
        {
            field("PO Type"; Rec."PO Type")
            {
                ApplicationArea = All;
            }
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = All;
            }
            field("Same Price"; Rec."Same Price")
            {
                ApplicationArea = All;
            }
            field("GM Approval Only"; Rec."GM Approval Only")
            {
                ApplicationArea = All;
            }
            field(Notes; Rec.Notes)
            {
                Caption = 'Notes';
                ApplicationArea = All;
                MultiLine = true;
            }
            field(Application; Rec.Application)
            {
                ApplicationArea = All;
            }
            //Responder PO
            field("Acknowledged by"; Rec."Acknowledged by")
            {
                ApplicationArea = All;
            }
            field("Acknowledger Name"; Rec."Acknowledger Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
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
            field("Issued By"; Rec."Issued By")
            {
                ApplicationArea = All;
            }
            field("Issuer Name"; Rec."Issuer Name")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("Approved By 2"; Rec."Approved By 2")
            {
                ApplicationArea = All;
            }
            field("Accounting Mgr. Name"; Rec."Accounting Mgr. Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            //-
            field(Rev; Rec.Rev)
            {
                ApplicationArea = All;
            }
        }
        modify("Your Reference")
        {
            Visible = true;
            Editable = true;
        }
    }
    actions
    {
        addlast(processing)
        {
            action("Finish")
            {
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Process;
                Image = ChangeTo;
                Enabled = FinishEnable AND (Rec.Status = Rec.Status::Released);
                Visible = FinishEnable;
                Caption = 'Close Purchase Order';
                ToolTip = 'Finalize the order quantities.';

                trigger OnAction()
                begin
                    Rec.Finish();
                    CurrPage.Update();
                end;
            }
        }
        // Add changes to page actions here
        addafter("P&osting")
        {
            group(SubConProcess)
            {
                Caption = 'Vendor DO';
                Image = ApplyTemplate;

                action(PostSubCon)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Vendor DO';
                    Image = AddAction;
                    ToolTip = 'Process posting Vendor DO.';
                    Enabled = (Rec.Status = Rec.Status::Released); //AND (Rec."PO Type" = Rec."PO Type"::Replacement);
                    trigger OnAction()
                    var
                        Text001: Text;
                    begin
                        Text001 := 'Are you sure want to post ?';
                        if Confirm(Text001) then begin
                            validataionandPostLine(Rec."No.");
                        end;
                        CurrPage.Update();
                    end;
                }
            }
        }
        addafter(Print)
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
                    PurchaseHeader: Record "Purchase Header";
                    ReportLayoutSelection: Record "Report Layout Selection";
                begin
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    REPORT.Run(REPORT::"Purchase Order", true, false, PurchaseHeader);
                end;
            }
            action("&Print2")
            {
                ApplicationArea = Suite;
                Caption = '&Print (Prepayment).';
                Ellipsis = true;
                Visible = false;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    ReportLayoutSelection: Record "Report Layout Selection";
                begin
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    REPORT.Run(REPORT::"Purchase Order - Prepayment", true, false, PurchaseHeader);
                end;
            }

            action("&PrintSuratJalan")
            {
                ApplicationArea = Suite;
                Caption = '&Print Surat Jalan';
                Ellipsis = true;
                Image = Print;
                //ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';
                trigger OnAction()
                begin
                    //
                end;
            }
            action("&SendMail")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send Email (PO)';
                Ellipsis = true;
                Image = SendEmailPDF;
                ToolTip = 'Send email.';
                trigger OnAction()
                var
                    ReportExample: Report "Purchase Order";
                    Email: Codeunit Email;
                    EmailMessage: Codeunit "Email Message";
                    TempBlob: Codeunit "Temp Blob";
                    InStr: Instream;
                    OutStr: OutStream;
                    ReportParameters: Text;
                    PurchaseHeader: Record "Purchase Header";
                    MailSent: Boolean;
                    SubJectEmail: Text;
                    CustomLayoutReporting: Codeunit "Custom Layout Reporting";
                    LastUsedParameters: Text;
                    var_reportID: Integer;
                    Contact: Record Contact;
                    SendToEmail: Text;
                begin
                    //Send email
                    Clear(Contact);
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    if PurchaseHeader.FindSet() then
                        ReportExample.SetTableView(PurchaseHeader);

                    var_reportID := Report::"Purchase Order";

                    Contact.SetRange("No.", PurchaseHeader."Buy-from Contact No.");
                    if Contact.Find('-') then
                        SendToEmail := Contact."E-Mail";
                    SubJectEmail := 'NIPPON STEEL CHEMICAL AND MATERIAL';
                    SubJectEmail := SubJectEmail + ' - ' + 'Purchase Order ' + PurchaseHeader."No.";
                    TempBlob.CreateOutStream(OutStr);
                    ReportParameters := ReportExample.RunRequestPage();
                    if ReportParameters <> '' then begin
                        Report.SaveAs(var_reportID, ReportParameters, ReportFormat::Pdf, OutStr);
                        TempBlob.CreateInStream(InStr);

                        EmailMessage.Create(SendToEmail, SubJectEmail, '', true);
                        EmailMessage.AddAttachment('Purchase Order -' + PurchaseHeader."No." + '.pdf', 'PDF', InStr);
                        Email.OpenInEditor(EmailMessage, Enum::"Email Scenario"::Default);
                    end;
                end;
            }
            action("&SendMailPrepayment")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send Email (PO) - Prepayment';
                Ellipsis = true;
                Visible = false;
                Image = SendEmailPDF;
                ToolTip = 'Send email.';
                trigger OnAction()
                var
                    ReportExample: Report "Purchase Order";
                    Email: Codeunit Email;
                    EmailMessage: Codeunit "Email Message";
                    TempBlob: Codeunit "Temp Blob";
                    InStr: Instream;
                    OutStr: OutStream;
                    ReportParameters: Text;
                    PurchaseHeader: Record "Purchase Header";
                    MailSent: Boolean;
                    SubJectEmail: Text;
                    CustomLayoutReporting: Codeunit "Custom Layout Reporting";
                    LastUsedParameters: Text;
                    var_reportID: Integer;
                    Contact: Record Contact;
                    SendToEmail: Text;
                begin
                    //Send email
                    Clear(Contact);
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    if PurchaseHeader.FindSet() then
                        ReportExample.SetTableView(PurchaseHeader);

                    var_reportID := Report::"Purchase Order - Prepayment";

                    Contact.SetRange("No.", PurchaseHeader."Buy-from Contact No.");
                    if Contact.Find('-') then
                        SendToEmail := Contact."E-Mail";
                    SubJectEmail := 'NIPPON STEEL CHEMICAL AND MATERIAL';
                    SubJectEmail := SubJectEmail + ' - ' + 'Purchase Order ' + PurchaseHeader."No.";
                    TempBlob.CreateOutStream(OutStr);
                    ReportParameters := ReportExample.RunRequestPage();
                    if ReportParameters <> '' then begin
                        Report.SaveAs(var_reportID, ReportParameters, ReportFormat::Pdf, OutStr);
                        TempBlob.CreateInStream(InStr);

                        EmailMessage.Create(SendToEmail, SubJectEmail, '', true);
                        EmailMessage.AddAttachment('Purchase Order -' + PurchaseHeader."No." + '.pdf', 'PDF', InStr);
                        Email.OpenInEditor(EmailMessage, Enum::"Email Scenario"::Default);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        EnableOrderCompletion: Codeunit EnableOrderCompletion_SP;
    begin
        FinishEnable := EnableOrderCompletion.FinishOrdersPurchaseEnabled();
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        PurchManagement: Codeunit PurchManagement_SP;
    begin
        if not Rec.IsClose then begin
            Clear(PurchManagement);
            PurchManagement.checkCountCompleteInvoicedPO(Rec."No.");
        end;
    end;

    local procedure validataionandPostLine(iNo: Text): Record "Purchase Line"
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(PurchaseLine);
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange("Document No.", iNo);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetFilter("Qty. to Ship", '<>0');
        if PurchaseLine.FindSet() then begin
            repeat
                PurchaseLine.CalcFields("Quantity Shipped");
                if (PurchaseLine."Qty. to Ship" > PurchaseLine.Quantity) OR ((PurchaseLine."Qty. to Ship" + PurchaseLine."Quantity Shipped") > PurchaseLine.Quantity) then
                    Error('Error, Qty to ship can''t greather then Quantity, Line No. [%1].', PurchaseLine."Line No.");
                if PurchaseLine.Quantity = PurchaseLine."Quantity Shipped" then
                    Error('Error, Qty. Line Already shipped, Qty. PO (%1) =  Quantity Shipped (%2).', PurchaseLine.Quantity, PurchaseLine."Quantity Shipped");
                //Mark
                PurchaseLine.Mark(true);
            until PurchaseLine.Next() = 0;
            //posting document
            PurchaseLine.MarkedOnly(true);
            postingDocument(PurchaseLine);
        end;
    end;

    local procedure postingDocument(var ipurchaseLine: Record "Purchase Line")
    var
        v_guid: Guid;
        counter: Integer;
        NoSeriesMgt: Codeunit "No. Series";
        DocumentNoSeries: Text;
        PostedPurchSubConHeader: Record "Posted DO Header";
        PostedPurchSubConLine: Record "Posted DO Line";
        PurchaseHeader: Record "Purchase Header";
        PurchasePayableSetup: Record "Purchases & Payables Setup";
    begin
        Clear(PurchasePayableSetup);
        PurchasePayableSetup.Get();

        Clear(NoSeriesMgt);
        if ipurchaseLine.FindSet() then begin
            Clear(PurchaseHeader);
            PurchaseHeader.Reset();
            PurchaseHeader.SetRange("No.", ipurchaseLine."Document No.");
            if PurchaseHeader.FindSet() then;
            //gnerate no series
            DocumentNoSeries := NoSeriesMgt.GetNextNo(PurchasePayableSetup."Posted Sub Cont. Nos.", WorkDate(), true);
            Clear(PostedPurchSubConLine);
            PostedPurchSubConLine.Reset();
            Clear(PostedPurchSubConHeader);
            PostedPurchSubConHeader.Reset();
            PostedPurchSubConHeader.Init();
            PostedPurchSubConHeader."No." := DocumentNoSeries;
            PostedPurchSubConHeader."Ship-to Vendor No." := PurchaseHeader."Buy-from Vendor No.";
            PostedPurchSubConHeader."Ship-to Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
            PostedPurchSubConHeader."Ship-to Vendor Name 2" := PurchaseHeader."Buy-from Vendor Name 2";
            PostedPurchSubConHeader."Order No." := PurchaseHeader."No.";
            PostedPurchSubConHeader."Posting Date" := PurchaseHeader."Posting Date";
            PostedPurchSubConHeader."Document Date" := PurchaseHeader."Document Date";
            PostedPurchSubConHeader."Ship-to Address" := PurchaseHeader."Buy-from Address";
            PostedPurchSubConHeader."Ship-to Address 2" := PurchaseHeader."Buy-from Address 2";
            PostedPurchSubConHeader."Ship-to Contact" := PurchaseHeader."Buy-from Contact";
            PostedPurchSubConHeader."Ship-to Contact No." := PurchaseHeader."Buy-from Contact No.";
            //ship
            PostedPurchSubConHeader."Shipment Method Code" := PurchaseHeader."Shipment Method Code";
            PostedPurchSubConHeader.Notes := PurchaseHeader.Notes;
            PostedPurchSubConHeader."Additional Notes" := PurchaseHeader."Additional Notes";

            repeat
                //post shipment sub contract
                Clear(v_guid);
                v_guid := CreateGuid();
                counter := counter + 1;
                PostedPurchSubConLine.Init();
                PostedPurchSubConLine.ID := v_guid;
                PostedPurchSubConLine."Line No." := counter;
                PostedPurchSubConLine."Posting Date" := WorkDate();
                PostedPurchSubConLine."Order No." := ipurchaseLine."Document No.";
                PostedPurchSubConLine."Document No." := DocumentNoSeries;
                PostedPurchSubConLine."Order Line No." := ipurchaseLine."Line No.";
                PostedPurchSubConLine.Quantity := ipurchaseLine."Qty. to Ship";
                PostedPurchSubConLine."No." := ipurchaseLine."No.";
                PostedPurchSubConLine."Location Code" := ipurchaseLine."Location Code";
                PostedPurchSubConLine."Description" := ipurchaseLine.Description;
                PostedPurchSubConLine."Direct Unit Cost" := ipurchaseLine."Direct Unit Cost";
                PostedPurchSubConLine."Unit Cost (LCY)" := ipurchaseLine."Unit Cost (LCY)";
                PostedPurchSubConLine."Unit Cost" := ipurchaseLine."Unit Cost";
                PostedPurchSubConLine."Unit of Measure" := ipurchaseLine."Unit of Measure";
                PostedPurchSubConLine."Unit of Measure Code" := ipurchaseLine."Unit of Measure Code";
                PostedPurchSubConLine."Shortcut Dimension 1 Code" := ipurchaseLine."Shortcut Dimension 1 Code";
                PostedPurchSubConLine."Order Date" := ipurchaseLine."Order Date";
                PostedPurchSubConLine."VAT Bus. Posting Group" := ipurchaseLine."VAT Bus. Posting Group";
                PostedPurchSubConLine."VAT %" := ipurchaseLine."VAT %";
                PostedPurchSubConLine."Buy-from Vendor No." := ipurchaseLine."Buy-from Vendor No.";
                PostedPurchSubConLine."Planned Receipt Date" := PurchaseHeader."Posting Date";
                PostedPurchSubConLine."Order Date" := PurchaseHeader."Posting Date";
                PostedPurchSubConLine."Expected Receipt Date" := PurchaseHeader."Posting Date";
                PostedPurchSubConLine."Item Category Code" := ipurchaseLine."Item Category Code";
                PostedPurchSubConLine.Remarks := ipurchaseLine.Remarks;

                PostedPurchSubConLine.Insert();
                //update orig purchase line
                ipurchaseLine."Qty. to Ship" := 0;
                ipurchaseLine.Modify();
            until ipurchaseLine.Next() = 0;
            PostedPurchSubConHeader.Insert();
            Commit();
        end;
        Message('The process has been successfully.');
    end;


    var
        FinishEnable: Boolean;
}