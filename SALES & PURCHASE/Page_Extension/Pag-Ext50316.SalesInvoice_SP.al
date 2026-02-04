pageextension 50316 SalesInvoice_SP extends "Sales Invoice"
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

        modify("External Document No.")
        {
            Caption = 'Customer PO. No.';
        }
        modify("Quote No.")
        {
            Visible = false;
        }
        addafter("Your Reference")
        {
            field("Quote No._1"; Rec."Quote No.")
            {
                ApplicationArea = All;
                Editable = true;
            }
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
            field("Contract No."; Rec."Contract No.")
            {
                ApplicationArea = All;
            }
            field("Shipment No."; Rec."Shipment No.")
            {
                ApplicationArea = All;
            }
        }
        modify("Sell-to Customer No.")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
                Customer: Record Customer;
            begin
                Clear(Customer);
                Customer.Reset();
                Customer.SetRange("No.", Rec."Sell-to Customer No.");
                if Customer.Find('-') then
                    Rec."Company Bank Account Code" := Customer."Receiving Bank Account";
            end;
        }
        modify("Shipment Method Code")
        {
            Caption = 'Incoterms';
        }
        modify("Shipping and Billing")
        {
            Visible = true;
        }
        modify("Shipment Method")
        {
            Visible = false;
        }
        addafter("Packing No.")
        {
            field("Delivery By"; Rec."Delivery By")
            {
                ApplicationArea = All;
            }
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
        addafter(ProformaInvoice)
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
                    if SalesHeader.FindSet() then begin
                        if (SalesHeader."Packing No." <> '') AND (SalesHeader."Contract No." = '') then
                            REPORT.Run(REPORT::"Proforma Invoice Thai", true, false, SalesHeader)
                        else
                            REPORT.Run(REPORT::"Proforma Invoice China", true, false, SalesHeader);
                    end;
                end;
            }
            action("&PrintD")
            {
                ApplicationArea = Suite;
                Caption = '&Print (Domestic)';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    CurrPage.SetSelectionFilter(SalesHeader);
                    if SalesHeader.FindSet() then begin
                        REPORT.Run(REPORT::"Proforma Invoice Domestic", true, false, SalesHeader);
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
                    SalesHeader: Record "Sales Header";
                begin
                    CurrPage.SetSelectionFilter(SalesHeader);
                    REPORT.Run(REPORT::"Print Contract", true, false, SalesHeader);
                end;
            }
        }
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                validationCheck();
            end;
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                validationCheck();
            end;
        }
    }

    local procedure validationCheck()
    begin
        if Rec."Invoice Type" = Rec."Invoice Type"::" " then begin
            Error('Please select Invoice type, invoice type can''t blank.');
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
        CreateNewSalesInvoice: Report "Create Sales Invoice Gen.";
    begin
        //Action Here
        CreateNewSalesInvoice.UseRequestPage(true);
        CreateNewSalesInvoice.RunModal();
        CurrPage.Close();
    end;
}
