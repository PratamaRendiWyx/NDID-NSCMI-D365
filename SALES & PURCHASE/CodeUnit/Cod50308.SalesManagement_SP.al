codeunit 50308 SalesManagement_SP
{
    Permissions = tabledata "Cust. Ledger Entry" = RMID,
                  tabledata "G/L Entry" = RMID;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"G/L Entry-Edit", OnBeforeGLLedgEntryModify, '', false, false)]
    local procedure OnBeforeGLedgEntryModify(var GLEntry: Record "G/L Entry"; FromGLEntry: Record "G/L Entry")
    begin
        GLEntry.Validate("PIB/PEB No", FromGLEntry."PIB/PEB No");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Cust. Entry-Edit", OnBeforeCustLedgEntryModify, '', false, false)]
    local procedure OnBeforeCustLedgEntryModify(var CustLedgEntry: Record "Cust. Ledger Entry"; FromCustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry.Validate("PIB/PEB No", FromCustLedgEntry."PIB/PEB No");
    end;

    //Purch.-Post
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterUpdateSalesHeader, '', false, false)]
    local procedure OnAfterUpdateSalesHeader(var CustLedgerEntry: Record "Cust. Ledger Entry"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; GenJnlLineDocType: Integer; GenJnlLineDocNo: Code[20]; PreviewMode: Boolean; var SalesHeader: Record "Sales Header")
    var
        CustEntry: Record "Cust. Ledger Entry";
        GlEntries: Record "G/L Entry";
    begin
        if Not (SalesHeader."Document Type" In [SalesHeader."Document Type"::Invoice]) then
            exit;
        Clear(CustEntry);
        CustEntry.SetRange("Entry No.", CustLedgerEntry."Entry No.");
        if CustEntry.FindSet() then begin
            CustEntry."PIB/PEB No" := SalesHeader."PEB No";
            CustEntry.Modify();
            // update GL entries
            Clear(GlEntries);
            GlEntries.SetRange("Document No.", SalesInvoiceHeader."No.");
            GlEntries.SetRange("Posting Date", SalesInvoiceHeader."Posting Date");
            if GlEntries.FindSet() then begin
                repeat
                    GlEntries."PIB/PEB No" := SalesHeader."PEB No";
                    GlEntries.Modify();
                until GlEntries.Next() = 0;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", OnAfterCopyCustLedgerEntryFromGenJnlLine, '', false, false)]
    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry."PIB/PEB No" := GenJournalLine."PIB/PEB No";
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", OnAfterCopyGLEntryFromGenJnlLine, '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."PIB/PEB No" := GenJournalLine."PIB/PEB No";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Posted Gen. Journal Line", OnAfterInsertFromGenJournalLine, '', false, false)]
    local procedure OnAfterInsertFromGenJournalLine(GenJournalLine: Record "Gen. Journal Line"; var PostedGenJournalLine: Record "Posted Gen. Journal Line")
    begin
        PostedGenJournalLine."PIB/PEB No" := GenJournalLine."PIB/PEB No";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeSalesShptHeaderInsert, '', false, false)]
    local procedure OnBeforeSalesShptHeaderInsert(var SalesShptHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; WhseShip: Boolean; InvtPickPutaway: Boolean);
    begin
        SalesShptHeader."Warehouse Person" := TempWhseShptHeader."Warehouse Person";
        SalesShptHeader."Warehouse Person Name" := TempWhseShptHeader."Warehouse Person Name";
        SalesShptHeader."Checked By" := TempWhseShptHeader."Checked By";
        SalesShptHeader."Checked By Name" := TempWhseShptHeader."Checked By Name";
        SalesShptHeader."Prepared By" := TempWhseShptHeader."Prepared By";
        SalesShptHeader."Prepared By Name" := TempWhseShptHeader."Prepared By Name";
    end;

    // Posted Sales Shipment 
    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Shipment - Update", OnAfterRecordChanged, '', false, false)]
    local procedure OnAfterRecordChangedShipment(var SalesShipmentHeader: Record "Sales Shipment Header"; xSalesShipmentHeader: Record "Sales Shipment Header"; var IsChanged: Boolean)
    begin
        IsChanged := (SalesShipmentHeader."Prepared By" <> xSalesShipmentHeader."Prepared By") Or
        (SalesShipmentHeader."Prepared By Name" <> xSalesShipmentHeader."Prepared By Name") Or
        (SalesShipmentHeader."Checked By" <> xSalesShipmentHeader."Checked By") Or
        (SalesShipmentHeader."Checked By Name" <> xSalesShipmentHeader."Checked By Name") Or
        (SalesShipmentHeader."Warehouse Person" <> xSalesShipmentHeader."Warehouse Person") Or
        (SalesShipmentHeader."Warehouse Person Name" <> xSalesShipmentHeader."Warehouse Person Name") Or
        (SalesShipmentHeader."Trucking No." <> xSalesShipmentHeader."Trucking No.")
        ;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shipment Header - Edit", OnBeforeSalesShptHeaderModify, '', false, false)]
    local procedure OnBeforeSalesShptHeaderModify(var SalesShptHeader: Record "Sales Shipment Header"; FromSalesShptHeader: Record "Sales Shipment Header")
    begin
        //update header
        SalesShptHeader."Prepared By" := FromSalesShptHeader."Prepared By";
        SalesShptHeader."Prepared By Name" := FromSalesShptHeader."Prepared By Name";
        SalesShptHeader."Checked By" := FromSalesShptHeader."Checked By";
        SalesShptHeader."Checked By Name" := FromSalesShptHeader."Checked By Name";
        SalesShptHeader."Warehouse Person" := FromSalesShptHeader."Warehouse Person";
        SalesShptHeader."Warehouse Person Name" := FromSalesShptHeader."Warehouse Person Name";
        SalesShptHeader."Trucking No." := FromSalesShptHeader."Trucking No.";
        //-
    end;

    //-
    //"Posted Sales Inv. - Update"
    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Inv. - Update", OnAfterRecordChanged, '', false, false)]
    local procedure OnAfterRecordChanged(var SalesInvoiceHeader: Record "Sales Invoice Header"; xSalesInvoiceHeader: Record "Sales Invoice Header"; var IsChanged: Boolean)
    begin
        IsChanged := (SalesInvoiceHeader."Tax No." <> xSalesInvoiceHeader."Tax No.") Or (SalesInvoiceHeader."PEB No" <> xSalesInvoiceHeader."PEB No");
    end;
    //"Sales Inv. Header - Edit"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Inv. Header - Edit", OnRunOnBeforeAssignValues, '', false, false)]
    local procedure OnRunOnBeforeAssignValues(var SalesInvoiceHeader: Record "Sales Invoice Header"; SalesInvoiceHeaderRec: Record "Sales Invoice Header")
    begin
        SalesInvoiceHeader."Tax No." := SalesInvoiceHeaderRec."Tax No.";
        SalesInvoiceHeader."PEB No" := SalesInvoiceHeaderRec."PEB No";
        //Update entries
        updateEntriesPEB(SalesInvoiceHeader);
    end;

    local procedure updateEntriesPEB(var iSalesInvoiceHeader: Record "Sales Invoice Header")
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        GlEntry: Record "G/L Entry";
    begin
        Clear(CustLedgerEntry);
        CustLedgerEntry.SetRange("Entry No.", iSalesInvoiceHeader."Cust. Ledger Entry No.");
        if CustLedgerEntry.FindSet() then begin
            CustLedgerEntry."PIB/PEB No" := iSalesInvoiceHeader."PEB No";
            CustLedgerEntry.Modify();
            //update GL Entry
            Clear(GlEntry);
            GlEntry.Reset();
            GlEntry.SetRange("Document No.", iSalesInvoiceHeader."No.");
            GlEntry.SetRange("Posting Date", iSalesInvoiceHeader."Posting Date");
            if GlEntry.FindSet() then begin
                repeat
                    GlEntry."PIB/PEB No" := iSalesInvoiceHeader."PEB No";
                    GlEntry.Modify();
                until GlEntry.Next() = 0;
            end;
        end;
    end;

    // OnBeforeUpdateUnitPrice
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeUpdateUnitPrice, '', false, false)]
    local procedure OnBeforeUpdateUnitPrice(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer; var Handled: Boolean)
    var
        salesHeader: Record "Sales Header";
    begin
        if SalesLine."Document Type" = SalesLine."Document Type"::Invoice then
            exit;
        Clear(salesHeader);
        salesHeader.Reset();
        salesHeader.SetRange("No.", SalesLine."Document No.");
        if salesHeader.Find('-') then begin
            if salesHeader."Shipment Method Code" <> 'BY SEA' then begin
                SalesLine."Unit Price" := 0;
                SalesLine.Validate("Unit Price");
                Handled := true;
            end
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnAfterReleaseATOs, '', false, false)]
    local procedure OnAfterReleaseATOs(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; PreviewMode: Boolean)
    var
        SalesMgnt: Codeunit SalesManagement_SP;
        vstatus: Enum "Sales Document Status";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            vstatus := SalesMgnt.validationCheck(salesHeader);
            SalesHeader.Status := vstatus;
        end;
    end;

    procedure validationCheck(var salesHeader: Record "Sales Header"): Enum "Sales Document Status"
    var
        checkCreditLimit: Boolean;
        validation: Codeunit CLODValidation_SP;
        salesHeader1: Record "Sales Header";
    begin
        salesHeader1 := salesHeader;
        begin
            checkCreditLimit := true;
            if (validation.checkCreditLimit(salesHeader1."No.", salesHeader1."Document Type") = false) then begin
                salesHeader1.Status := enum::"Sales Document Status"::"Pending Credit Limit";
                checkCreditLimit := false;
            end;
            if (checkCreditLimit = true) then begin
                if (validation.checkOverdueBalance(salesHeader1."No.", salesHeader1."Document Type") = false) then begin
                    salesHeader1.Status := enum::"Sales Document Status"::"Pending Overdue";
                    checkCreditLimit := false;
                end;
            end;
            if (checkCreditLimit = true) then begin
                salesHeader1.Status := enum::"Sales Document Status"::Released;
            end
            else begin
                Message('Sorry, transaction is pending and cannot be released.');
            end;
            exit(salesHeader1.Status);
        end;
    end;

    // "Correct Posted Sales Invoice" 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Correct Posted Sales Invoice", 'OnBeforeUpdateSalesOrderLineInvoicedQuantity', '', false, false)]
    local procedure OnBeforeUpdateSalesOrderLineInvoicedQuantity(var SalesLine: Record "Sales Line"; CancelledQuantity: Decimal; CancelledQtyBase: Decimal; var IsHandled: Boolean)
    begin
        IsHandled := true;
        IsHandled := true;
        SalesLine."Quantity Invoiced" -= CancelledQuantity;
        SalesLine."Qty. Invoiced (Base)" -= CancelledQtyBase;
        SalesLine.Modify();
    end;
    //-

    procedure checkCountCompleteInvoicedSO(iNo: Code[20])
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        Counter: Integer;
        CounterOrig: Integer;
        Result: Boolean;
    begin
        Clear(Counter);
        Clear(CounterOrig);
        Clear(SalesHeader);
        Clear(Result);
        SalesHeader.SetRange("No.", iNo);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(Status, SalesHeader.Status::Released);
        SalesHeader.SetRange(IsClose, false);
        if SalesHeader.Find('-') then begin
            Clear(SalesLine);
            SalesLine.SetRange("Document No.", iNo);
            SalesLine.SetRange("Document Type", SalesHeader."Document Type"::Order);
            SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
            SalesLine.SetFilter("No.", '<>%1', '');
            SalesLine.SetFilter(Quantity, '<>%1', 0);
            if SalesLine.FindSet() then begin
                CounterOrig := SalesLine.Count();
                repeat
                    if SalesLine.Quantity = SalesLine."Quantity Invoiced" then begin
                        Counter := Counter + 1;
                    end;
                until SalesLine.Next() = 0;
                //check data orig vs complete invoice
                if CounterOrig = Counter then begin
                    SalesHeader.IsClose := true;
                    SalesHeader.Modify();
                end;
                //-
            end;
        end;
    end;

    // "Sales-Post"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesShptLineInsert', '', false, false)]
    local procedure OnBeforeSalesShptLineInsert(var SalesShptLine: Record "Sales Shipment Line"; SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; PostedWhseShipmentLine: Record "Posted Whse. Shipment Line"; SalesHeader: Record "Sales Header"; WhseShip: Boolean; WhseReceive: Boolean; ItemLedgShptEntryNo: Integer; xSalesLine: record "Sales Line"; var TempSalesLineGlobal: record "Sales Line" temporary; var IsHandled: Boolean)
    begin
        SalesShptLine."Cust. PO No." := SalesShptHeader."External Document No.";
    end;

    //"Sales Shipment Line"
    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromShptLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; SalesOrderLine: Record "Sales Line"; var IsHandled: Boolean; var TransferOldExtTextLines: Codeunit "Transfer Old Ext. Text Lines")
    begin
        SalesLine."Cust. PO No." := SalesShptLine."Cust. PO No.";
    end;

}
