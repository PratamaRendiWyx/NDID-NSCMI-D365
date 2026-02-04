codeunit 50316 "Event Subscriber Purch Mgt"
{
    Permissions = tabledata "Item Ledger Entry" = RIMD,
                  tabledata "Lot No. Information" = RMID,
                  tabledata "Vendor Ledger Entry" = RMID,
                  tabledata "G/L Entry" = RMID;

    // "Phys. Invt. Record Line"
    // [EventSubscriber(ObjectType::Table, Database::"Phys. Invt. Record Line", 'OnShowUsedTrackLinesOnAfterLookupOK', '', false, false)]
    // local procedure OnShowUsedTrackLinesOnAfterLookupOK(var PhysInvtRecordLine: Record "Phys. Invt. Record Line"; var TempPhysInvtTracking: Record "Phys. Invt. Tracking" temporary)
    // begin
    //     PhysInvtRecordLine."USDFS Code" := TempPhysInvtTracking."USDFS Code";
    //     PhysInvtRecordLine."Package No." := TempPhysInvtTracking."Package No.";
    // end;

    // OnShowUsedTrackLinesOnAfterInsertFromItemLedgEntry
    // "Phys. Invt. Record Line"
    // [EventSubscriber(ObjectType::Table, Database::"Phys. Invt. Record Line", 'OnShowUsedTrackLinesOnAfterInsertFromItemLedgEntry', '', false, false)]
    // local procedure OnShowUsedTrackLinesOnAfterInsertFromItemLedgEntry(var TempPhysInvtTracking: Record "Phys. Invt. Tracking" temporary; ItemLedgerEntry: Record "Item Ledger Entry")
    // begin
    //     TempPhysInvtTracking."Lot No. 1" := ItemLedgerEntry."Lot No.";
    //     TempPhysInvtTracking."Package No." := ItemLedgerEntry."Package No.";
    //     TempPhysInvtTracking."USDFS Code" := ItemLedgerEntry."USDFS Code";
    //     TempPhysInvtTracking.Modify();
    // end;

    //Purch.-Post
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnInsertPostedHeadersOnAfterInvoice, '', false, false)]
    local procedure OnInsertPostedHeadersOnAfterInvoice(var PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line"; var GenJnlLineDocType: Enum "Gen. Journal Document Type"; var GenJnlLineDocNo: Code[20]; var GenJnlLineExtDocNo: Code[35]; var IsHandled: Boolean)
    begin
        GenJournalLine."PIB/PEB No" := PurchaseHeader."PIB/PEB No";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Cust. Entry-Edit", OnBeforeCustLedgEntryModify, '', false, false)]
    local procedure OnBeforeCustLedgEntryModify(var CustLedgEntry: Record "Cust. Ledger Entry"; FromCustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry.Validate("PIB/PEB No", FromCustLedgEntry."PIB/PEB No");
    end;

    //Purch.-Post
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterUpdatePurchaseHeader, '', false, false)]
    local procedure OnAfterUpdatePurchaseHeader(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; GenJnlLineDocType: Integer; GenJnlLineDocNo: Code[20]; PreviewMode: Boolean; var PurchaseHeader: Record "Purchase Header")
    var
        VendEntry: Record "Vendor Ledger Entry";
        GlEntries: Record "G/L Entry";
    begin
        if Not (PurchaseHeader."Document Type" In [PurchaseHeader."Document Type"::Invoice]) then
            exit;
        Clear(VendEntry);
        VendEntry.SetRange("Entry No.", VendorLedgerEntry."Entry No.");
        if VendEntry.FindSet() then begin
            VendEntry."PIB/PEB No" := PurchaseHeader."PIB/PEB No";
            VendEntry.Modify();
            // update GL entries
            Clear(GlEntries);
            GlEntries.SetRange("Document No.", PurchInvHeader."No.");
            GlEntries.SetRange("Posting Date", PurchInvHeader."Posting Date");
            if GlEntries.FindSet() then begin
                repeat
                    GlEntries."PIB/PEB No" := PurchaseHeader."PIB/PEB No";
                    GlEntries.Modify();
                until GlEntries.Next() = 0;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", OnAfterCopyVendLedgerEntryFromGenJnlLine, '', false, false)]
    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line");
    begin
        VendorLedgerEntry."PIB/PEB No" := GenJournalLine."PIB/PEB No";
    end;

    procedure updateUSDFSCodeonILE(LotNoInfo: Record "Lot No. Information")
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetRange("Item No.", LotNoInfo."Item No.");
        ItemLedgerEntry.SetRange("Lot No.", LotNoInfo."Lot No.");
        if ItemLedgerEntry.FindSet() then
            ItemLedgerEntry.ModifyAll("USDFS Code", LotNoInfo."USDFS Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::QCFunctionLibrary_PQ, OnCreateLotOrSerialNoInformation, '', true, true)]
    local procedure OnCreateLotOrSerialNoInformation(var LotInformation: Record "Lot No. Information"; var ItemLedgEntry: Record "Item Ledger Entry")
    begin
        LotInformation."USDFS Code" := ItemLedgEntry."USDFS Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::QCCodeunitSubscribers_PQ, OnModifyLotOrSerialNoInformation, '', true, true)]
    local procedure OnModifyLotOrSerialNoInformation(var LotInformation: Record "Lot No. Information"; var ItemLedgEntry: Record "Item Ledger Entry")
    var
        LotInformationLoc: Record "Lot No. Information";
    begin
        LotInformationLoc.Reset();
        LotInformationLoc.SetRange("Item No.", ItemLedgEntry."Item No.");
        LotInformationLoc.SetRange("Lot No.", ItemLedgEntry."Lot No.");
        if LotInformationLoc.FindSet() then begin
            LotInformation."USDFS Code" := ItemLedgEntry."USDFS Code";
            LotInformation.Modify();
        end;
    end;

    //"Posted Sales Inv. - Update"
    [EventSubscriber(ObjectType::Page, Page::"Posted Purch. Invoice - Update", OnAfterRecordChanged, '', false, false)]
    local procedure OnAfterRecordChanged(var PurchInvHeader: Record "Purch. Inv. Header"; xPurchInvHeader: Record "Purch. Inv. Header"; var IsChanged: Boolean; xPurchInvHeaderGlobal: Record "Purch. Inv. Header")
    begin
        IsChanged := (PurchInvHeader."PIB/PEB No" <> xPurchInvHeaderGlobal."PIB/PEB No");
    end;
    //"Sales Inv. Header - Edit"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Inv. Header - Edit", OnBeforePurchInvHeaderModify, '', false, false)]
    local procedure OnBeforePurchInvHeaderModify(var PurchInvHeader: Record "Purch. Inv. Header"; PurchInvHeaderRec: Record "Purch. Inv. Header")
    begin
        PurchInvHeader."PIB/PEB No" := PurchInvHeaderRec."PIB/PEB No";
        //update entries
        updateEntriesPEB(PurchInvHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Vend. Entry-Edit", OnBeforeVendLedgEntryModify, '', false, false)]
    local procedure OnBeforeVendLedgEntryModify(var VendLedgEntry: Record "Vendor Ledger Entry"; FromVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry.Validate("PIB/PEB No", FromVendLedgEntry."PIB/PEB No");
    end;

    local procedure updateEntriesPEB(var iPurchaseInvoiceHeader: Record "Purch. Inv. Header")
    var
        vendorLedgerEntry: Record "Vendor Ledger Entry";
        GlEntry: Record "G/L Entry";
    begin
        Clear(vendorLedgerEntry);
        vendorLedgerEntry.SetRange("Entry No.", iPurchaseInvoiceHeader."Vendor Ledger Entry No.");
        if vendorLedgerEntry.FindSet() then begin
            vendorLedgerEntry."PIB/PEB No" := iPurchaseInvoiceHeader."PIB/PEB No";
            vendorLedgerEntry.Modify();
            //update GL Entry
            Clear(GlEntry);
            GlEntry.Reset();
            GlEntry.SetRange("Document No.", iPurchaseInvoiceHeader."No.");
            GlEntry.SetRange("Posting Date", iPurchaseInvoiceHeader."Posting Date");
            if GlEntry.FindSet() then begin
                repeat
                    GlEntry."PIB/PEB No" := iPurchaseInvoiceHeader."PIB/PEB No";
                    GlEntry.Modify();
                until GlEntry.Next() = 0;
            end;
        end;
    end;

    // OnSetSourcesOnAfterxEntrySummarySetview | "Item Tracking Summary"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", OnAssistEditTrackingNoOnBeforeSetSources, '', true, true)]
    local procedure OnAssistEditTrackingNoOnBeforeSetSources(var TempTrackingSpecification: Record "Tracking Specification" temporary; var TempGlobalEntrySummary: Record "Entry Summary" temporary; var MaxQuantity: Decimal);
    var
        ItemNo: Code[20];
    begin
        ItemNo := TempTrackingSpecification."Item No.";
        TempGlobalEntrySummary."Item No." := ItemNo;
        TempGlobalEntrySummary.ModifyAll("Item No.", ItemNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", OnSelectMultipleTrackingNoOnBeforeSetSources, '', true, true)]
    local procedure OnSelectMultipleTrackingNoOnBeforeSetSources(var TempTrackingSpecification: Record "Tracking Specification" temporary; var TempGlobalEntrySummary: Record "Entry Summary" temporary; var MaxQuantity: Decimal)
    var
        ItemNo: Code[20];
    begin
        ItemNo := TempTrackingSpecification."Item No.";
        TempGlobalEntrySummary."Item No." := ItemNo;
        TempGlobalEntrySummary.ModifyAll("Item No.", ItemNo);
    end;


    // "Item Tracking Data Collection"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", OnAssistEditTrackingNoOnAfterAssignTrackingToSpec, '', true, true)]
    local procedure OnAssistEditTrackingNoOnAfterAssignTrackingToSpec(var TempTrackingSpecification: Record "Tracking Specification" temporary; TempGlobalEntrySummary: Record "Entry Summary")
    var
        usdfCode: Text[100];
    begin
        Clear(usdfCode);
        usdfCode := getUSDFCOde(TempTrackingSpecification."Item No.", TempGlobalEntrySummary."Lot No.");
        TempTrackingSpecification.Validate("USDFS Code", usdfCode);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnSelectEntriesOnAfterTransferFields, '', true, true)]
    local procedure OnSelectEntriesOnAfterTransferFields(var TempTrackingSpec: Record "Tracking Specification" temporary; var TrackingSpecification: Record "Tracking Specification")
    var
        usdfCode: Text[100];
    begin
        Clear(usdfCode);
        usdfCode := getUSDFCOde(TrackingSpecification."Item No.", TrackingSpecification."Lot No.");
        TempTrackingSpec.Validate("USDFS Code", usdfCode);
        TrackingSpecification."USDFS Code" := usdfCode;
    end;

    local procedure getUSDFCOde(iItemNo: Code[20]; iLotNo: Code[50]): Text
    var
        LotInformation: Record "Lot No. Information";
    begin
        LotInformation.Reset();
        LotInformation.SetRange("Item No.", iItemNo);
        LotInformation.SetRange("Lot No.", iLotNo);
        if LotInformation.Find('-') then
            exit(LotInformation."USDFS Code");
        exit('');
    end;

}
