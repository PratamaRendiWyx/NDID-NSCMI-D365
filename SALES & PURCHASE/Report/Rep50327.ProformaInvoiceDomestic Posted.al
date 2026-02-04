report 50327 "Proforma Inv. Domstc (Posted)"
{
    Caption = 'Proforma Invoice (Domestic)';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/ProformaInvoiceDomesticPosted.rdlc';

    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Vatlabel; findVATPercentageLabel()) { }
            column(ShowDPPLain; ShowDPPLain) { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address" + ' ' + "Bill-to Address 2") { }
            column(LogoCompany; CompanyInfo.Picture) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(Branch; BankAccount.Branch) { }
            column(Delivery_By; UpperCase(Format("Delivery By"))) { }
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
            column(Status; (true)) { }
            column(FOB; FOB) { }
            column(Freight; Freight) { }
            column(CIF; CIF) { }
            column(Contract_No_; "Contract No.") { }
            column(External_Document_No_; "External Document No.") { }
            column(Currency_Code; "Currency Code") { }
            column(Order_Date; Format("Order Date", 0, '<Day,2> <Month Text,3> <Year4>')) { }
            column(Document_Date; Format("Posting Date", 0, '<Day,2> <Month Text,3> <Year4>')) { }
            column(paymentTerm; paymentTerm.Description) { }
            column(paymentTermDays; paymentTerm."Day Number") { }
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
            column(glbShipmentNo; getInfoShipmentNo) { }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Invoice Header";
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
                column(OrignalSymbol; getSymbolCurrency("Sales Invoice Header"."Currency Code")) { }
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

                    if "Sales Invoice Line".Type IN ["Sales Invoice Line".Type::Item, "Sales Invoice Line".Type::"Fixed Asset"] then begin
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
                Customer_.SetRange("No.", "Sales Invoice Header"."Sell-to Customer No.");
                if Customer_.Find('-') then;

                Clear(salesPerson);
                salesPerson.Reset();
                salesPerson.SetRange(Code, "Sales Invoice Header"."Salesperson Code");
                if salesPerson.Find('-') then;

                //calculate amount
                calculateAmount("No.");

                generaLedgerSetup.Get();
                if "Sales Invoice Header"."Currency Code" = '' then
                    "Sales Invoice Header"."Currency Code" := generaLedgerSetup."LCY Code";

                Clear(paymentTerm);
                paymentTerm.Reset();
                paymentTerm.SetRange(Code, "Sales Invoice Header"."Payment Terms Code");
                if paymentTerm.Find('-') then;

                Clear(ShipptoAddress);
                ShipptoAddress.Reset();
                ShipptoAddress.SetRange(Code, "Ship-to Code");
                if ShipptoAddress.Find('-') then;

                Clear(BankAccount);
                BankAccount.Reset();
                BankAccount.SetRange("No.", "Sales Invoice Header"."Company Bank Account Code");
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
        Clear(glbShipmentNo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        SalesReceivaibleSetup.Get();
        ShowDPPLain := true;
    end;

    local procedure getInfoShipmentNo(): Text
    var
        salesInvoiceLine: Record "Sales Invoice Line";
        shipmentNoList: Text;
        curDat: Text;
        TempDat: Text;
    begin
        Clear(shipmentNoList);
        salesInvoiceLine.Reset();
        salesInvoiceLine.SetRange("Document No.", "Sales Invoice Header"."No.");
        salesInvoiceLine.SetFilter("Shipment No.", '<>''''');
        if salesInvoiceLine.FindSet() then begin
            Clear(TempDat);
            Clear(curDat);
            repeat
                curDat := salesInvoiceLine."Shipment No.";
                if curDat <> TempDat then begin
                    if shipmentNoList = '' then
                        shipmentNoList := salesInvoiceLine."Shipment No."
                    else begin
                        shipmentNoList += ',' + salesInvoiceLine."Shipment No."
                    end;
                end;
                TempDat := curDat;
            until salesInvoiceLine.Next() = 0;
        end;
        exit(shipmentNoList);
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

    local procedure conditionInfoShipto(iShiptoCode: Code[10]; iValueA: Text; iValueB: Text): Text
    begin
        if iShiptoCode <> '' then
            exit(iValueA)
        else
            exit(iValueB)
    end;

    local procedure getPackageListNo(): Text;
    var
        salesLine: Record "Sales Invoice Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        tempDat: Text;
        currDat: Text;
        Counter: Integer;
        CountDat: Integer;
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
    begin
        Counter := 1;
        Clear(PalletData);
        Clear(salesLine);
        salesLine.Reset();
        salesLine.SetRange("Document No.", "Sales Invoice Header"."No.");
        salesLine.SetRange(Type, salesLine.Type::Item);
        CountDat := salesLine.Count();
        if salesLine.FindSet() then begin
            Clear(tempDat);
            Clear(currDat);
            repeat
                //collect & sort 
                TempItemLedgerEntry.Init();
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetRange("Document No.", salesLine."Shipment No.");
                ItemLedgerEntry.SetRange("Document Line No.", salesLine."Shipment Line No.");
                ItemLedgerEntry.SetRange("Item No.", salesLine."No.");
                ItemLedgerEntry.SetCurrentKey("Item No.", "Package No.", "Document Line No.");
                ItemLedgerEntry.SetAscending("Package No.", true);
                if ItemLedgerEntry.FindSet() then begin
                    repeat
                        TempItemLedgerEntry.TransferFields(ItemLedgerEntry);
                        if TempItemLedgerEntry."Package No." <> '' then
                            TempItemLedgerEntry."Package No." := '0' + ItemLedgerEntry."Package No.";
                        TempItemLedgerEntry.Insert();
                    until ItemLedgerEntry.Next() = 0;
                end;

                //find collect
                if TempItemLedgerEntry.FindSet() then begin
                    repeat
                        TempItemLedgerEntry."Package No." := DELCHR(TempItemLedgerEntry."Package No.", '<', '0');
                        currDat := TempItemLedgerEntry."Package No.";
                        if tempDat <> currDat then begin
                            if PalletData = '' then
                                PalletData := TempItemLedgerEntry."Package No."
                            else begin
                                PalletData += '|' + TempItemLedgerEntry."Package No.";
                            end;
                        end;
                        tempDat := currDat;
                    until TempItemLedgerEntry.Next() = 0;
                end;
                if Counter <> CountDat then begin
                    if PalletData <> '' then
                        PalletData += '#';
                end;
                Counter += 1;

                //Clear & Reset
                TempItemLedgerEntry.DeleteAll();
            until salesLine.Next() = 0;
        end;
        exit(PalletData);
    end;

    local procedure findVATPercentageLabel(): Text
    var
        SalesLine: Record "Sales Invoice Line";
    begin
        Clear(SalesLine);
        SalesLine.Reset();
        SalesLine.SetRange("Document No.", "Sales Invoice Header"."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetCurrentKey("Document No.", "VAT %");
        SalesLine.SetAscending("VAT %", false);
        if SalesLine.FindSet() then begin
            exit(format(SalesLine."VAT %") + '%');
        end;

        exit('');
    end;

    local procedure getItemReferenceDesc(): Text
    var
        itemReference: Record "Item Reference";
    begin
        Clear(itemReference);
        itemReference.SetRange("Item No.", "Sales Invoice Line"."No.");
        itemReference.SetRange("Reference No.", "Sales Invoice Line"."Item Reference No.");
        if itemReference.Find('-') then
            exit(itemReference.Description);
        exit('');
    end;

    local procedure calculateAmount(iNoPostesSales: Text)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
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
        if "Sales Invoice Header"."Currency Code" = '' then
            "Sales Invoice Header"."Currency Code" := generaLedgerSetup."LCY Code";
        if "Sales Invoice Header"."Currency Code" = 'IDR' then
            exit(1);
        if "Sales Invoice Header"."Currency Code" <> '' then begin
            CurrencyExchangeRate.FindCurrency("Sales Invoice Header"."Posting Date", 'IDR', 1);
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
        commentLine.SetRange("No.", "Sales Invoice Header"."No.");
        commentLine.SetRange("Document Type", commentLine."Document Type"::"Posted Invoice");
        commentLine.SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
        if commentLine.FindFirst() then
            exit(commentLine.Comment);
        exit('');
    end;

    var
        glbShipmentNo: Text;
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
