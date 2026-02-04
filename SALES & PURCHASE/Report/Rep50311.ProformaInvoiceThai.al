report 50311 "Proforma Invoice Thai"
{
    Caption = 'Proforma Invoice (Thai)';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/ProformaInvoiceThai.rdlc';

    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "No.";
            column(Vatlabel; findVATPercentageLabel()) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(ShowDPPLain; ShowDPPLain) { }
            column(Branch; BankAccount.Branch) { }
            column(Delivery_By; UpperCase(Format("Delivery By"))) { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address" + ' ' + "Bill-to Address 2") { }
            column(LogoCompany; CompanyInfo.Picture) { }
            column(Customer_No_; "Sell-to Customer No.") { }
            column(FaxNoCustomer; Customer_."Fax No.") { }
            column(TelpNo; Customer_."Phone No.") { }
            column(salespersonname; salesPerson.Name) { }
            column(CustomerAddress; Customer_.Address + ' ' + Customer_."Address 2") { }
            column(CustomerAddress2; Customer_."Address 2") { }
            column(Customer_Name; "Sell-to Customer Name") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address" + ' ' + "Ship-to Address 2") { }
            column(Sell_to_Contact; "Sell-to Contact") { }
            column(No_; "No.") { }
            column(Status; (Status = Status::Released)) { }
            column(checkRemarks; checkRemarks(FOB, CIF, Freight)) { }
            column(FOB; FOB) { }
            column(Freight; Freight) { }
            column(CIF; CIF) { }
            column(Contract_No_; "Contract No.") { }
            column(External_Document_No_; "External Document No.") { }
            column(Currency_Code; "Currency Code") { }
            column(Order_Date; Format("Order Date", 0, '<Day,2> <Month Text,3> <Year4>')) { }
            column(Document_Date; Format("Posting Date", 0, '<Day,2> <Month Text,3> <Year4>')) { }
            column(paymentTerm; paymentTerm.Description) { }
            column(ShipptoAddressPhone; conditionInfoShipto("Ship-to Code", ShipptoAddress."Phone No.", Customer_."Phone No.")) { }
            column(ShipptoAddressFax; conditionInfoShipto("Ship-to Code", ShipptoAddress."Fax No.", Customer_."Fax No.")) { }
            column(Shipment_Method_Code; shipmentDesc("Shipment Method Code"))
            {

            }
            column(TotalAmount; TotalAmount) { }
            column(TotalAmountWithVat; TotalAmountWithVat) { }
            column(TotalVatAMount; TotalVatAMount) { }
            column(TotalLineAmountDisc; TotalLineAmountDisc) { }
            column(Quote_No_; "Quote No.")
            {

            }
            column(TotalLineAmount; TotalLineAmount) { }
            column(Due_Date; Format("Due Date", 0, '<Day,2> <Month Text,3> <Year4>')) { }
            column(BankAccount; BankAccount."Name 2") { }
            column(BankAccountName; BankAccount.Name) { }
            column(BankAddress; BankAccount.Address + ' ' + BankAccount."Address 2") { }
            column(BankAccountBranch; BankAccount."Bank Branch No.") { }
            column(BankAccountNo; BankAccount."Bank Account No.") { }
            column(BankAccountSwift; BankAccount."SWIFT Code") { }
            column(Packing_No_; "Packing No.") { }
            column(HS_Code; SalesReceivaibleSetup."HS Code") { }
            column(USCI_NO; SalesReceivaibleSetup."USCI No") { }
            column(ListPackage; getPackageListNo()) { }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Header";
                column(printForInvoice; format(printForInvoice)) { }
                column(Description; Description) { }
                column(LineCount; Format(LineCount)) { }
                column(ItemNo_; "No.") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Orig_Line_Amount; "Line Amount") { }
                column(Unit_Cost__LCY_; "Unit Cost (LCY)") { }
                column(Unit_Price; "Unit Price") { }
                column(Part_Number; "Part Number") { }
                column(Item_Reference_No_; "Item Reference No.") { }
                column(Item_Reference_Desc_; getItemReferenceDesc()) { }
                column(Part_Name; "Part Name") { }
                //column(PriceinIDR; (getExchangeRate() * "Unit Price")) { }
                column(OrignalSymbol; getSymbolCurrency("Sales Header"."Currency Code")) { }
                column(IDRSymbol; getSymbolCurrency('IDR')) { }
                column(Net_Weight; "Net Weight") { }
                column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code") { }
                column(getCommentLine; getCommentLine()) { }
                column(Quantity; Quantity) { }
                column(Line_Amount; "Line Amount") { }
                column(Shipment_No_; "Shipment No.") { }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    Clear(ItemVariants);
                    ItemVariants.Reset();
                    ItemVariants.SetRange("Item No.", "No.");
                    ItemVariants.SetRange(Code, "Variant Code");
                    if ItemVariants.Find('-') then;

                    if "Sales Line".Type = "Sales Line".Type::Item then begin
                        LineCount += 1;
                    end else begin
                        CurrReport.Skip();
                    end;
                end;

            }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                Clear(Customer_);
                Customer_.Reset();
                Customer_.SetRange("No.", "Sales Header"."Sell-to Customer No.");
                if Customer_.Find('-') then;

                Clear(salesPerson);
                salesPerson.Reset();
                salesPerson.SetRange(Code, "Sales Header"."Salesperson Code");
                if salesPerson.Find('-') then;

                //calculate amount
                calculateAmount("No.");

                generaLedgerSetup.Get();
                if "Sales Header"."Currency Code" = '' then
                    "Sales Header"."Currency Code" := generaLedgerSetup."LCY Code";

                Clear(paymentTerm);
                paymentTerm.Reset();
                paymentTerm.SetRange(Code, "Sales Header"."Payment Terms Code");
                if paymentTerm.Find('-') then;

                Clear(ShipptoAddress);
                ShipptoAddress.Reset();
                ShipptoAddress.SetRange(Code, "Ship-to Code");
                if ShipptoAddress.Find('-') then;

                Clear(BankAccount);
                BankAccount.Reset();
                BankAccount.SetRange("No.", "Sales Header"."Company Bank Account Code");
                if BankAccount.Find('-') then;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = 'Options';
                    field(printForInvoice; printForInvoice)
                    {
                        Caption = 'Print for';
                        ApplicationArea = Basic, Suite;
                    }
                    field(ShowDPPLain; ShowDPPLain)
                    {
                        ApplicationArea = All;
                        Caption = 'Show DPP Nilai Lain (?)';
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        SalesReceivaibleSetup.Get();
        ShowDPPLain := true;
    end;

    local procedure shipmentDesc(iCode: Code[20]): Text
    var
        ShipmentMethod: Record "Shipment Method";
    begin
        Clear(ShipmentMethod);
        ShipmentMethod.SetRange(Code, iCode);
        if ShipmentMethod.Find('-') then
            exit(ShipmentMethod.Description);
    end;

    local procedure checkRemarks(iFOB: Decimal; iCIF: Decimal; iFreig: Decimal): Boolean
    var
        iresult: Decimal;
    begin
        iresult := iFOB + iCIF + iFreig;
        if iresult = 0 then
            exit(true);
        exit(false);
    end;

    local procedure getPackageListNo(): Text;
    var
        salesLine: Record "Sales Line";
        reservationEntry: Record "Reservation Entry";
        TempreservationEntry: Record "Reservation Entry" temporary;
        tempDat: Text;
        currDat: Text;
        Counter: Integer;
        CountDat: Integer;
    begin
        Counter := 1;
        Clear(PalletData);
        Clear(salesLine);
        salesLine.Reset();
        salesLine.SetRange("Document No.", "Sales Header"."No.");
        salesLine.SetRange("Document Type", salesLine."Document Type"::Invoice);
        salesLine.SetRange(Type, salesLine.Type::Item);
        CountDat := salesLine.Count();
        if salesLine.FindSet() then begin
            Clear(tempDat);
            Clear(currDat);
            repeat
                //collect & sort
                TempreservationEntry.Init();
                Clear(reservationEntry);
                reservationEntry.SetRange("Source ID", "Sales Line"."Document No.");
                reservationEntry.SetRange("Item No.", salesLine."No.");
                reservationEntry.SetRange("Source Ref. No.", salesLine."Line No.");
                reservationEntry.SetCurrentKey("Package No.");
                reservationEntry.Ascending(true);
                if reservationEntry.FindSet() then begin
                    repeat
                        TempreservationEntry.TransferFields(reservationEntry);
                        if TempreservationEntry."Package No." <> '' then
                            TempreservationEntry."Package No." := '0' + reservationEntry."Package No.";
                        TempreservationEntry.Insert();
                    until reservationEntry.Next() = 0;
                end;

                //find collect
                if TempreservationEntry.FindSet() then begin
                    repeat
                        TempreservationEntry."Package No." := DELCHR(TempreservationEntry."Package No.", '<', '0');
                        currDat := TempreservationEntry."Package No.";
                        if tempDat <> currDat then begin
                            if PalletData = '' then
                                PalletData := TempreservationEntry."Package No."
                            else
                                PalletData += '|' + TempreservationEntry."Package No.";
                        end;
                        tempDat := currDat;
                    until TempreservationEntry.Next() = 0;
                end;
                if Counter <> CountDat then begin
                    if PalletData <> '' then
                        PalletData += '#';
                end;
                Counter += 1;
                //Clear & Reset
                TempreservationEntry.DeleteAll();
            until salesLine.Next() = 0;
        end;
        exit(PalletData);
    end;

    local procedure getItemReferenceDesc(): Text
    var
        itemReference: Record "Item Reference";
    begin
        Clear(itemReference);
        itemReference.SetRange("Item No.", "Sales Line"."No.");
        itemReference.SetRange("Reference No.", "Sales Line"."Item Reference No.");
        if itemReference.Find('-') then
            exit(itemReference.Description);
        exit('');
    end;

    local procedure conditionInfoShipto(iShiptoCode: Code[10]; iValueA: Text; iValueB: Text): Text
    begin
        if iShiptoCode <> '' then
            exit(iValueA)
        else
            exit(iValueB)
    end;

    local procedure calculateAmount(iNoPostesSales: Text)
    var
        SalesInvoiceLine: Record "Sales Line";
    begin
        Clear(SalesInvoiceLine);
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange("Document No.", iNoPostesSales);
        SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);
        if SalesInvoiceLine.FindSet() then begin
            SalesInvoiceLine.CalcSums(Amount, "Amount Including VAT", "Line Amount", "Line Discount Amount");
            TotalAmount := SalesInvoiceLine.Amount;
            TotalAmountWithVat := SalesInvoiceLine."Amount Including VAT";
            TotalVatAMount := TotalAmountWithVat - TotalAmount;
            TotalAmount := TotalAmount + TotalVatAMount;
            TotalLineAmount := SalesInvoiceLine."Line Amount";
            TotalLineAmountDisc := SalesInvoiceLine."Line Discount Amount";
            //WHT 
            // TotalWHTAMount := SalesInvoiceLine."WHT Base Amount";
            TotalAmount := TotalAmount;
        end;
    end;

    local procedure findVATPercentageLabel(): Text
    var
        SalesLine: Record "Sales Line";
    begin
        Clear(SalesLine);
        SalesLine.Reset();
        SalesLine.SetRange("Document No.", "Sales Header"."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetCurrentKey("Document No.", "VAT %");
        SalesLine.SetAscending("VAT %", false);
        if SalesLine.FindSet() then begin
            exit(format(SalesLine."VAT %") + '%');
        end;

        exit('');
    end;

    local procedure checkNollDiv(iDecimal: Decimal; iDiv: Decimal): Decimal
    begin
        if iDiv <> 0 then
            exit(ROUND((Abs(iDecimal) DIV iDiv), 1, '<'))
        else
            exit(0);
    end;

    local procedure getExchangeRate(): Decimal
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CalculatedExchRate: Decimal;
    begin
        CalculatedExchRate := 0;
        if "Sales Header"."Currency Code" = '' then
            "Sales Header"."Currency Code" := generaLedgerSetup."LCY Code";
        if "Sales Header"."Currency Code" = 'IDR' then
            exit(1);
        if "Sales Header"."Currency Code" <> '' then begin
            CurrencyExchangeRate.FindCurrency("Sales Header"."Posting Date", 'IDR', 1);
            CalculatedExchRate := CurrencyExchangeRate."Exchange Rate Amount";
        end;
        exit(CalculatedExchRate);
    end;

    local procedure getSymbolCurrency(iCurrencyCode: Code[10]): Text
    var
        Currency: Record Currency;
        GeneralLedgerSetup: Record "General Ledger Setup";
        CurrSymbol: Code[10];
    begin
        if iCurrencyCode <> '' then begin
            if Currency.Get(iCurrencyCode) then
                CurrSymbol := Currency.GetCurrencySymbol();
        end else
            if GeneralLedgerSetup.Get() then begin
                CurrSymbol := GeneralLedgerSetup.GetCurrencySymbol();
            end;
        exit(CurrSymbol);
    end;

    local procedure getCommentLine(): Text
    var
        commentLine: Record "Sales Comment Line";
    begin
        Clear(commentLine);
        commentLine.Reset();
        commentLine.SetRange("No.", "Sales Header"."No.");
        commentLine.SetRange("Document Type", "Sales Header"."Document Type"::Order);
        commentLine.SetRange("Document Line No.", "Sales Line"."Line No.");
        if commentLine.FindFirst() then
            exit(commentLine.Comment);
        exit('');
    end;

    var
        ShowDPPLain: Boolean;
        PalletData: Text;
        printForInvoice: enum PrintForInvoice;
        CompanyInfo: Record "Company Information";
        Customer_: Record Customer;
        generaLedgerSetup: Record "General Ledger Setup";
        salesPerson: Record "Salesperson/Purchaser";
        paymentTerm: Record "Payment Terms";

        ItemVariants: Record "Item Variant";
        ShipptoAddress: Record "Ship-to Address";
        LineCount: Integer;
        BankAccount: Record "Bank Account";
        TotalAmount: Decimal;
        TotalAmountWithVat: Decimal;
        TotalVatAMount: Decimal;
        TotalLineAmount: Decimal;
        TotalLineAmountDisc: Decimal;

        SalesReceivaibleSetup: Record "Sales & Receivables Setup";
}
