pageextension 50331 SalesQuote_SP extends "Sales Quote"
{
    layout
    {
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
        addafter("Foreign Trade")
        {
            group("Quote Term and Condition")
            {
                field("Delivery To"; Rec."Delivery To")
                {
                    Caption = 'Delivery To';
                    ApplicationArea = All;
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    Caption = 'Delivery Date';
                    ApplicationArea = All;
                }
                field("Price Component"; Rec."Price Component")
                {
                    Caption = 'Price Component';
                    ApplicationArea = All;
                }

                field("Term Payment"; Rec."Term Payment")
                {
                    Caption = 'Term Payment';
                    ApplicationArea = All;
                }

                field("Term By"; Rec."Term By")
                {
                    Caption = 'Term By';
                    ApplicationArea = All;
                }
                field("Validity Date"; Rec."Validity Date")
                {
                    ApplicationArea = All;
                }
                field("Quotation Type"; Rec."Quotation Type")
                {
                    ApplicationArea = All;
                }
                field("Additional Notes"; Rec."Additional Notes")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
        }
        modify("Shipment Method Code")
        {
            Caption = 'Incoterms';
        }
    }

    actions
    {
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
                    SalesHeader: Record "Sales Header";
                begin
                    CurrPage.SetSelectionFilter(SalesHeader);
                    case Rec."Shipment Method Code" of
                        'BY SEA':
                            begin
                                REPORT.Run(REPORT::"Sales Quotation By Sea", true, false, SalesHeader);
                            end;
                        'EXWORK':
                            begin
                                REPORT.Run(REPORT::"Sales Quotation By Sea", true, false, SalesHeader);
                            end;
                        else begin
                            REPORT.Run(REPORT::"Sales Quotation", true, false, SalesHeader);
                        end;
                    end;
                end;
            }

            action("&SendMail")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send Email (Quote)';
                Ellipsis = true;
                Image = SendEmailPDF;
                ToolTip = 'Send email.';
                trigger OnAction()
                var
                    ReportExample: Report "Sales Quotation";
                    Email: Codeunit Email;
                    EmailMessage: Codeunit "Email Message";
                    TempBlob: Codeunit "Temp Blob";
                    InStr: Instream;
                    OutStr: OutStream;
                    ReportParameters: Text;
                    Salesheader: Record "Sales Header";
                    MailSent: Boolean;
                    SubJectEmail: Text;
                    CustomLayoutReporting: Codeunit "Custom Layout Reporting";
                    LastUsedParameters: Text;
                    var_reportID: Integer;
                    Contact: Record Contact;
                    SendToEmail: Text;
                begin
                    //check report ID Selection 
                    case Rec."Shipment Method Code" of
                        'BY SEA':
                            begin
                                var_reportID := Report::"Sales Quotation By Sea";
                            end;
                        'EXWORK':
                            begin
                                var_reportID := Report::"Sales Quotation By Sea";
                            end;
                        else begin
                            var_reportID := Report::"Sales Quotation";
                        end;
                    end;

                    //Send email
                    Clear(Contact);
                    CurrPage.SetSelectionFilter(Salesheader);
                    if Salesheader.FindSet() then
                        ReportExample.SetTableView(Salesheader);

                    Contact.SetRange("No.", Salesheader."Sell-to Contact No.");
                    if Contact.Find('-') then
                        SendToEmail := Contact."E-Mail";
                    SubJectEmail := 'NIPPON STEEL CHEMICAL AND MATERIAL';
                    SubJectEmail := SubJectEmail + ' - ' + 'Sales Quote ' + Salesheader."No.";
                    TempBlob.CreateOutStream(OutStr);
                    ReportParameters := ReportExample.RunRequestPage();
                    if ReportParameters <> '' then begin
                        Report.SaveAs(var_reportID, ReportParameters, ReportFormat::Pdf, OutStr);
                        TempBlob.CreateInStream(InStr);

                        EmailMessage.Create(SendToEmail, SubJectEmail, '', true);
                        EmailMessage.AddAttachment('Sales Quote -' + Salesheader."No." + '.pdf', 'PDF', InStr);
                        Email.OpenInEditor(EmailMessage, Enum::"Email Scenario"::Default);
                    end;
                end;
            }

        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //Initiate value for Quote Term & Condition
        Rec."Delivery To" := '- Delivery to NIPPON STEEL Chemical & Material Co., Ltd';
        Rec."Delivery Date" := '- Delivery date based on Purchase Order and Delivery Schedule';
        Rec."Price Component" := '- Price Including Shipping Charge, Insurance (...)';
        Rec."Term Payment" := '- Term Payment closed the account at the end of a month and pay at the end of one month';
        Rec."Term By" := '- Term by DAP (Delivery at Place)';
    end;
}
