page 50302 "Posted Vendor DO"
{
    ApplicationArea = All;
    Caption = 'Posted Vendor DO';
    PageType = Document;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Posted DO Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.';
                }
                field("Ship-to Vendor No."; Rec."Ship-to Vendor No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field("Ship-to Contact No."; Rec."Ship-to Contact No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the contact person at the vendor who delivered the items.';
                }
                field(BuyFromContactPhoneNo; BuyFromContact."Phone No.")
                {
                    ApplicationArea = Suite;
                    Caption = 'Phone No.';
                    Importance = Additional;
                    Editable = false;
                    ExtendedDatatype = PhoneNo;
                    ToolTip = 'Specifies the telephone number of the vendor contact person.';
                }
                field(BuyFromContactMobilePhoneNo; BuyFromContact."Mobile Phone No.")
                {
                    ApplicationArea = Suite;
                    Caption = 'Mobile Phone No.';
                    Importance = Additional;
                    Editable = false;
                    ExtendedDatatype = PhoneNo;
                    ToolTip = 'Specifies the mobile telephone number of the vendor contact person.';
                }
                field(BuyFromContactEmail; BuyFromContact."E-Mail")
                {
                    ApplicationArea = Suite;
                    Caption = 'Email';
                    Importance = Additional;
                    Editable = false;
                    ExtendedDatatype = EMail;
                    ToolTip = 'Specifies the email address of the vendor contact person.';
                }
                group("Ship-to")
                {
                    Caption = 'Ship-to';
                    field("Ship-to Vendor Name"; Rec."Ship-to Vendor Name")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Name';
                        Editable = false;
                        ToolTip = 'Specifies the name of the vendor who delivered the items.';
                    }
                    field("Ship-to Address"; Rec."Ship-to Address")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Address';
                        Editable = false;
                        ToolTip = 'Specifies the address of the vendor who delivered the items.';
                    }
                    field("Ship-to Address 2"; Rec."Ship-to Address 2")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Address 2';
                        Editable = false;
                        ToolTip = 'Specifies an additional part of the address of the vendor who delivered the items.';
                    }
                    field("Ship-to City"; Rec."Ship-to City")
                    {
                        ApplicationArea = Suite;
                        Caption = 'City';
                        Editable = false;
                        ToolTip = 'Specifies the city of the vendor who delivered the items.';
                    }
                    group(Control11)
                    {
                        ShowCaption = false;
                        Visible = IsBuyFromCountyVisible;
                        field("Ship-to County"; Rec."Ship-to County")
                        {
                            ApplicationArea = Suite;
                            Caption = 'County';
                            Editable = false;
                            ToolTip = 'Specifies the state, province or county related to the posted purchase order.';
                        }
                    }
                    field("Ship-to Post Code"; Rec."Ship-to Post Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Post Code';
                        Editable = false;
                        ToolTip = 'Specifies the post code of the vendor who delivered the items.';
                    }
                    field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Country/Region';
                        Editable = false;
                        ToolTip = 'Specifies the country or region of the address.';
                    }
                    field("Ship-to Contact"; Rec."Ship-to Contact")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Contact';
                        Editable = false;
                        ToolTip = 'Specifies the name of the contact person at the vendor who delivered the items.';
                    }
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies how many times the document has been printed.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the posting date of the record.';
                }
                field(Notes; Rec.Notes)
                {
                    Caption = 'Notes';
                    ApplicationArea = All;
                    MultiLine = true;
                    Editable = false;
                }
                field("Additional Notes"; Rec."Additional Notes")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date when the purchase document was created.';
                }
                field("Requested Shipment Date"; Rec."Requested Shipment Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date that you want the vendor to deliver to the ship-to address. The value in the field is used to calculate the latest date you can order the items to have them delivered on the requested Shipment Date. If you do not need delivery on a specific date, you can leave the field blank.';
                }
                field("Promised Shipment Date"; Rec."Promised Shipment Date")
                {
                    ApplicationArea = OrderPromising;
                    ToolTip = 'Specifies the date that the vendor has promised to deliver the order.';
                }
                field("Quote No."; Rec."Quote No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the quote number for the posted purchase receipt.';
                }
                field("Order No."; Rec."Order No.")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the line number of the order that created the entry.';
                }
                field("Vendor Order No."; Rec."Vendor Order No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the vendor''s order number.';
                }
                field(IsCancel; Rec.IsCancel)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Prepared By Name"; Rec."Prepared By Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Checked By"; Rec."Checked By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Checked By Name"; Rec."Checked By Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Warehouse Person"; Rec."Warehouse Person")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Warehouse Person Name"; Rec."Warehouse Person Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(PurchSubconLines; "Posted Vendor DO Subform")
            {
                ApplicationArea = Suite;
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {

        }
        area(processing)
        {
            action("&Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Enabled = Not Rec.IsCancel;
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                trigger OnAction()
                var
                    PurchaseSubconHeader: Record "Posted DO Header";
                begin
                    CurrPage.SetSelectionFilter(PurchaseSubconHeader);
                    REPORT.Run(REPORT::"Delivery Order", true, false, PurchaseSubconHeader);
                end;
            }
            action("&Cancel")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Cancel';
                Ellipsis = true;
                Image = CancelLine;
                Enabled = (Rec.IsCancel <> true);
                ToolTip = 'Cancel Post. Shipment.';
                trigger OnAction()
                begin
                    if Confirm('Are you sure want to cancel posted Purch. Sub. Cont. ?') then begin
                        cancelPurchaseSubcon(Rec);
                        CurrPage.Update();
                    end;
                end;
            }
            action(UpdateDocument)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Document';
                Image = Document;
                ToolTip = 'Update Document Vendor DO';
                trigger OnAction()
                var
                    updateDocumentVendorDO: Report "Update Vendo DO";
                    PostDOHeader: Record "Posted DO Header";
                begin
                    CurrPage.SetSelectionFilter(PostDOHeader);
                    if PostDOHeader.Find('-') then begin
                        updateDocumentVendorDO.UseRequestPage(true);
                        updateDocumentVendorDO.setParam(PostDOHeader);
                        updateDocumentVendorDO.RunModal();
                    end;
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("&Print_Promoted"; "&Print")
                {
                }
                actionref("&Cancel_Promoted"; "&Cancel")
                {

                }
            }
            group(Category_Category5)
            {
                Caption = 'Print/Send', Comment = 'Generated from the PromotedActionCategories property index 4.';

            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        ActivateFields();
    end;

    local procedure cancelPurchaseSubcon(var iRec: Record "Posted DO Header")
    var
        RecPurchaseSubconHeader: Record "Posted DO Header";
        RecPurchaseSubconLine: Record "Posted DO Line";
    begin
        Clear(RecPurchaseSubconHeader);
        RecPurchaseSubconHeader.Reset();
        RecPurchaseSubconHeader.SetRange("No.", iRec."No.");
        if RecPurchaseSubconHeader.FindSet() then begin
            RecPurchaseSubconHeader.IsCancel := true;
            Clear(RecPurchaseSubconLine);
            RecPurchaseSubconLine.Reset();
            RecPurchaseSubconLine.SetRange("Document No.", RecPurchaseSubconHeader."No.");
            if RecPurchaseSubconLine.FindSet() then begin
                repeat
                    RecPurchaseSubconLine.Iscancel := true;
                    RecPurchaseSubconLine.Modify();
                until RecPurchaseSubconLine.Next() = 0;
            end;
            RecPurchaseSubconHeader.Modify();
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        BuyFromContact.GetOrClear(Rec."Ship-to Contact No.");
        PayToContact.GetOrClear(Rec."Pay-to Contact No.");
    end;

    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        BuyFromContact: Record Contact;
        PayToContact: Record Contact;
        FormatAddress: Codeunit "Format Address";
        IsBuyFromCountyVisible: Boolean;
        IsPayToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;

    local procedure ActivateFields()
    begin
        IsBuyFromCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
        IsPayToCountyVisible := FormatAddress.UseCounty(Rec."Pay-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePrintRecords(PurchRcptHeaderRec: Record "Purch. Rcpt. Header"; var ToPrint: Record "Purch. Rcpt. Header")
    begin
    end;
}
