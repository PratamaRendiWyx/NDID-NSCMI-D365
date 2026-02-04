report 50302 "Purchase Request"
{
    Caption = 'Purchase Request';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/PurchaseRequest.rdlc';
    ApplicationArea = Basic, Suite;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(FaxNoVendor; Vendor_."Phone No." + '/' + Vendor_."Fax No.") { }
            column(PhoneNo; Vendor_."Phone No.") { }
            column(FaxNo; Vendor_."Fax No.") { }
            column(VendorAddress; Vendor_.Address + ' ' + Vendor_."Address 2") { }
            column(VendorAddress2; Vendor_."Address 2") { }
            column(Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Contact; "Buy-from Contact") { }
            column(TotalLineAmount; TotalLineAmount) { }
            column(TotalWHTAMount; Abs(TotalWHTAMount)) { }
            column(WHTPercentage; Abs(WHTPercentage))
            {

            }
            column(DeptCode; "Shortcut Dimension 1 Code")
            {

            }
            column(ListCategory; getListCategory("No.")) { }
            column(Terbilang; TexNO) { }
            column(Vendor_Shipment_No_; "Vendor Shipment No.") { }
            column(Quote_No_; "Quote No.") { }
            column(Document_Date; Format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(Order_Date; Format("Order Date", 0, '<Day,2> <Month Text> <Year4>'))
            {

            }
            column(userID; UserId) { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2> <Month Text> <Year4>')) { }
            column(WorkDate; Format(WorkDate(), 0, '<Day,2> <Month Text> <Year4>')) { }
            column(LogoCompany; CompanyInfo.Picture)
            {
            }

            column(Status; (Status = Status::Released)) { }
            column(TotalAmount; TotalAmount) { }
            column(TotalAmountWithVat; TotalAmountWithVat) { }
            column(TotalVatAMount; TotalVatAMount) { }
            column(Vatlabel; findVATPercentageLabel("No.")) { }
            column(Currency_Code; "Currency Code") { }
            column(paymentterms_Desc; paymentterms.Description) { }
            column(ShipVia; getDescriptionShipVia("Transport Method")) { }
            column(FOB_Point; getDescriptionFOBPoint("Shipment Method Code")) { }
            column(LoadingPort; getDescriptionLoadingPort("Entry Point")) { }
            column(DestinationPort; getDescriptionDestinationPort("Area")) { }

            column(Requested_Receipt_Date0; Format("Requested Receipt Date", 0, '<Day,2> <Month Text> <Year4>')) { }
            column(IsRepeatOrder; IsRepeatOrder)
            {

            }
            column(Service; Service) { }
            column(Already_Done; "Already Done") { }
            column(Purpose; Purpose)
            {

            }
            column(Reason; Reason) { }
            column(Notes; Notes) { }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Purchase Header";
                column(Inv__Discount_Amount; "Inv. Discount Amount") { }
                column(LineCount; Format(LineCountR)) { }
                column(LineCount_f1; leadingByZero(Format(LineCountR))) { }
                column(Requested_Receipt_Date; Format("Requested Receipt Date", 0, '<Day,2>-<Month Text,3>-<Year4>')) { }
                column(ItemNo_; "No.") { }
                column(Description; Description) { }
                column(Line_Discount__; "Line Discount %") { }
                column(Line_Discount_Amount; "Line Discount Amount") { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Line_Amount; "Line Amount") { }
                column(Unit_Cost__LCY_; "Unit Cost (LCY)") { }
                column(Direct_Unit_Cost; "Direct Unit Cost") { }
                column(Remarks; Remarks) { }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    // LineCount += 1;
                    if (StrLen("Purchase Line".Description) > 29) then
                        LineCount += 2
                    else
                        LineCount += 1;
                    LineCountR += 1;
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
            begin
                clear(IsRepeatOrder);
                if ("Order Type" = "Order Type"::"Repeat Order") then begin
                    IsRepeatOrder := true;
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
        MaxLine := 7;
    end;

    local procedure findVATPercentageLabel(iNoPostesPurchase: Text): Text
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(PurchaseLine);
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document No.", iNoPostesPurchase);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetCurrentKey("Document No.", "VAT %");
        PurchaseLine.SetAscending("VAT %", false);
        if PurchaseLine.FindSet() then begin
            // if PurchaseLine."VAT %" <> 0 then
            exit('Value Added Tax (VAT) ' + format(PurchaseLine."VAT %") + '%');
        end;

        exit('');
    end;

    local procedure getListCategory(iDocNo: Text): Text
    var
        purchaselines: Record "Purchase Line";
        currDat: Text;
        TempDat: Text;
        Item: Record Item;
        listCategory: Text;
    begin
        Clear(listCategory);
        Clear(purchaselines);
        purchaselines.Reset();
        purchaselines.SetRange("Document No.", iDocNo);
        purchaselines.SetRange("Document Type", purchaselines."Document Type"::Quote);
        purchaselines.SetRange(Type, purchaselines.Type::Item);
        purchaselines.SetCurrentKey("No.");
        purchaselines.Ascending(true);
        if purchaselines.FindSet() then begin
            currDat := purchaselines."No.";
            if currDat <> TempDat then begin
                Item.Get(purchaselines."No.");
                if Item."Item Category Code" <> '' then begin
                    if listCategory = '' then begin
                        listCategory := item."Item Category Code";
                    end
                    else begin
                        listCategory += ',' + item."Item Category Code";
                    end;
                end;
            end;
            TempDat := currDat;
        end;
        exit(listCategory);
    end;

    local procedure calculateAmount(iNoPostesPurchase: Text)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(PurchaseLine);
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document No.", iNoPostesPurchase);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if PurchaseLine.FindSet() then begin
            PurchaseLine.CalcSums(Amount, "Amount Including VAT", "Line Amount");
            TotalAmount := PurchaseLine.Amount;
            TotalAmountWithVat := PurchaseLine."Amount Including VAT";
            TotalVatAMount := TotalAmountWithVat - TotalAmount;
            TotalAmount := TotalAmount + TotalVatAMount;
            TotalLineAmount := PurchaseLine."Line Amount";
            //WHT 
            TotalAmount := TotalAmount + TotalWHTAMount;

        end;

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

    local procedure getDescriptionLoadingPort(icode: Code[30]): Text
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

    local procedure getDescriptionDestinationPort(icode: Code[30]): Text
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



    var
        v_total_amount: Decimal;
        TotalAmount: Decimal;
        TotalAmountWithVat: Decimal;
        TotalVatAMount: Decimal;

        TotalLineAmount: Decimal;
        IsRepeatOrder: Boolean;

        TotalWHTAMount: Decimal;
        WHTPercentage: Decimal;
        LineCountR: Integer;

        EmployeeSignature1: Record Employee;
        EmployeeSignature2: Record Employee;
        EmployeeSignature3: Record Employee;


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