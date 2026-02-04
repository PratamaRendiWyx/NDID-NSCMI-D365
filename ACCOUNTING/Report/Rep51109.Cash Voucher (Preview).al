report 51109 "Cash Voucher (Preview)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/Cash Voucher (Preview).rdlc';
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
            column(Amounttxt; Amounttxt)
            {
            }
            //-approval etries info 
            column(ApprovalSeq1Text; v_listApprovalName.Get(1))
            {
            }
            column(ApprovalSeq2Text; v_listApprovalName.Get(2))
            {
            }
            column(ApprovalSeq3Text; v_listApprovalName.Get(3))
            {
            }
            // column(ApprovalSeq3Text; v_listApprovalName.Get(3))
            // {
            // }
            column(preparebyApproval; v_prepareby)
            {

            }
            column(ApprovalSeq1; v_listApprovalDate.Get(1))
            {
            }
            column(ApprovalSeq2; v_listApprovalDate.Get(2))
            {
            }
            column(ApprovalSeq3; v_listApprovalDate.Get(3))
            {
            }
            column(v_preparation_date; v_preparation_date) { }
            //
            dataitem("Gen. Journal Line"; "Gen. Journal Line")
            {
                DataItemLink = "Document No." = FIELD("Document No.");
                DataItemTableView = SORTING("Line No.");

                column(LineCount; Format(LineCount)) { }
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

                column(TotalCreditAmt; TotalCreditAmt)
                {
                }
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


                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                    Vendor: Record Vendor;
                    Bank: Record "Bank Account";
                    Employee: Record Employee;
                    Customer: Record Customer;
                    LengtDesc: Integer;
                begin
                    CalcFields("Account Name");
                    Negative := (Amount < 0);
                    if Negative then
                        CurrReport.Skip();

                    Clear(BankName);
                    Clear(BankAccLedgEntry);
                    // BankAccLedgEntry.SetRange("Document No.", "Document No.");
                    if BankAccLedgEntry.FindFirst then begin
                        Clear(BankAcc);
                        BankAcc.Get(BankAccLedgEntry."Bank Account No.");
                        if BankName = '' then
                            BankName := BankAcc.Name;
                    end;

                    case
                       "Account Type" of
                        "Account Type"::Employee:
                            begin
                                Clear(Employee);
                                if Employee.Get("Account No.") then
                                    "Account Name" := Employee.FullName();
                            end;
                        "Account Type"::"Bank Account":
                            begin
                                Clear(Bank);
                                if Bank.Get("Account No.") then
                                    "Account Name" := Bank.Name;
                            end;
                        "Account Type"::Customer:
                            begin
                                Clear(Customer);
                                if Customer.Get("Account No.") then
                                    "Account Name" := Customer.Name;
                            end;
                        "Account Type"::Vendor:
                            begin
                                Clear(Vendor);
                                if Vendor.Get("Account No.") then
                                    "Account Name" := Vendor.Name;
                            end;
                    end;
                    //Default
                    if "Account Name" = '' then
                        "Account Name" := Description;
                    //-

                    //-counter for set maximum line on page 
                    Clear(LengtDesc);
                    LengtDesc := StrLen("Gen. Journal Line".Description);
                    if (LengtDesc > 50) then begin
                        if LengtDesc < 100 then
                            LineCount += 2
                        else
                            LineCount += 3;
                    end
                    else
                        LineCount += 1;
                    //-

                    if DocNo <> "Document No." then begin
                        Clear(CompanyNameText);
                        CompanyNameText := Companyinfo.Name + ' ' + Companyinfo."Name 2";

                        Clear(TotalDebitAmt);
                        Clear(TotalCreditAmt);
                        PostedGenJournal.Reset;
                        PostedGenJournal.SetCurrentKey("Document No.");
                        PostedGenJournal.SetRange("Document No.", "Document No.");
                        if PostedGenJournal.FindSet then begin
                            repeat
                                TotalDebitAmt += PostedGenJournal."Debit Amount";
                                //-Balancing Account
                                if PostedGenJournal."Bal. Account No." <> '' then
                                    TotalDebitAmt += PostedGenJournal."Credit Amount";
                                //-
                                TotalCreditAmt += PostedGenJournal."Credit Amount";
                            until PostedGenJournal.Next = 0;
                        end;

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

            dataitem("Posted Gen. Journal Line2"; "Gen. Journal Line")
            {
                DataItemLink = "Document No." = FIELD("Document No.");
                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    SetFilter("Bal. Account No.", '<>%1', '');
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                    BankAccount: Record "Bank Account";
                    AccountName: Text;
                begin
                    Clear(BankAccount);
                    Clear(AccountName);
                    entryNo += 1;
                    tempTB.Init();
                    tempTB."Line No." := entryNo;
                    tempTB."Document Type" := "Document Type";
                    tempTB."Document No." := "Document No.";
                    tempTB."Account No." := "Bal. Account No.";
                    case
                       "Bal. Account Type" of
                        "Bal. Account Type"::"Bank Account":
                            begin
                                if BankAccount.Get("Bal. Account No.") then
                                    AccountName := BankAccount.Name;
                            end;
                    end;
                    tempTB."Account Name 2" := AccountName;
                    tempTB."Debit Amount" := "Credit Amount";
                    tempTB."Credit Amount" := 0;
                    TotalDebitAmt += tempTB."Debit Amount";
                    tempTB.Description := AccountName;
                    tempTB.Amount := "Credit Amount";
                    tempTB."Check Balancing" := true;

                    tempTB.Insert();
                end;
            }

            dataitem(Integer1; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                column(AccountNoTempTB; tempTB."Account No.") { }
                column(accountNameTempTB; tempTB."Account Name 2") { }
                column(DebitAmoutTempTB; tempTB."Debit Amount") { }
                column(CreditAmountTempTB; tempTB."Credit Amount") { }
                column(AmountTempTB; tempTB.Amount) { }
                column(DesciptionTempTB; tempTB.Description) { }
                column(CheckBalancing; tempTB."Check Balancing") { }
                column(LineCount1; Format(LineCount)) { }
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

                    //-counter for set maximum line on page 
                    LineCount += 1;
                    //-
                end;
            }

            dataitem("Integer"; "Integer")
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

                //info approval 
                populateApprovalDateOnListApproval("Document No.");
                //-

                if DocNo <> "Document No." then begin
                    Clear(Notes);
                    Clear(CompanyNameText);
                    CompanyNameText := Companyinfo.Name + ' ' + Companyinfo."Name 2";

                    Clear(TotalDebitAmt);
                    Clear(TotalCreditAmt);
                    Clear(PostedGenJournal);
                    PostedGenJournal.Reset;
                    PostedGenJournal.SetCurrentKey("Document No.");
                    PostedGenJournal.SetRange("Document No.", "Document No.");
                    if PostedGenJournal.FindSet() then
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
                        PostedGenJournal.SetCurrentKey("Source Type", "Document No.");
                        PostedGenJournal.SetFilter("Source Type", '%1|%2|%3', "Source Type"::Vendor, "Source Type"::Employee, "Source Type"::"Bank Account");
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
                    if PaidTo = '' then begin
                        Vendor.Reset;
                        PostedGenJournal.Reset;
                        PostedGenJournal.SetCurrentKey("Source Type", "Document No.");
                        PostedGenJournal.SetRange("Source Type", "Source Type"::Vendor);
                        PostedGenJournal.SetRange("Document No.", "Document No.");
                        if PostedGenJournal.FindFirst then begin
                            if Vendor.Get(PostedGenJournal."Source No.") then
                                PaidTo := Vendor.Name;
                        end;
                        //Employee
                        employee.Reset();
                        PostedGenJournal.Reset;
                        PostedGenJournal.SetCurrentKey("Source Type", "Document No.");
                        PostedGenJournal.SetRange("Source Type", "Source Type"::Employee);
                        PostedGenJournal.SetRange("Document No.", "Document No.");
                        if PostedGenJournal.FindFirst then begin
                            if employee.Get(PostedGenJournal."Source No.") then
                                PaidTo := employee.FullName();
                        end;
                        //-
                        //Default 
                        if PaidTo = '' then
                            PaidTo := GLHeader.Description;
                        //-
                    end;
                    // -
                    Header := 'Cash Voucher';
                end;
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
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
        Header1 = 'CASH VOUCHER';
    }

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        MaxLine := 29;
    end;

    trigger OnPreReport()
    begin
        Companyinfo.Get;
        CompanyInfo.CalcFields(Picture);
        v_max_seq := 3;
    end;

    local procedure populateApprovalDateOnListApproval(iDocNo: Text)
    var
        approvalEntry: Record "Posted Approval Entry";
        iSeq: Integer;
        GlRegister: Record "G/L Register";
    begin
        Clear(GlRegister);
        //Iniatiate list value 
        initiateListSequneceData(v_max_seq);
        //get approval entry data
        Clear(approvalEntry);
        approvalEntry.Reset();
        approvalEntry.SetRange(Status, approvalEntry.Status::Approved);
        approvalEntry.SetRange("Posted Record ID", GlRegister.RecordId);
        approvalEntry.SetCurrentKey(approvalEntry."Sequence No.", "Last Date-Time Modified");
        approvalEntry.Ascending(true);
        if approvalEntry.FindSet() then begin
            // iSeq := 1;
            repeat
                if approvalEntry."Sequence No." <= v_max_seq then begin
                    v_listApprovalDate.Set(approvalEntry."Sequence No.", DT2Date(approvalEntry."Last Date-Time Modified"));
                    v_listApprovalName.Set(approvalEntry."Sequence No.", getApproverName(approvalEntry."Approver ID") + '-' +
               Format(approvalEntry."Last Date-Time Modified", 0, '<Day,2>-<Month,2>-<Year> <Hours24,2>.<Minutes,2>') +
               '-' + Format(approvalEntry."Entry No."));
                    // iSeq := iSeq + 1;
                end;
                if approvalEntry."Sequence No." > v_max_seq then begin
                    v_listApprovalDate.Set(v_max_seq, DT2Date(approvalEntry."Last Date-Time Modified"));
                    v_listApprovalName.Set(v_max_seq, getApproverName(approvalEntry."Approver ID") + '-' +
               Format(approvalEntry."Last Date-Time Modified", 0, '<Day,2>-<Month,2>-<Year> <Hours24,2>.<Minutes,2>') +
               '-' + Format(approvalEntry."Entry No."));
                end;
            until approvalEntry.Next() = 0;
        end else begin
            Clear(approvalEntry);
            approvalEntry.Reset();
            approvalEntry.SetRange(Status, approvalEntry.Status::Approved);
            approvalEntry.SetRange("Document No.", GLHeader."Document No.");
            approvalEntry.SetRange("Table ID", Database::"G/L Entry");
            approvalEntry.SetCurrentKey(approvalEntry."Sequence No.", "Last Date-Time Modified");
            approvalEntry.Ascending(true);
            if approvalEntry.FindSet() then begin
                // iSeq := 1;
                repeat
                    if approvalEntry."Sequence No." <= v_max_seq then begin
                        v_listApprovalDate.Set(approvalEntry."Sequence No.", DT2Date(approvalEntry."Last Date-Time Modified"));
                        v_listApprovalName.Set(approvalEntry."Sequence No.", getApproverName(approvalEntry."Approver ID") + '-' +
                   Format(approvalEntry."Last Date-Time Modified", 0, '<Day,2>-<Month,2>-<Year> <Hours24,2>.<Minutes,2>') +
                   '-' + Format(approvalEntry."Entry No."));
                        // iSeq := iSeq + 1;
                    end;
                    //Additional condition 28 Oct 2025
                    if approvalEntry."Sequence No." > v_max_seq then begin
                        v_listApprovalDate.Set(v_max_seq, DT2Date(approvalEntry."Last Date-Time Modified"));
                        v_listApprovalName.Set(v_max_seq, getApproverName(approvalEntry."Approver ID") + '-' +
                   Format(approvalEntry."Last Date-Time Modified", 0, '<Day,2>-<Month,2>-<Year> <Hours24,2>.<Minutes,2>') +
                   '-' + Format(approvalEntry."Entry No."));
                    end;
                until approvalEntry.Next() = 0;
            end;
        end;
        // get PO preparation date
        getDateSendToApproval(iDocNo);

    end;

    local procedure getApproverName(iApproverID: Text): Text
    var
        user: Record User;
    begin
        user.SetRange("User Name", iApproverID);
        if user.Find('-') then begin
            exit(user."Full Name".ToUpper());
        end;
        exit('');
    end;

    local procedure initiateListSequneceData(iMaxSeq: Integer)
    var
        iSeq: Integer;
    begin
        for iSeq := 1 to iMaxSeq do begin
            v_listApprovalDate.Add(0D);
            v_listApprovalName.Add('');
        end;
    end;

    local procedure getDateSendToApproval(iDocNo: Text)
    var
        approvalEntry: Record "Posted Approval Entry";
        GlRegister: Record "G/L Register";
    begin
        Clear(GlRegister);

        Clear(v_preparation_date);
        Clear(approvalEntry);
        Clear(v_prepareby);
        approvalEntry.Reset();
        approvalEntry.SetRange("Sequence No.", 1);
        approvalEntry.SetRange("Posted Record ID", GlRegister.RecordId);
        approvalEntry.SetCurrentKey("Date-Time Sent for Approval");
        approvalEntry.SetAscending("Date-Time Sent for Approval", false);
        if approvalEntry.Find('-') then begin
            v_prepareby := getApproverName(approvalEntry."Sender ID") + '-' +
                         Format(approvalEntry."Date-Time Sent for Approval", 0, '<Day,2>-<Month,2>-<Year> <Hours24,2>.<Minutes,2>') +
                         '-' + Format(approvalEntry."Entry No.");
            v_preparation_date := DT2Date(approvalEntry."Date-Time Sent for Approval");
        end else begin
            Clear(approvalEntry);
            approvalEntry.Reset();
            approvalEntry.SetRange("Document No.", GLHeader."Document No.");
            approvalEntry.SetRange("Table ID", Database::"G/L Entry");
            if approvalEntry.Find('-') then begin
                v_prepareby := getApproverName(approvalEntry."Sender ID") + '-' +
                             Format(approvalEntry."Date-Time Sent for Approval", 0, '<Day,2>-<Month,2>-<Year> <Hours24,2>.<Minutes,2>') +
                             '-' + Format(approvalEntry."Entry No.");
                v_preparation_date := DT2Date(approvalEntry."Date-Time Sent for Approval");
            end;
        end;
    end;

    procedure SetRecord(var TempGLEntry: Record "G/L Entry"; var TempVendorLedger: Record "Vendor Ledger Entry"; var TempDetailVendorLedger: Record "Detailed Vendor Ledg. Entry"; var TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        // AppliedVendLedgEntry.Copy(TempVendorLedger, true);
        // DetailVendorLedgerEntry.Copy(TempDetailVendorLedger, true);
        // AppliedVendLedgEntry2.Copy(TempVendorLedger, true);
        // DetailVendorLedgerEntry2.Copy(TempDetailVendorLedger, true);
        BankAccLedgEntry.Copy(TempBankAccountLedgerEntry, true);
    end;

    var
        v_preparation_date: Date;
        v_max_seq: Integer;
        v_listApprovalDate: List of [Date];
        v_listApprovalName: List of [Text];
        v_prepareby: Text;
        Notes: Text;
        TempNotes: Text;
        LocalizationCenter: Codeunit "Localization Center";
        Amounttxt: Text;
        TotalDebitAmt: Decimal;
        TotalCreditAmt: Decimal;
        DocNo: Code[20];
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
        BankAccLedgEntry: Record "Bank Account Ledger Entry" temporary;
        BankName: Text;
        BankAcc: Record "Bank Account";
        AmounttoApplyFCY: Decimal;
        ExchangeRate: Decimal;
        TaxInvoiceNo: Code[20];
        WHTAmount: Decimal;
        PaidTo: Text;
        DescTxt: Text;
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

}