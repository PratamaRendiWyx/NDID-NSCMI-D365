report 51106 "Payment Request (Preview)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/Payment Request (Preview).rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(GLHeader; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Line No.");
            RequestFilterFields = "Document No.";
            column(Header; Header)
            {
            }
            column(Document_No_; "Document No.")
            {

            }
            column(DocumentNo_GLHeader; GLHeader."Document No.")
            {
            }
            column(BankName; BankName)
            {
            }
            column(LogoCompany; CompanyInfo.Picture)
            {
            }
            column(Payee; Payee) { }
            column(Payee_Name; PayeeNameText) { }
            column(PaidTo; PaidTo)
            {
            }
            //Receipt Bank Account
            column(ReceiptBankAccount1; ReceiptBankAccount.Get(1))
            {
            }
            column(ReceiptBankAccount2; ReceiptBankAccount.Get(2))
            {
            }
            column(ReceiptBankAccount3; ReceiptBankAccount.Get(3))
            {
            }
            //-
            column(VendAddress; VendAddress)
            {
            }
            column(CurrencyCode_GLEntry; CurrecyCodeTxt)
            {
            }
            column(PostingDate_GLEntry; "Gen. Journal Line"."Posting Date")
            {
            }
            column(CurrencyFactor_GLEntry; CurrencyFactor)
            {
            }
            column(UserName; UserName)
            {
            }
            column(Notes; Notes) { }
            column(MaxLine; MaxLine) { }
            column(TotalDebitAmt; TotalDebitAmt)
            {
            }
            column(TotalCreditAmt; TotalCreditAmt)
            {
            }
            column(Amounttxt; Amounttxt)
            {
            }
            //-approval etries info 
            column(ApprovalSeq1; v_listApprovalDate.Get(1))
            {
            }
            column(ApprovalSeq2; v_listApprovalDate.Get(2))
            {
            }
            column(ApprovalSeq3; v_listApprovalDate.Get(3))
            {
            }
            column(ApprovalSeq4; v_listApprovalDate.Get(4))
            {
            }
            column(v_preparation_date; v_preparation_date) { }
            dataitem("Gen. Journal Line"; "Gen. Journal Line")
            {
                DataItemLink = "Document No." = FIELD("Document No.");
                DataItemTableView = SORTING("Line No.");

                column(Applied; Applied) { }
                column(Amount_GLEntry; "Gen. Journal Line".Amount)
                {
                }
                column(DocumentNo_GLEntry; "Gen. Journal Line"."Document No.")
                {
                }
                column(GLAccountNo_GLEntry; "Gen. Journal Line"."Account No.")
                {
                }
                column(GLAccountName_GLEntry; "Gen. Journal Line"."Account Name")
                {
                }
                column(GLAccountName2_GLEntry; GLAccName2)
                {
                }
                column(JournalBatchName_GLEntry; "Gen. Journal Line"."Journal Batch Name")
                {
                }
                column(Description_GLEntry; "Gen. Journal Line".Description)
                {
                }
                column(Negative_GLEntry; Negative)
                {
                }
                column(AmounttxtNew; LocalizationCenter.EngText(TotalDebitAmt, PostedGenJournal."Currency Code")) { }
                column(CompName; CompanyNameText)
                {
                }
                column(ChequeNo; ChequeNo)
                {
                }
                column(ChequeDate; ChequeDate)
                {
                }
                column(DescTxt; DescTxt)
                {
                }
                //Data Apply Vendor Ledger entry
                dataitem(AppliedVendLedgEntry; "Vendor Ledger Entry")
                {
                    DataItemLink = "Document No. Before Posting" = FIELD("Document No.");  //, "Gen. Jnl. Line No" = field("Line No.");
                    DataItemTableView = SORTING("Document No.");
                    UseTemporary = true;
                    dataitem(DetailVendorLedgerEntry; "Detailed Vendor Ledg. Entry")
                    {
                        DataItemLink = "Applied Vend. Ledger Entry No." = FIELD("Entry No.");
                        DataItemTableView = SORTING("Applied Vend. Ledger Entry No.", "Entry Type")
                        WHERE("Initial Document Type" = FILTER(Invoice | "Credit Memo" | " "), Unapplied = CONST(false), "Entry Type" = CONST(Application));
                        UseTemporary = true;
                        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                        {
                            CalcFields = "Original Amount", "Remaining Amount";
                            DataItemLink = "Entry No." = FIELD("Vendor Ledger Entry No.");
                            DataItemTableView = SORTING("Document No.");
                            trigger OnPreDataItem()
                            begin
                                // LOC 2018 15.08.18 NG +
                                if Count > 0 then
                                    Applied := true;
                                // -
                            end;

                            trigger OnAfterGetRecord()
                            var
                                OwingNum: Decimal;
                            begin
                                entryNo += 1;
                                tempTB.Init();
                                tempTB."Line No." := entryNo;
                                tempTB.Description := Description;
                                tempTB."Document Type" := "Document Type";
                                tempTB."Document No." := "Document No."; // Form No.
                                tempTB."Account No." := "Vendor No.";
                                tempTB."External Document No." := "External Document No."; // Invoice No.
                                tempTB."Invoice Received Date" := "Posting Date"; // Invouce Date
                                tempTB.Amount := "Original Amount"; // Invoice Amount | Amount
                                tempTB."Due Date" := "Due Date"; // Due Date
                                tempTB."Payment Amount" := DetailVendorLedgerEntry.Amount; // Payment Amount
                                tempTB."Discount Amount" := 0; // Discount Amount
                                Clear(OwingNum);
                                OwingNum := getOwingPerDocument(AppliedVendLedgEntry."Document No.",
                                            AppliedVendLedgEntry."Posting Date", "Entry No.", DetailVendorLedgerEntry."Entry No.", DetailVendorLedgerEntry.Amount);
                                tempTB.Owing := OwingNum; // Owing
                                tempTB."Is Detail" := true;
                                tempTB.Insert();
                            end;
                        }
                        trigger OnAfterGetRecord()
                        var
                            myInt: Integer;
                        begin
                            myInt := DetailVendorLedgerEntry."Entry No.";
                        end;
                    }
                }
                //-

                //Discount Amount
                dataitem(PostedGenJournalDisc; "Gen. Journal Line")
                {
                    DataItemLink = "Document No." = FIELD("Document No.");
                    trigger OnPreDataItem()
                    var
                        myInt: Integer;
                    begin
                        SetRange("Account Type", "Account Type"::"G/L Account");
                    end;

                    trigger OnAfterGetRecord()
                    var
                        myInt: Integer;
                    begin
                        CalcFields("Account Name");
                        entryNo += 1;
                        tempTB.Init();
                        tempTB."Line No." := entryNo;
                        tempTB.Description := Description;
                        tempTB."Document Type" := "Document Type";
                        tempTB."Document No." := "Account No."; // Form No.
                        tempTB."External Document No." := "Account Name"; // Invoice No.
                        tempTB.Amount := Amount; // Invoice Amount | Amount
                        tempTB."Payment Amount" := Amount; // Payment Amount
                        tempTB."Check Balancing" := true;
                        tempTB."Is Detail" := true;
                        tempTB.Insert();
                    end;
                }
                //-

                dataitem(Integer; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                    column(DocumentNo_ApplyVendLedgEntry; tempTB."Document No.") // Form No
                    {
                    }
                    column(ExternalDocumentNo_ApplyVendLedgEntry; tempTB."External Document No.") //Invoice No.
                    {
                    }
                    column(InvoiceDate_ApplyVendLedgEntry; tempTB."Invoice Received Date") // Invoice Date
                    {
                    }
                    column(Is_Detail; tempTB."Is Detail") { }
                    column(LineNo; Format(tempTB."Line No.")) { }
                    column(AmounttoApply_ApplyVendLedgEntry; checkSign(tempTB.Amount, tempTB."Check Balancing")) //Invoice Amount | Amount
                    {
                    }
                    column(DueDate_ApplyVendLedgEntry; tempTB."Due Date") // Due Date   
                    {
                    }
                    column(PaymentAmount_ApplyVendLedgEntry; tempTB."Payment Amount") // Payment Amount
                    {
                    }
                    column(DiscountAmount_ApplyVendLedgEntry; tempTB."Discount Amount") // Discount Amount
                    {
                    }
                    column(Owing_ApplyVendLedgEntry; Abs(tempTB.Owing)) // Owing
                    {
                    }
                    column(LineCount; Format(LineCount)) { }
                    trigger OnPreDataItem()
                    begin
                        tempTB.Reset();
                        tempTB.SetCurrentKey("Line No.");
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then begin
                            if not tempTB.FindSet() then
                                CurrReport.Break();
                        end else
                            if tempTB.Next() = 0 then
                                CurrReport.Break();

                        currLineNo := tempTB."Line No.";
                        if currLineNo <> TempLineNo then begin
                            //-counter for set maximum line on page 
                            if StrLen(tempTB."External Document No.") > 15 then
                                LineCount += 2
                            else
                                LineCount += 1;
                            //-
                        end else begin
                            CurrReport.Skip();
                        end;
                        TempLineNo := currLineNo;
                    end;
                }
                //-

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                    DocNumEx: Code[20];
                begin
                    CalcFields("Account Name");
                    Negative := (Amount < 0);
                    if Negative then
                        CurrReport.Skip();

                    DocNumEx := "Document No.";
                    Clear(BankName);
                    BankAccountLedgerEntry2.Reset();
                    // BankAccountLedgerEntry2.SetRange("External Document No.", "Document No.");
                    if BankAccountLedgerEntry2.FindSet() then begin
                        Clear(BankAcc);
                        BankAcc.Get(BankAccountLedgerEntry2."Bank Account No.");
                        if BankName = '' then
                            BankName := BankAccountLedgerEntry2."Bank Account No." + ' : ' + BankAcc.Name;
                    end;

                    if DocNo <> "Document No." then begin
                        Clear(CompanyNameText);
                        CompanyNameText := Companyinfo.Name + ' ' + Companyinfo."Name 2";

                        Clear(TotalDebitAmt);
                        Clear(TotalCreditAmt);
                        //WHERE("Initial Document Type" = FILTER(Invoice | "Credit Memo"), Unapplied = CONST(false), "Entry Type" = CONST(Application));
                        if AppliedVendLedgEntry2.FindSet() then begin
                            repeat
                                DetailVendorLedgerEntry2.Reset();
                                DetailVendorLedgerEntry2.SetRange("Applied Vend. Ledger Entry No.", AppliedVendLedgEntry2."Entry No.");
                                DetailVendorLedgerEntry2.SetFilter("Initial Document Type", '%1|%2|%3',
                                DetailVendorLedgerEntry2."Initial Document Type"::Invoice, DetailVendorLedgerEntry2."Initial Document Type"::"Credit Memo", DetailVendorLedgerEntry2."Initial Document Type"::" ");
                                DetailVendorLedgerEntry2.SetRange(Unapplied, false);
                                DetailVendorLedgerEntry2.SetRange("Entry Type", DetailVendorLedgerEntry2."Entry Type"::Application);
                                if DetailVendorLedgerEntry2.Find('-') then
                                    TotalDebitAmt += DetailVendorLedgerEntry2.Amount;
                            until AppliedVendLedgEntry2.Next() = 0;
                        end;

                        //check discount amount
                        PostedGenJournal.Reset;
                        PostedGenJournal.SetCurrentKey("Document No.");
                        PostedGenJournal.SetRange("Document No.", "Document No.");
                        PostedGenJournal.SetRange("Account Type", "Account Type"::"G/L Account");
                        if PostedGenJournal.FindSet then begin
                            repeat
                                TotalDebitAmt += PostedGenJournal.Amount;
                            until PostedGenJournal.Next = 0;
                        end;
                        //-

                        Clear(LocalizationCenter);
                        Amounttxt := LocalizationCenter.EngText(TotalDebitAmt, "Currency Code");

                        Clear(UserName);
                        UserRec.Reset;
                        UserRec.SetCurrentKey("User Name");
                        //  Loc 20.04.17 TJ  +
                        UserRec.SetRange("User Name", UserId);
                        //-
                        if UserRec.FindFirst then
                            UserName := UserRec."Full Name";
                    end else begin
                        CurrReport.Skip();
                    end;
                    DocNo := "Document No.";

                end;

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    Clear(DocNo);
                end;
            }

            dataitem(Integer1; "Integer")
            {
                column(Integer_number; Integer.Number)
                {
                }

                trigger OnPreDataItem()
                begin
                    ModPage := LineCount mod MaxLine;
                    if ModPage <> 0 then
                        SetRange(Number, 1, MaxLine - ModPage)
                    else
                        SetRange(Number, 1, 0);
                end;
            }



            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                Links: Record "Record Link";
                NoteManagement: Codeunit "Entry Event";
                MyRecordRef: RecordRef;
            begin
                DocNo2 := "Document No.";
                if LastHdr <> "Document No." then
                    LastHdr := "Document No."
                else
                    CurrReport.Skip;

                //initiate linecount 
                LineCount := 0;
                //-

                Clear(Notes);

                tempTB.DeleteAll();

                //info approval 
                populateApprovalDateOnListApproval("Document No.");
                //-

                if DocNo <> "Document No." then begin
                    Clear(CompanyNameText);
                    CompanyNameText := Companyinfo.Name + ' ' + Companyinfo."Name 2";

                    Clear(TotalDebitAmt);
                    Clear(TotalCreditAmt);
                    PostedGenJournal.Reset;
                    PostedGenJournal.SetCurrentKey("Document No.");
                    PostedGenJournal.SetRange("Document No.", "Document No.");
                    if PostedGenJournal.FindSet then
                        repeat
                            MyRecordRef.GetTable(PostedGenJournal);

                            //- Collect Note
                            Clear(TempNotes);
                            TempNotes := NoteManagement.GetNotesForRecordRef(MyRecordRef);
                            if TempNotes <> '' then begin
                                if Notes = '' then
                                    Notes := TempNotes
                                else
                                    Notes := ' ' + TempNotes;
                            end;
                            //-

                            if PostedGenJournal."Payee Name" <> '' then
                                PayeeNameText := PostedGenJournal."Payee Name";

                            TotalDebitAmt += PostedGenJournal."Debit Amount";
                            TotalCreditAmt += PostedGenJournal."Credit Amount";
                        until PostedGenJournal.Next = 0;

                    Clear(LocalizationCenter);
                    Amounttxt := LocalizationCenter.EngText(TotalDebitAmt, "Currency Code");

                    Clear(CurrencyFactor);
                    Clear(CurrecyCodeTxt);
                    if CurrecyCodeTxt = '' then begin
                        PostedGenJournal.Reset;
                        PostedGenJournal.SetCurrentKey("Account Type", "Document No.");
                        PostedGenJournal.SetFilter("Account Type", '%1|%2|%3', "Account Type"::Vendor, "Account Type"::Employee, "Source Type"::"Bank Account");
                        PostedGenJournal.SetRange("Document No.", "Document No.");
                        if PostedGenJournal.Find('-') then
                            repeat
                                if (PostedGenJournal."Currency Code" <> '') and (CurrecyCodeTxt = '') then begin
                                    CurrecyCodeTxt := PostedGenJournal."Currency Code";
                                    if PostedGenJournal."Currency Factor" <> 0 then
                                        CurrencyFactor := PostedGenJournal."Currency Factor"
                                    else
                                        CurrencyFactor := 1;
                                end
                            until PostedGenJournal.Next = 0;
                        //Get CurrecyCode From GeneralLedgerSetup
                        if CurrecyCodeTxt = '' then begin
                            GLLedgerSetupRec.Reset;
                            GLLedgerSetupRec.Get;
                            CurrecyCodeTxt := GLLedgerSetupRec."LCY Code";
                            CurrencyFactor := 1;
                            // MESSAGE('GLLedgerSetupRec."LCY Code" :' + GLLedgerSetupRec."LCY Code");
                        end
                    end;
                    // -
                    // Loc 25.04.17 TJ  +
                    Clear(PaidTo);
                    Clear(VendAddress);
                    if PaidTo = '' then begin
                        initiatReciptBank(3);
                        Vendor.Reset;
                        PostedGenJournal.Reset();
                        PostedGenJournal.SetRange("Account Type", "Account Type"::Vendor);
                        PostedGenJournal.SetRange("Document No.", "Document No.");
                        if PostedGenJournal.FindFirst() then begin
                            if Vendor.Get(PostedGenJournal."Account No.") then begin
                                PaidTo := Vendor."No." + ' - ' + Vendor.Name;
                                VendAddress := Vendor.Address + ' ' + Vendor."Address 2";
                            end;
                        end;
                        //Vend. Bank Account
                        Clear(VendBankAccount);
                        PostedGenJournal.Reset();
                        PostedGenJournal.SetRange("Account Type", "Account Type"::Vendor);
                        PostedGenJournal.SetRange("Document No.", "Document No.");
                        PostedGenJournal.SetFilter("Recipient Bank Account", '<>%1', '');
                        if PostedGenJournal.FindFirst() then begin
                            VendBankAccount.Reset();
                            VendBankAccount.SetRange("Vendor No.", PostedGenJournal."Account No.");
                            VendBankAccount.SetRange(Code, PostedGenJournal."Recipient Bank Account");
                            if VendBankAccount.Find('-') then begin
                                ReceiptBankAccount.Set(1, VendBankAccount.Name);
                                ReceiptBankAccount.Set(2, VendBankAccount.Code);
                                ReceiptBankAccount.Set(3, VendBankAccount."Bank Account No.");
                            end;
                        end;
                        //Employee
                        employee.Reset();
                        PostedGenJournal.Reset;
                        PostedGenJournal.SetCurrentKey("Account Type", "Document No.");
                        PostedGenJournal.SetRange("Account Type", "Account Type"::Employee);
                        PostedGenJournal.SetRange("Document No.", "Document No.");
                        if PostedGenJournal.FindFirst then begin
                            if employee.Get(PostedGenJournal."Account No.") then
                                PaidTo := employee.FullName();
                        end;
                        //-
                        //Default 
                        if PaidTo = '' then
                            PaidTo := GLHeader.Description;
                        //-
                    end;
                    // -
                    Header := 'Payment Request';
                end;
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                Clear(LocalizationCenter);
                Clear(TotalPayment);
                Clear(TempLineNo);
                Clear(currLineNo);
                Clear(LastHdr);
                Clear(Notes);
                Clear(PayeeNameText);
                Clear(TempNotes);
                SourceCodeSetup.Get;
                SetFilter("Source Code", '<>%1', SourceCodeSetup."Inventory Post Cost");
            end;

        }

    }

    labels
    {
        Header1 = 'Payment Request';
    }

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        MaxLine := 19;
    end;

    local procedure checkSign(iAmount: Decimal; iSign: Boolean): Decimal
    begin
        if iSign then
            exit(iAmount)
        else
            exit(Abs(iAmount));
    end;

    local procedure initiatReciptBank(iMaxSeq: Integer)
    var
        iSeq: Integer;
    begin
        for iSeq := 1 to iMaxSeq do begin
            ReceiptBankAccount.Add('');
        end;
    end;

    local procedure getOwingPerDocument(iDocumentNo: Text; iPostingDate: Date; iVendorEntry: Integer; iDetEntryNo: Integer; iPaymentAmount: Decimal): Decimal
    var
        detailvendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        detailvendorLedgerEntry2: Record "Detailed Vendor Ledg. Entry";
        MaxEntryNo: Integer;
    begin
        //- get max entry no base on document and posting date
        Clear(MaxEntryNo);
        /*Clear(detailvendorLedgerEntry);
        detailvendorLedgerEntry.Reset();
        detailvendorLedgerEntry.SetRange("Vendor Ledger Entry No.", iVendorEntry);
        detailvendorLedgerEntry.SetRange("Document No.", iDocumentNo);
        detailvendorLedgerEntry.SetRange("Posting Date", iPostingDate);
        detailvendorLedgerEntry.SetCurrentKey("Entry No.");
        detailvendorLedgerEntry.Ascending(false);
        if detailvendorLedgerEntry.FindFirst() then
            MaxEntryNo := detailvendorLedgerEntry."Entry No.";
        */
        MaxEntryNo := iDetEntryNo;
        //-
        //calculate owing base on range entryno 
        Clear(detailvendorLedgerEntry2);
        detailvendorLedgerEntry2.Reset();
        detailvendorLedgerEntry2.SetRange("Vendor Ledger Entry No.", iVendorEntry);
        detailvendorLedgerEntry2.SetFilter("Entry No.", '<=%1', MaxEntryNo);
        if detailvendorLedgerEntry2.FindSet() then begin
            detailvendorLedgerEntry2.CalcSums(Amount);
            detailvendorLedgerEntry2.Amount += iPaymentAmount;
            exit(Abs(detailvendorLedgerEntry2.Amount));
        end;
        //-
        exit(0);
    end;

    trigger OnPreReport()
    begin
        Companyinfo.Get;
        CompanyInfo.CalcFields(Picture);
        v_max_seq := 4;
    end;

    local procedure populateApprovalDateOnListApproval(iDocNo: Text)
    var
        approvalEntry: Record "Approval Entry";
        iSeq: Integer;
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        //Iniatiate list value 
        initiateListSequneceData(v_max_seq);
        //get approval entry data
        Clear(approvalEntry);
        GetGeneralJournalBatch(GenJournalBatch, GLHeader);
        approvalEntry.Reset();
        ApprovalEntry.SetFilter("Table ID", '%1|%2', DATABASE::"Gen. Journal Batch", DATABASE::"Gen. Journal Line");
        ApprovalEntry.SetFilter("Record ID to Approve", '%1|%2', GenJournalBatch.RecordId, GLHeader.RecordId);
        ApprovalEntry.SetRange("Related to Change", false);
        approvalEntry.SetRange(Status, approvalEntry.Status::Approved);
        approvalEntry.SetCurrentKey(approvalEntry."Sequence No.", "Last Date-Time Modified");
        approvalEntry.Ascending(true);

        if approvalEntry.FindSet() then begin
            // iSeq := 1;
            repeat
                if approvalEntry."Sequence No." <= v_max_seq then begin
                    v_listApprovalDate.Set(approvalEntry."Sequence No.", DT2Date(approvalEntry."Last Date-Time Modified"));
                    // iSeq := iSeq + 1;
                end;
                //Additional condition 28 Oct 2025
                if approvalEntry."Sequence No." > v_max_seq then begin
                    v_listApprovalDate.Set(v_max_seq, DT2Date(approvalEntry."Last Date-Time Modified"));
                end;
            until approvalEntry.Next() = 0;
        end;
        // get PO preparation date
        getDateSendToApproval(iDocNo);
    end;

    local procedure GetGeneralJournalBatch(var GenJournalBatch: Record "Gen. Journal Batch"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        if not GenJournalBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") then
            GenJournalBatch.Get(GenJournalLine.GetFilter("Journal Template Name"), GenJournalLine.GetFilter("Journal Batch Name"));
    end;

    local procedure initiateListSequneceData(iMaxSeq: Integer)
    var
        iSeq: Integer;
    begin
        for iSeq := 1 to iMaxSeq do begin
            v_listApprovalDate.Add(0D);
        end;
    end;

    local procedure getDateSendToApproval(iDocNo: Text)
    var
        approvalEntry: Record "Approval Entry";
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        Clear(v_preparation_date);
        Clear(approvalEntry);
        approvalEntry.Reset();
        GetGeneralJournalBatch(GenJournalBatch, GLHeader);
        ApprovalEntry.SetFilter("Table ID", '%1|%2', DATABASE::"Gen. Journal Batch", DATABASE::"Gen. Journal Line");
        ApprovalEntry.SetFilter("Record ID to Approve", '%1|%2', GenJournalBatch.RecordId, GLHeader.RecordId);
        ApprovalEntry.SetRange("Related to Change", false);
        approvalEntry.SetRange("Sequence No.", 1);
        approvalEntry.SetCurrentKey("Date-Time Sent for Approval");
        approvalEntry.SetAscending("Date-Time Sent for Approval", false);
        if approvalEntry.Find('-') then
            v_preparation_date := DT2Date(approvalEntry."Date-Time Sent for Approval");
    end;

    var
        v_preparation_date: Date;
        v_max_seq: Integer;
        v_listApprovalDate: List of [Date];

        TotalPayment: Decimal;
        Notes: Text;
        TempNotes: Text;
        LocalizationCenter: Codeunit "Localization Center";
        Amounttxt: Text;
        TotalDebitAmt: Decimal;
        TotalCreditAmt: Decimal;
        DocNo: Code[20];
        TempLineNo: Integer;
        currLineNo: Integer;
        ReceiptBankAccount: List of [Text];
        VendBankAccount: Record "Vendor Bank Account";
        GLEntry: Record "G/L Entry";
        Companyinfo: Record "Company Information";
        CompanyNameText: Text;
        GLSetup: Record "General Ledger Setup";
        LastHdr: Code[20];
        PrintGroup: Boolean;
        Negative: Boolean;
        VendLedgEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        employee: Record Employee;
        PostedGenJournal: Record "Gen. Journal Line";
        VendorNo: Code[20];
        VendorName: Text;
        CheckLedgEntry: Record "Check Ledger Entry";
        ChequeNo: Code[10];
        ChequeDate: Date;
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        BankName: Text;
        BankAcc: Record "Bank Account";
        AmounttoApplyFCY: Decimal;
        ExchangeRate: Decimal;
        TaxInvoiceNo: Code[20];
        WHTAmount: Decimal;
        PaidTo: Text;
        DescTxt: Text;
        VendAddress: Text;
        SourceCodeSetup: Record "Source Code Setup";
        UserRec: Record User;
        UserName: Text;
        CurrencyFactor: Decimal;
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        TotalAmount: Decimal;
        GLEntry2: Record "G/L Entry";
        CheckGLAccount: Boolean;
        GLAccount: Text;
        BaseGLEntry: Record "G/L Entry";
        DocNo2: Text;
        AmountTxtGroup: Text;
        // LOC17 06.03.17 KS
        isTotalZero: Boolean;
        firstAccount: Text;
        Header: Text;
        GLAccountRec: Record "G/L Account";
        GLAccName2: Text;
        CurrecyCodeTxt: Text;
        GLLedgerSetupRec: Record "General Ledger Setup";
        // LOC 2018 15.08.18 NG
        Applied: Boolean;
        // LOC 2018 05.10.18 NG
        isFullVATType: Boolean;
        tempTB: Record "Gen. Journal Line" temporary;
        entryNo: Integer;

        ModPage: Integer;
        MaxLine: Integer;
        RunningNo: Integer;
        LineCount: Integer;

        PayeeNameText: Text;
        AppliedVendLedgEntry2: Record "Vendor Ledger Entry" temporary;
        DetailVendorLedgerEntry2: Record "Detailed Vendor Ledg. Entry" temporary;
        BankAccountLedgerEntry2: Record "Bank Account Ledger Entry" temporary;


    procedure SetRecord(var TempGLEntry: Record "G/L Entry"; var TempVendorLedger: Record "Vendor Ledger Entry"; var TempDetailVendorLedger: Record "Detailed Vendor Ledg. Entry"; var TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        AppliedVendLedgEntry.Copy(TempVendorLedger, true);
        DetailVendorLedgerEntry.Copy(TempDetailVendorLedger, true);
        AppliedVendLedgEntry2.Copy(TempVendorLedger, true);
        DetailVendorLedgerEntry2.Copy(TempDetailVendorLedger, true);
        BankAccountLedgerEntry2.Copy(TempBankAccountLedgerEntry, true);
    end;

}