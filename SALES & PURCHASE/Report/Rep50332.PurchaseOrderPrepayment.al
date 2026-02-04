report 50332 "Purchase Order - Prepayment"
{
    Caption = 'Purchase Order (Prepayment)';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/PurchaseOrder CAPSLOCK Prepayment.rdlc';
    ApplicationArea = Basic, Suite;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Prepayment; flagPrepayment()) { }
            column(Application; Application) { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(FaxNoVendor; Vendor_."Phone No." + '/' + Vendor_."Fax No.") { }
            column(VendorAddress; Vendor_.Address + ' ' + Vendor_."Address 2") { }
            column(VendorAddress2; Vendor_."Address 2") { }
            column(Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Contact; "Buy-from Contact") { }
            column(TotalLineAmount; TotalLineAmount) { AutoFormatType = 1; }
            column(TotalLineAmountDisc; TotalLineAmountDisc) { AutoFormatType = 1; }
            column(TotalWHTAMount; Abs(TotalWHTAMount)) { AutoFormatType = 1; }
            column(WHTPercentage; Abs(WHTPercentage))
            {

            }
            column(Terbilang; TexNO) { }
            column(Vendor_Shipment_No_; "Vendor Shipment No.") { }
            column(Quote_No_; "Quote No.") { }
            column(Document_Date; Format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2> <Month Text> <Year4>')) { }
            column(Order_Date; Format("Order Date", 0, '<Day,2> <Month Text> <Year4>')) { }
            column(WorkDate; Format(WorkDate(), 0, '<Day,2> <Month Text> <Year4>')) { }
            column(LogoCompany; CompanyInfo.Picture)
            {
            }
            column(Status; ((Status = Status::Released) Or (Status = Status::"Pending Prepayment"))) { }
            column(TotalAmount; TotalAmount) { AutoFormatType = 1; }
            column(TotalAmountWithVat; TotalAmountWithVat) { AutoFormatType = 1; }
            column(TotalVatAMount; TotalVatAMount) { AutoFormatType = 1; }
            column(Vatlabel; findVATPercentageLabel("No.")) { }
            column(Currency_Code; "Currency Code") { }
            column(paymentterms_Desc; paymentterms.Description) { }
            column(ShipVia; getDescriptionShipVia("Transport Method")) { }
            column(FOB_Point; getDescriptionFOBPoint("Shipment Method Code")) { }
            column(LoadingPort; getDescriptionLoadingPort("Area")) { }
            column(DestinationPort; getDescriptionDestinationPort("Entry Point")) { } //"Entry Point"
            column(Requested_Receipt_Date0; Format("Requested Receipt Date", 0, '<Day,2>-<Month Text,3>-<Year>')) { }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code") { }
            column(Purpose; Purpose) { }
            column(Reason; Reason) { }
            column(Notes; Notes) { }
            column(Same_Price; "Same Price") { }
            column(Order_Type; IsRepeatOrder) { }
            column(GM_Approval_Only; "GM Approval Only") { }
            column(IsRepeatOrder; IsRepeatOrder)
            {

            }
            column(Acknowledged_by; getJobTitleByEmpNo("Acknowledged by")) { }
            column(Approved_By; getJobTitleByEmpNo("Approved By")) { }
            column(Checked_By; getJobTitleByEmpNo("Checked By")) { }
            column(Issued_By; getJobTitleByEmpNo("Issued By")) { }
            column(Issued_ByName; getNameByEmpNo("Issued By")) { }
            column(Acc_Mgr_Name; getNameByEmpNo("Approved By 2")) { }
            column(Approved_By_2; getJobTitleByEmpNo("Approved By 2")) { }
            column(MaxLine; MaxLine) { }
            column(Rev; Rev) { }
            column(ApprovalSeq1; v_listApprovalName.Get(1))
            {
            }
            column(ApprovalSeq2; v_listApprovalName.Get(2))
            {
            }
            column(ApprovalSeq3; v_listApprovalName.Get(3))
            {
            }
            column(ApprovalSeq4; v_listApprovalName.Get(4))
            {
            }
            column(preparebyApproval; v_prepareby)
            {

            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Purchase Header";
                column(Inv__Discount_Amount; "Inv. Discount Amount") { }
                column(LineCount; Format(LineCountR)) { }
                column(LineCountInc; LineCount) { }
                column(LineCount_f1; leadingByZero(Format(LineCountR))) { }
                column(ItemNo_; "No.") { }
                column(Description; Description) { }
                column(Line_Discount__; "Line Discount %") { }
                column(Line_Discount_Amount; "Line Discount Amount") { }
                column(Quantity; Quantity) { AutoFormatType = 1; }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Line_Amount; "Line Amount") { }
                column(Unit_Cost__LCY_; "Unit Cost (LCY)") { }
                column(Direct_Unit_Cost; "Direct Unit Cost") { AutoFormatType = 1; }
                column(Requested_Receipt_Date; Format("Expected Receipt Date", 0, '<Day,2>-<Month Text,3>-<Year>')) { }
                column(Remarks; Remarks) { }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                    IncreInt: Integer;
                begin
                    Clear(IncreInt);
                    if (StrLen("Purchase Line".Description) > 40) then begin
                        IncreInt := 2;
                        LineCount += IncreInt;
                    end
                    else begin
                        IncreInt := 1;
                        LineCount += IncreInt;
                    end;
                    //check remark lines
                    if (StrLen("Purchase Line".Remarks) > 18) then begin
                        LineCount += Round((Round(StrLen("Purchase Line".Remarks) / 11, 1, '>') / 2), 1, '>') - (IncreInt);
                    end;
                    //-
                    LineCountR += 1;
                end;
            }
            dataitem("Integer"; "Integer")
            {
                column(Integer_number; Integer.Number)
                {
                }
                trigger OnPreDataItem()
                var
                    tempLineCount: Integer;
                begin
                    tempLineCount := LineCountR;
                    if LineCount > LineCountR then
                        tempLineCount := LineCountR + 1;
                    ModPage := tempLineCount mod MaxLine;
                    if ModPage <> 0 then
                        SetRange(Number, 1, MaxLine - ModPage)
                    else
                        SetRange(Number, 1, 0);
                end;
            }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                clear(IsRepeatOrder);
                if ("Order Type" = "Order Type"::"Repeat Order") then begin
                    IsRepeatOrder := true;
                    // "GM Approval Only" := true;
                end;
                Clear(Vendor_);
                Vendor_.Reset();
                Vendor_.SetRange("No.", "Purchase Header"."Buy-from Vendor No.");
                if Vendor_.Find('-') then;

                Clear(paymentterms);
                paymentterms.Reset();
                paymentterms.SetRange(Code, "Payment Terms Code");
                if paymentterms.Find('-') then;

                generaLedgerSetup.Get();
                if "Purchase Header"."Currency Code" = '' then
                    "Purchase Header"."Currency Code" := generaLedgerSetup."LCY Code";

                //calculate amount
                calculateAmount("No.");
                //populate info approvals
                populateApprovalDateOnListApproval("Purchase Header"."No.");
            end;
        }
    }


    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        //get list signature
        v_total_amount := 0;
        MaxLine := 8;
        v_max_seq := 4;
    end;

    local procedure findVATPercentageLabel(iNoPostesPurchase: Text): Text
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(PurchaseLine);
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document No.", iNoPostesPurchase);
        PurchaseLine.SetFilter(Type, '%1|%2', PurchaseLine.Type::Item, PurchaseLine.Type::"Fixed Asset");
        PurchaseLine.SetCurrentKey("Document No.", "VAT %");
        PurchaseLine.SetAscending("VAT %", false);
        if PurchaseLine.FindSet() then begin
            // if PurchaseLine."VAT %" <> 0 then
            exit(format(PurchaseLine."VAT %") + '%');
        end;

        exit('');
    end;

    local procedure flagPrepayment(): Text
    begin
        if "Purchase Header"."Prepayment %" > 0 then
            exit('YES')
        else
            exit('NO');
    end;

    local procedure calculateAmount(iNoPostesPurchase: Text)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(PurchaseLine);
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document No.", iNoPostesPurchase);
        // PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetFilter(Type, '%1|%2', PurchaseLine.Type::Item, "Purchase Line".Type::"Fixed Asset");
        if PurchaseLine.FindSet() then begin
            PurchaseLine.CalcSums(Amount, "Amount Including VAT", "Line Amount", "Line Discount Amount", "Inv. Discount Amount");
            TotalAmount := PurchaseLine.Amount;
            TotalAmountWithVat := PurchaseLine."Amount Including VAT";
            TotalVatAMount := TotalAmountWithVat - TotalAmount;
            TotalAmount := TotalAmount + TotalVatAMount;
            TotalLineAmount := PurchaseLine."Line Amount";
            TotalLineAmountDisc := PurchaseLine."Line Discount Amount" + PurchaseLine."Inv. Discount Amount";
            //WHT 
            TotalAmount := TotalAmount + TotalWHTAMount;
        end;

    end;

    local procedure getJobTitleByEmpNo(iEmpNo: Text): Text
    var
        employee: Record Employee;
    begin
        Clear(employee);
        employee.Reset();
        if employee.Get(iEmpNo) then
            exit(employee."Job Title");
        exit('');
    end;

    local procedure getNameByEmpNo(iEmpNo: Text): Text
    var
        employee: Record Employee;
    begin
        Clear(employee);
        employee.Reset();
        if employee.Get(iEmpNo) then
            exit(employee.FullName());
        exit('');
    end;

    local procedure getDescriptionShipVia(icode: Code[30]): Text
    var
        TransportMethod: Record "Transport Method";
    begin
        Clear(TransportMethod);
        TransportMethod.Reset();
        TransportMethod.SetRange(Code, icode);
        if TransportMethod.Find('-') then
            exit(TransportMethod.Description);
        exit('-');
    end;

    local procedure getDescriptionFOBPoint(icode: Code[30]): Text
    var
        ShipmentMethod: Record "Shipment Method";
    begin
        Clear(ShipmentMethod);
        ShipmentMethod.Reset();
        ShipmentMethod.SetRange(Code, icode);
        if ShipmentMethod.Find('-') then
            exit(ShipmentMethod.Description);
        exit('-');
    end;

    local procedure getDescriptionDestinationPort(icode: Code[30]): Text
    var
        entryexitpoint: Record "Entry/Exit Point";
    begin
        Clear(entryexitpoint);
        entryexitpoint.Reset();
        entryexitpoint.SetRange(Code, icode);
        if entryexitpoint.Find('-') then
            exit(entryexitpoint.Description);
        exit('-');
    end;

    local procedure getShipmentMethodDesc(iShipmentMethod: Text)
    var
        ShipmentMethod: Record "Shipment Method";
    begin

    end;

    local procedure getDescriptionLoadingPort(icode: Code[30]): Text // 
    var
        area_: Record "Area";
    begin
        Clear(area_);
        area_.Reset();
        area_.SetRange(Code, icode);
        if area_.Find('-') then
            exit(area_.Text);
        exit('-');
    end;

    local procedure leadingByZero(iText: Text): Text
    var
        vtext: Text;
    begin
        Clear(vtext);
        vtext := PADSTR('', 3 - strlen(iText), '0') + iText;
        exit(vtext);
    end;

    local procedure initiateListSequneceData(iMaxSeq: Integer)
    var
        iSeq: Integer;
    begin
        for iSeq := 1 to 4 do begin
            v_listApprovalDate.Add(0DT);
            v_listApprovalName.Add('');
        end;
    end;


    local procedure populateApprovalDateOnListApproval(iDocNo: Text)
    var
        approvalEntry: Record "Approval Entry";
        iSeq: Integer;
    begin
        //Iniatiate list value 
        initiateListSequneceData(v_max_seq);
        //get approval entry data
        Clear(approvalEntry);
        approvalEntry.Reset();
        approvalEntry.SetRange("Document No.", iDocNo);
        approvalEntry.SetRange("Document Type", approvalEntry."Document Type"::Order);
        approvalEntry.SetRange(Status, approvalEntry.Status::Approved);
        approvalEntry.SetCurrentKey(approvalEntry."Sequence No.", "Last Date-Time Modified");
        approvalEntry.Ascending(true);

        if approvalEntry.FindSet() then begin
            // iSeq := 1;
            repeat
                if approvalEntry."Sequence No." <= v_max_seq then begin
                    v_listApprovalDate.Set(approvalEntry."Sequence No.", approvalEntry."Last Date-Time Modified");
                    v_listApprovalName.Set(approvalEntry."Sequence No.", getApproverName(approvalEntry."Approver ID") + '-' +
                    Format(approvalEntry."Last Date-Time Modified", 0, '<Day,2>-<Month,2>-<Year> <Hours24,2>.<Minutes,2>') +
                    '-' + Format(approvalEntry."Entry No."));
                end;
            until approvalEntry.Next() = 0;
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

    local procedure getDateSendToApproval(iDocNo: Text)
    var
        approvalEntry: Record "Approval Entry";
    begin
        Clear(v_preparation_date);
        Clear(approvalEntry);
        Clear(v_prepareby);
        approvalEntry.Reset();
        approvalEntry.SetRange("Document No.", iDocNo);
        approvalEntry.SetRange("Sequence No.", 1);
        approvalEntry.SetCurrentKey("Date-Time Sent for Approval");
        approvalEntry.SetAscending("Date-Time Sent for Approval", false);
        if approvalEntry.Find('-') then begin
            v_preparation_date := approvalEntry."Date-Time Sent for Approval";
            v_prepareby := getApproverName(approvalEntry."Sender ID") + '-' +
                    Format(approvalEntry."Date-Time Sent for Approval", 0, '<Day,2>-<Month,2>-<Year> <Hours24,2>.<Minutes,2>') +
                    '-' + Format(approvalEntry."Entry No.");
        end;
    end;

    var
        v_max_seq: Integer;
        v_preparation_date: DateTime;
        v_prepareby: Text;
        v_listApprovalDate: List of [DateTime];
        v_listApprovalName: List of [Text];
        v_total_amount: Decimal;
        TotalAmount: Decimal;
        TotalAmountWithVat: Decimal;
        TotalVatAMount: Decimal;

        TotalLineAmount: Decimal;
        TotalLineAmountDisc: Decimal;

        TotalWHTAMount: Decimal;
        WHTPercentage: Decimal;

        LineCountR: Integer;

        EmployeeSignature1: Record Employee;
        EmployeeSignature2: Record Employee;
        EmployeeSignature3: Record Employee;

        IsRepeatOrder: Boolean;


        //Custom 
        ModPage: Integer;
        MaxLine: Integer;
        RunningNo: Integer;
        LineCount: Integer;
        CompanyInfo: Record "Company Information";
        Vendor_: Record Vendor;

        generaLedgerSetup: Record "General Ledger Setup";

        TexNO: Text[250];

        paymentterms: Record "Payment Terms";

}