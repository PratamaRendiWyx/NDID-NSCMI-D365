pageextension 50324 PostedSalesInvoice_SP extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Invoice Type"; Rec."Invoice Type")
            {
                ApplicationArea = All;
            }
        }
        addafter("Your Reference")
        {
            field("BL No"; Rec."BL No")
            {
                ApplicationArea = All;
            }
            field("PEB No"; Rec."PEB No")
            {
                ApplicationArea = All;
            }
            field("Request No"; Rec."Request No")
            {
                ApplicationArea = All;
            }
            field("Packing No."; Rec."Packing No.")
            {
                ApplicationArea = All;
            }
            field("Tax No."; Rec."Tax No.")
            {
                ApplicationArea = All;
            }
            field("Contract No."; Rec."Contract No.")
            {
                ApplicationArea = All;
            }
            field("Delivery By"; Rec."Delivery By")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify("Shipping and Billing")
        {
            Visible = true;
        }
        addbefore("Shipping and Billing")
        {
            group("Remarks (Thai)")
            {
                Caption = 'Remarks (Thai)';
                field(FOB; Rec.FOB)
                {
                    ApplicationArea = All;
                }
                field(Freight; Rec.Freight)
                {
                    ApplicationArea = All;
                }
                field(CIF; Rec.CIF)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        addafter(Print)
        {
            action("&Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print.';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                trigger OnAction()
                var
                    SalesInvoiceheader: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SalesInvoiceheader);
                    REPORT.Run(REPORT::"Sales Invoice", true, false, SalesInvoiceheader);
                end;
            }
            action("&Print1")
            {
                ApplicationArea = Suite;
                Caption = '&Print.';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SalesHeader);
                    if SalesHeader.FindSet() then begin
                        if (SalesHeader."Packing No." <> '') AND (SalesHeader."Contract No." = '') then
                            REPORT.Run(REPORT::"Proforma Invoice Thai (Posted)", true, false, SalesHeader)
                        else
                            REPORT.Run(REPORT::"Proforma Inv. China (Posted)", true, false, SalesHeader);
                    end;
                end;
            }
            action("&PrintD")
            {
                ApplicationArea = Suite;
                Caption = '&Print (Domestic).';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SalesHeader);
                    if SalesHeader.FindSet() then begin
                        REPORT.Run(REPORT::"Proforma Inv. Domstc (Posted)", true, false, SalesHeader);
                    end;
                end;
            }
            action("&Print2")
            {
                ApplicationArea = Suite;
                Caption = '&Print (Contract)';
                Ellipsis = true;
                Enabled = (Rec."Contract No." <> '');
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SalesHeader);
                    REPORT.Run(REPORT::"Print Contract (Posted)", true, false, SalesHeader);
                end;
            }
        }
        modify(CancelInvoice)
        {
            Visible = true;
        }
        modify(CorrectInvoice)
        {
            Visible = false;
        }
        modify(CreateCreditMemo)
        {
            Visible = false;
        }
    }
}
