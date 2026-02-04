codeunit 51100 "Entry Event"
{
    // Add by rnd, 19 Jan 26, Cutom Source Curr. Amount 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInitGLEntry, '', true, true)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyFactor: Decimal;
        Setup: Record "General Ledger Setup";
        Check: Boolean;
    begin
        if (not GLEntry.IsEmpty) and (not GenJournalLine.IsEmpty) then begin
            CurrencyFactor := CurrExchRate.ExchangeRate(GLEntry."Posting Date", GLEntry."Currency Code");
            GLEntry."Currency Amount 2" := CurrencyFactor * GLEntry.Amount;
        end;
        Setup.Get();
        if Setup."Exact Amount Jnl." then begin
            UpdateGLEntrySourceCurrencyFields(GLEntry, GenJournalLine);
            GLEntry."Currency Amount 2" := GLEntry."Source Currency Amount";
        end;
    end;

    local procedure UpdateGLEntrySourceCurrencyFields(var GLEntry: Record "G/L Entry"; var GenJnlLine: Record "Gen. Journal Line")
    var
        GLAccount: Record "G/L Account";
        GlAccountNo: Code[20];
    begin
        // GenJnlLine."Source Currency Code" := GenJnlLine."Currency Code";
        if GenJnlLine."Source Currency Code" = '' then
            exit;

        Clear(GlAccountNo);
        GlAccountNo := GLEntry."G/L Account No.";

        GetGLSetup();
        GetSourceCodeSetup();
        if (GenJnlLine."Source Code" = SourceCodeSetup."Inventory Post Cost") and (AddCurrencyCode <> '') then
            exit;

        if (GenJnlLine."Source Code" = SourceCodeSetup."Exchange Rate Adjmt.") or
            (GenJnlLine."Source Code" = SourceCodeSetup."General Deferral") or
            (GenJnlLine."Source Code" = SourceCodeSetup."Purchase Deferral") or
            (GenJnlLine."Source Code" = SourceCodeSetup."Sales Deferral") or
            (GenJnlLine."Source Code" = SourceCodeSetup."Exchange Rate Adjmt.") or
            (GenJnlLine."Source Code" = SourceCodeSetup."Sales Entry Application") or
            (GenJnlLine."Source Code" = SourceCodeSetup."Purchase Entry Application") or
            (GenJnlLine."Source Code" = SourceCodeSetup."Employee Entry Application") or
            (GenJnlLine."Source Code" = SourceCodeSetup."Unapplied Sales Entry Appln.") or
            (GenJnlLine."Source Code" = SourceCodeSetup."Unapplied Purch. Entry Appln.") or
            (GenJnlLine."Source Code" = SourceCodeSetup."Unapplied Empl. Entry Appln.")
        then
            exit;

        if GLEntry."G/L Account No." <> '' then begin
            GLAccount.Get(GLEntry."G/L Account No.");
            CheckGLAccountSourceCurrency(GLAccount, GenJnlLine."Source Currency Code");
        end;

        GLEntry."Source Currency Code" := GenJnlLine."Source Currency Code";
        case GenJnlLine."VAT Calculation Type" of
            GenJnlLine."VAT Calculation Type"::"Sales Tax":
                begin
                    GLEntry."Source Currency VAT Amount" := GenJnlLine."Source Curr. VAT Amount";
                    GLEntry."Source Currency Amount" := GenJnlLine."Source Currency Amount";
                end;
            else begin
                GLEntry."Source Currency VAT Amount" := GenJnlLine."Source Curr. VAT Amount";
                if GLEntry."Source Currency VAT Amount" = 0 then
                    GLEntry."Source Currency Amount" := GetSourceCurrencyAmount(GenJnlLine, GenJnlLine."Source Currency Amount" > 0, true, GlAccountNo)
                else
                    GLEntry."Source Currency Amount" := GetSourceCurrencyAmount(GenJnlLine, GenJnlLine."Source Currency Amount" > 0, false, GlAccountNo);
            end;
        end;
    end;

    procedure GetGLSetup()
    begin
        if GLSetupRead then
            exit;

        GLSetup.Get();
        GLSetupRead := true;

        AddCurrencyCode := GLSetup."Additional Reporting Currency";
    end;

    procedure GetSourceCodeSetup()
    begin
        if SourceCodeSetupRead then
            exit;

        SourceCodeSetup.Get();
        SourceCodeSetupRead := true;
    end;

    internal procedure CheckGLAccountSourceCurrency(var GLAccount: Record "G/L Account"; CurrencyCode: Code[10])
    var
        GLAccountSourceCurrency: Record "G/L Account Source Currency";
    begin
        case GLAccount."Source Currency Posting" of
            GLAccount."Source Currency Posting"::"Same Currency":
                if (CurrencyCode <> GLAccount."Source Currency Code") and
                    (GLAccount."Source Currency Code" <> '') and (GLAccount."Source Currency Code" <> GLSetup."LCY Code")
                then
                    Error(GLAccCurrencyDoesNotMatchErr, CurrencyCode, GLAccount."Source Currency Code", GLAccount."No.");
            GLAccount."Source Currency Posting"::"Multiple Currencies":
                if CurrencyCode <> '' then begin
                    GLAccountSourceCurrency.SetRange("G/L Account No.", GLAccount."No.");
                    GLAccountSourceCurrency.SetRange("Currency Code", CurrencyCode);
                    if GLAccountSourceCurrency.IsEmpty() then
                        Error(GLAccSourceCurrencyDoesNotMatchErr, CurrencyCode, GLAccount."No.");
                end;
            GLAccount."Source Currency Posting"::"LCY Only":
                if CurrencyCode <> '' then
                    Error(GLAccSourceCurrencyDoesNotAllowedErr, CurrencyCode, GLAccount."No.");
        end;
    end;

    local procedure GetSourceCurrencyAmount(GenJnlLine: Record "Gen. Journal Line"; IsPositive: Boolean; IsSourceCurrVATZero: Boolean; iGlAccountNo: Code[20]): Decimal
    begin
        if IsSourceCurrVATZero then
            exit(UpdateAmountSign(GenJnlLine."Source Currency Amount", IsPositive));
        if iGlAccountNo <> GenJnlLine."Account No." then
            exit(UpdateAmountSign(GenJnlLine."Source Curr. VAT Amount", IsPositive))
        else
            exit(UpdateAmountSign(GenJnlLine."Source Curr. VAT Base Amount", IsPositive));
    end;

    local procedure UpdateAmountSign(Amount: Decimal; IsPositive: Boolean): Decimal
    begin
        if IsPositive then
            exit(Abs(Amount))
        else
            exit(-Abs(Amount));
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;
        AddCurrencyCode: Code[10];
        GLAccCurrencyDoesNotMatchErr: Label 'The currency code %1 on general journal line does not match with the currency code %2 of G/L account %3.', Comment = '%1 and %2 - currency code, %3 - G/L Account No.';
        GLAccSourceCurrencyDoesNotMatchErr: Label 'The currency code %1 on general journal line does not match with the any source currency code of G/L account %2.', Comment = '%1 - currency code, %2 - G/L Account No.';
        GLAccSourceCurrencyDoesNotAllowedErr: Label 'The currency code %1 on general journal line does not allowed for posting to G/L account %2.', Comment = '%1 - currency code, %2 - G/L Account No.';
        SourceCodeSetupRead: Boolean;
        SourceCodeSetup: Record "Source Code Setup";

    //-

    //"Posted Sales Inv. - Update"
    [EventSubscriber(ObjectType::Page, Page::"Posted Purch. Invoice - Update", OnAfterRecordChanged, '', false, false)]
    local procedure OnAfterRecordChanged(var PurchInvHeader: Record "Purch. Inv. Header"; xPurchInvHeader: Record "Purch. Inv. Header"; var IsChanged: Boolean; xPurchInvHeaderGlobal: Record "Purch. Inv. Header")
    begin
        IsChanged := (PurchInvHeader."Tax Number_FT" <> xPurchInvHeaderGlobal."Tax Number_FT") Or (PurchInvHeader."Tax Date_FT" <> xPurchInvHeaderGlobal."Tax Date_FT");
    end;
    //"Purc. Invoice Header - Edit"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Inv. Header - Edit", OnBeforePurchInvHeaderModify, '', false, false)]
    local procedure OnBeforePurchInvHeaderModify(var PurchInvHeader: Record "Purch. Inv. Header"; PurchInvHeaderRec: Record "Purch. Inv. Header")
    begin
        PurchInvHeader."Tax Number_FT" := PurchInvHeaderRec."Tax Number_FT";
        PurchInvHeader."Tax Date_FT" := PurchInvHeaderRec."Tax Date_FT";
    end;

    // Gen. Journal Line
    [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", 'OnBeforeCheckPostingGroupChange', '', true, true)]
    local procedure OnBeforeCheckPostingGroupChange(var GenJournalLine: Record "Gen. Journal Line"; var xGenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        HRSetup: Record "Human Resources Setup";
        PostingGroupChangeInterface: Interface "Posting Group Change Method";
        Employee: Record Employee;
        EmployeeCU: Codeunit EmployeePostingGrp_AF;
    begin
        IsHandled := true;
        if (GenJournalLine."Posting Group" <> xGenJournalLine."Posting Group") and (xGenJournalLine."Posting Group" <> '') then begin
            GenJournalLine.TestField("Account No.");
            case GenJournalLine."Account Type" of
                GenJournalLine."Account Type"::Employee:
                    begin
                        Employee.Get(GenJournalLine."Account No.");
                        HRSetup.Get();
                        if HRSetup."Allow Multiple Posting Groups" then begin
                            Employee.TestField("Allow Multiple Posting Groups");
                            Clear(EmployeeCU);
                            EmployeeCU.CheckPostingGroupChangeInGenJnlLine(GenJournalLine."Posting Group", xGenJournalLine."Posting Group", GenJournalLine);
                        end
                        else begin
                            if Employee."Employee Posting Group" <> '' then
                                GenJournalLine."Posting Group" := Employee."Employee Posting Group"
                            else
                                IsHandled := false;
                        end;
                    end;
                else
                    IsHandled := false;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', true, true)]
    local procedure OnAfterCopyGLEntryFromGenJnlLineEvent(VAR GLEntry: Record "G/L Entry"; VAR GenJournalLine: Record "Gen. Journal Line")
    begin
        with GLEntry do begin
            if GenJournalLine."Document No. Before Posted" = '' then
                GenJournalLine."Document No. Before Posted" := GenJournalLine."Document No.";
            "Document No. Before Posted" := GenJournalLine."Document No. Before Posted";
            "Currency Code" := GenJournalLine."Currency Code";
            IF GenJournalLine."Currency Factor" <> 0 THEN
                "Currency Factor" := GenJournalLine."Currency Factor"
            ELSE
                "Currency Factor" := 1;
            "Cust/Vend Bank Acc. Code" := GenJournalLine."Cust/Vend Bank Acc. Code";
            "Cust/Vend Bank Acc. Name" := GenJournalLine."Cust/Vend Bank Acc. Name";
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', true, true)]
    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry."Document No. Before Posting" := GenJournalLine."Document No.";
        VendorLedgerEntry."Gen. Jnl. Line No" := GenJournalLine."Line No.";
    end;

    procedure GetNotesForRecordRef(MyRec: RecordRef): text[250]
    var
        RecordLink: Record "Record Link";
        TypeHelper: Codeunit "Record Link Management";
        Result: text;
    begin
        Clear(RecordLink);
        clear(Result);
        RecordLink.SetRange("Record ID", MyRec.RecordId());
        RecordLink.SetRange(Type, RecordLink.Type::Note);
        if RecordLink.FindSet() then begin
            RecordLink.CalcFields(Note);
            Result := TypeHelper.ReadNote(RecordLink);
        end;
        exit(copystr(Result, 1, 250));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnAfterBindSubscription', '', true, true)]
    local procedure OnAfterBindSubscriptionEvent(var PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler")
    begin
        // BINDSUBSCRIPTION(PostingPreviewEventHandler);
        LOC_PostingPreviewEventHandler.ClearAllTempData; // LOCBC 13.12.18 KS 
        LOC_PostingPreviewEventHandler.SetActive(GenJnlPostPreview.IsActive());
        LOC_PostingPreviewEventHandler.SetPreviewCodeunit(PostingPreviewEventHandler);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Batch", 'OnBeforeCheckJnlLine', '', false, false)]
    local procedure OnBeforeCheckJnlLine(var ItemJournalLine: Record "Item Journal Line"; SuppressCommit: Boolean; var IsHandled: Boolean)
    var
        itemJournals: Record "Item Journal Line";
        StartLineNo: Integer;
    begin
        if not (ItemJournalLine."Entry Type" in [ItemJournalLine."Entry Type"::Output, ItemJournalLine."Entry Type"::Consumption]) then
            if ItemJournalLine."Gen. Bus. Posting Group" = '' then
                Error('Gen. Bus. Posting Group can''t null or empty');
    end;

    // "Invt. Doc.-Post Receipt"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Receipt", 'OnBeforeOnRun', '', false, false)]
    local procedure OnBeforeOnRunReceipt(var InvtDocumentHeader: Record "Invt. Document Header"; var SuppressCommit: Boolean; var HideProgressWindow: Boolean)
    begin
        InvtDocumentHeader.TestField("Gen. Bus. Posting Group");
    end;

    // "Invt. Doc.-Post Shipment"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Shipment", 'OnBeforeOnRun', '', false, false)]
    local procedure OnBeforeOnRunShipment(var InvtDocumentHeader: Record "Invt. Document Header"; var SuppressCommit: Boolean; var HideProgressWindow: Boolean)
    begin
        InvtDocumentHeader.TestField("Gen. Bus. Posting Group");
    end;

    var
        LOC_PostingPreviewEventHandler: Codeunit "Posting Preview Handler";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";

    var
        CannotChangePostingGroupForAccountTypeErr: Label 'Posting group cannot be changed for Account Type %1.', Comment = '%1 - account type';
}
