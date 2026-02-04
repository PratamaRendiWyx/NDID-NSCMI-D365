codeunit 51104 "Posting Preview Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;
    Permissions = tabledata 17 = m,
    tabledata 21 = m,
    tabledata 25 = m,
    tabledata 32 = m,
    tabledata 254 = m,
    tabledata 5802 = m,
    tabledata 5601 = m,
    tabledata 379 = m,
    tabledata 380 = m,
    tabledata 271 = m,
    tabledata 5222 = rmid,
    tabledata 5223 = rmid,
    tabledata 5832 = rmid;
    trigger OnRun()
    begin
    end;

    var
        CommitPrevented: Boolean;
        TempCheckLedgerEntry: Record "Check Ledger Entry" temporary;
        TempRecordID: RecordId;
        TempDocumentNo: Code[20];
        PreviewPostingCUIsActive: Boolean;
        PostingPreviewEventHandlerStd: Codeunit "Posting Preview Event Handler";
        genJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";

    procedure PreventCommit()
    var
        GLEntry: Record "G/L Entry";
    begin
        if CommitPrevented then
            exit;

        GLEntry.Init;
        GLEntry.Consistent(false);
        CommitPrevented := true;
    end;

    procedure PreviewVoucherReport(DocNo: Text; VoucherType: Enum "Voucher Type"; iType: Integer)
    var
        RecRef: RecordRef;
        ErrorMsg: Label 'Please Preview Posting before print voucher.';

        GenJournalLine: Record "Gen. Journal Line";

        TempGLEntry: Record "G/L Entry" temporary;
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        TempDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry" temporary;
        TempVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        TempDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry" temporary;
        TempBankAccLedgerEntry: Record "Bank Account Ledger Entry" temporary;

        PaymentVoucherPreview: Report "Payment Request (Preview)";
        CashVoucherPreview1: Report "Cash Voucher (Preview)";
        CashVoucherPreview2: Report "Cash Voucher (Preview) Type 2";

        IsHandled: Boolean;
    begin
        PostingPreviewEventHandlerStd.GetEntries(Database::"G/L Entry", RecRef);
        RecRef.Reset();
        if RecRef.FindSet() then
            repeat
                RecRef.SetTable(TempGLEntry);
                TempGLEntry.Insert();
            until RecRef.Next() = 0;
        RecRef.Close();

        PostingPreviewEventHandlerStd.GetEntries(Database::"Cust. Ledger Entry", RecRef);
        RecRef.Reset();
        if RecRef.FindSet() then
            repeat
                RecRef.SetTable(TempCustLedgEntry);
                TempCustLedgEntry.Insert();
            until RecRef.Next() = 0;
        RecRef.Close();

        PostingPreviewEventHandlerStd.GetEntries(Database::"Detailed Cust. Ledg. Entry", RecRef);
        RecRef.Reset();
        if RecRef.FindSet() then
            repeat
                RecRef.SetTable(TempDtldCustLedgEntry);
                TempDtldCustLedgEntry.Insert();
            until RecRef.Next() = 0;
        RecRef.Close();

        PostingPreviewEventHandlerStd.GetEntries(Database::"Vendor Ledger Entry", RecRef);
        RecRef.Reset();
        if RecRef.FindSet() then
            repeat
                RecRef.SetTable(TempVendLedgEntry);
                TempVendLedgEntry.Insert();
            until RecRef.Next() = 0;
        RecRef.Close();

        PostingPreviewEventHandlerStd.GetEntries(Database::"Detailed Vendor Ledg. Entry", RecRef);
        RecRef.Reset();
        if RecRef.FindSet() then
            repeat
                RecRef.SetTable(TempDtldVendLedgEntry);
                TempDtldVendLedgEntry.Insert();
            until RecRef.Next() = 0;
        RecRef.Close();

        PostingPreviewEventHandlerStd.GetEntries(Database::"Bank Account Ledger Entry", RecRef);
        RecRef.Reset();
        if RecRef.FindSet() then
            repeat
                RecRef.SetTable(TempBankAccLedgerEntry);
                TempBankAccLedgerEntry.Insert();
            until RecRef.Next() = 0;
        RecRef.Close();

        // Event >>>>
        OnAfterCopyTempRecordFromPreviewStd(PostingPreviewEventHandlerStd);
        // <<<<<<

        if (VoucherType in [VoucherType::Sales, VoucherType::Purchase]) or ((DocNo <> '') AND (VoucherType <> VoucherType::General)) then
            TempGLEntry.SetFilter("Document No. Before Posted", DocNo);

        if TempGLEntry.IsEmpty then
            Error(ErrorMsg);

        // Event >>>>
        IsHandled := false;
        OnBeforePreviewVoucher(VoucherType, TempGLEntry, TempCustLedgEntry, TempVendLedgEntry, TempDtldCustLedgEntry, TempDtldVendLedgEntry, TempBankAccLedgerEntry, IsHandled);

        if IsHandled then
            exit;
        // <<<<<<

        case VoucherType of
            VoucherType::Payment:
                begin
                    GenJournalLine.SetFilter("Document No.", DocNo);
                    PaymentVoucherPreview.SetTableView(GenJournalLine);
                    PaymentVoucherPreview.SetRecord(TempGLEntry, TempVendLedgEntry, TempDtldVendLedgEntry, TempBankAccLedgerEntry);
                    PaymentVoucherPreview.Run();
                end;
            VoucherType::"Cash Receipt":
                begin
                    GenJournalLine.SetFilter("Document No.", DocNo);
                    case iType of
                        1:
                            begin
                                CashVoucherPreview1.SetTableView(GenJournalLine);
                                CashVoucherPreview1.SetRecord(TempGLEntry, TempVendLedgEntry, TempDtldVendLedgEntry, TempBankAccLedgerEntry);
                                CashVoucherPreview1.Run();
                            end;
                        2:
                            begin
                                CashVoucherPreview2.SetTableView(GenJournalLine);
                                CashVoucherPreview2.SetRecord(TempGLEntry, TempVendLedgEntry, TempDtldVendLedgEntry, TempBankAccLedgerEntry);
                                CashVoucherPreview2.Run();
                            end;
                    end;
                end;
        end;

        // Event >>>>
        OnAfterPreviewVoucher(VoucherType);
        // <<<<<<
    end;


    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertGLEntry(var Rec: Record "G/L Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertGLEntry(var Rec: Record "G/L Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertVATEntry(var Rec: Record "VAT Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertVATEntry(var Rec: Record "VAT Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Value Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertValueEntry(var Rec: Record "Value Entry")
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Value Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertValueEntry(var Rec: Record "Value Entry")
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertItemLedgerEntry(var Rec: Record "Item Ledger Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertItemLedgerEntry(var Rec: Record "Item Ledger Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"FA Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertFALedgEntry(var Rec: Record "FA Ledger Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"FA Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertFALedgEntry(var Rec: Record "FA Ledger Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertCustLedgerEntry(var Rec: Record "Cust. Ledger Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertCustLedgerEntry(var Rec: Record "Cust. Ledger Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed Cust. Ledg. Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertDetailedCustLedgEntry(var Rec: Record "Detailed Cust. Ledg. Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed Cust. Ledg. Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertDetailedCustLedgEntry(var Rec: Record "Detailed Cust. Ledg. Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertVendorLedgerEntry(var Rec: Record "Vendor Ledger Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertVendorLedgerEntry(var Rec: Record "Vendor Ledger Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed Vendor Ledg. Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertDetailedVendorLedgEntry(var Rec: Record "Detailed Vendor Ledg. Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed Vendor Ledg. Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertDetailedVendorLedgEntry(var Rec: Record "Detailed Vendor Ledg. Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Employee Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertEmployeeLedgerEntry(var Rec: Record "Employee Ledger Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Employee Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEmployeeLedgerEntry(var Rec: Record "Employee Ledger Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed Employee Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertDetailedEmployeeLedgerEntry(var Rec: Record "Detailed Employee Ledger Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed Employee Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertDetailedEmployeeLedgerEntry(var Rec: Record "Detailed Employee Ledger Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertBankAccountLedgerEntry(var Rec: Record "Bank Account Ledger Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertBankAccountLedgerEntry(var Rec: Record "Bank Account Ledger Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Res. Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertResourceLedgerEntry(var Rec: Record "Res. Ledger Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Res. Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertResourceLedgerEntry(var Rec: Record "Res. Ledger Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertServiceLedgerEntry(var Rec: Record "Service Ledger Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertServiceLedgerEntry(var Rec: Record "Service Ledger Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warranty Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertWarrantyLedgerEntry(var Rec: Record "Warranty Ledger Entry")
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warranty Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertWarrantyLedgerEntry(var Rec: Record "Warranty Ledger Entry")
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Maintenance Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertMaintenanceLedgerEntry(var Rec: Record "Maintenance Ledger Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Maintenance Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertMaintenanceLedgerEntry(var Rec: Record "Maintenance Ledger Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertJobLedgEntry(var Rec: Record "Job Ledger Entry"; RunTrigger: Boolean)
    begin
        CollectDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertJobLedgEntry(var Rec: Record "Job Ledger Entry"; RunTrigger: Boolean)
    begin
        RestoreDocumentNo(Rec.RecordId, Rec."Document No.", Rec.IsTemporary);
        Rec.Modify();
    end;

    //---- FUNC LOC17 16.02.17 KS +
    procedure ClearAllTempData()
    var
        RecRef: RecordRef;
        TableNoList: list of [Integer];
        TableNo: Integer;
    begin
        TableNoList.AddRange(Database::"G/L Entry",
            Database::"VAT Entry",
            Database::"Value Entry",
            Database::"Item Ledger Entry",
            Database::"FA Ledger Entry",
            Database::"Cust. Ledger Entry",
            Database::"Detailed Cust. Ledg. Entry",
            Database::"Vendor Ledger Entry",
            Database::"Detailed Vendor Ledg. Entry",
            Database::"Employee Ledger Entry",
            Database::"Detailed Employee Ledger Entry",
            Database::"Bank Account Ledger Entry",
            Database::"Res. Ledger Entry",
            Database::"Service Ledger Entry",
            Database::"Warranty Ledger Entry",
            Database::"Maintenance Ledger Entry",
            Database::"Job Ledger Entry",
            Database::"Check Ledger Entry");

        foreach TableNo in TableNoList do begin
            PostingPreviewEventHandlerStd.GetEntries(TableNo, RecRef);
            if not RecRef.IsEmpty then
                RecRef.DeleteAll();
        end;

        ClearAll();

    end;

    [EventSubscriber(ObjectType::Table, database::"Check Ledger Entry", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertCheckLedgerEntryEvent(VAR Rec: Record "Check Ledger Entry"; RunTrigger: Boolean)
    begin
        IF Rec.ISTEMPORARY THEN
            EXIT;
        //KR-LOC Error consistency when post payment with wht
        SetActive(genJnlPostPreview.IsActive());
        if not PreviewPostingCUIsActive then
            exit;
        //C-KR-LOC

        PostingPreviewEventHandlerStd.PreventCommit;
        TempCheckLedgerEntry := Rec;
        //TempCheckLedgerEntry."Document No." := '***';
        TempCheckLedgerEntry.INSERT;
    end;

    [EventSubscriber(ObjectType::Table, database::"Check Ledger Entry", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyCheckLedgerEntryEvent(VAR Rec: Record "Check Ledger Entry"; VAR xRec: Record "Check Ledger Entry"; RunTrigger: Boolean)
    begin
        IF Rec.ISTEMPORARY THEN
            EXIT;

        //KR-LOC Error consistency when post payment with wht
        SetActive(genJnlPostPreview.IsActive());
        if not PreviewPostingCUIsActive then
            exit;
        //C-KR-LOC

        PostingPreviewEventHandlerStd.PreventCommit;

        TempCheckLedgerEntry.SETRANGE("Entry No.", Rec."Entry No.");
        IF TempCheckLedgerEntry.FINDFIRST THEN BEGIN
            TempCheckLedgerEntry := Rec;
            TempCheckLedgerEntry.MODIFY;
        END
        ELSE BEGIN
            TempCheckLedgerEntry.RESET;
            TempCheckLedgerEntry.INIT;
            TempCheckLedgerEntry := Rec;
            TempCheckLedgerEntry.INSERT;
        END;
        TempCheckLedgerEntry.RESET;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterFillDocumentEntry', '', false, false)]
    local procedure AfterFillDocumentEntry(var DocumentEntry: Record "Document Entry")
    begin
        with PostingPreviewEventHandlerStd do begin
            InsertDocumentEntry(TempCheckLedgerEntry, DocumentEntry);
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnGetEntries', '', false, false)]
    local procedure LOC_OnGetEntries(TableNo: Integer; var RecRef: RecordRef)
    begin
        case TableNo of
            Database::"Check Ledger Entry":
                RecRef.GetTable(TempCheckLedgerEntry);
        end;
    end;

    procedure SetActive(Result: Boolean)
    begin
        PreviewPostingCUIsActive := Result;
    end;

    procedure SetPreviewCodeunit(NewPostingPreviewEventHandler: Codeunit "Posting Preview Event Handler")
    begin
        PostingPreviewEventHandlerStd := NewPostingPreviewEventHandler;
    end;

    local procedure CollectDocumentNo(RecID: RecordID; DocumentNo: Code[20]; IsTemporary: Boolean)
    begin
        if not PreviewPostingCUIsActive then
            exit;

        if (not IsTemporary) and (DocumentNo <> '***') then begin
            TempRecordID := RecID;
            TempDocumentNo := DocumentNo;
        end;
    end;

    local procedure RestoreDocumentNo(RecID: RecordID; var DocumentNo: Code[20]; IsTemporary: Boolean)
    begin
        if not PreviewPostingCUIsActive then
            exit;

        if IsTemporary and (DocumentNo = '***') then
            if TempRecordID = RecID then
                DocumentNo := TempDocumentNo;
        Clear(TempRecordID);
        Clear(TempDocumentNo);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyTempRecordFromPreviewStd(var PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPreviewVoucher(VoucherType: Enum "Voucher Type")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePreviewVoucher(VoucherType: Enum "Voucher Type";
        var TempGLEntry: Record "G/L Entry";
        var TempCustLedgEntry: Record "Cust. Ledger Entry";
        var TempVendLedgEntry: Record "Vendor Ledger Entry";
        var TempDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        var TempDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        var TempBankAccLedgerEntry: Record "Bank Account Ledger Entry";
        var IsHadled: Boolean
        )
    begin
    end;
}