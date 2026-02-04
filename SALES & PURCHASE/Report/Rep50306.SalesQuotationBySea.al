report 50306 "Sales Quotation By Sea"
{
    Caption = 'Sales Quotation By Sea';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/SalesQuotationBySea.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "No.";
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(LogoCompany; CompanyInfo.Picture) { }
            column(Customer_No_; "Sell-to Customer No.") { }
            column(FaxNoCustomer; Customer_."Fax No.") { }
            column(TelpNo; Customer_."Phone No.") { }
            column(salespersonname; salesPerson.Name) { }
            column(CustomerAddress; Customer_.Address) { }
            column(CustomerAddress2; Customer_."Address 2") { }
            column(Customer_Name; "Sell-to Customer Name") { }
            column(Sell_to_Contact; "Sell-to Contact") { }
            column(No_; "No.") { }
            column(Status; (Status = Status::Released)) { }
            column(External_Document_No_; "External Document No.") { }
            column(Currency_Code; "Currency Code") { }
            column(Document_Date; Format("Document Date", 0, '<Day,2> <Month Text,3> <Year4>')) { }
            column(Order_Date; Format("Order Date", 0, '<Day,2> <Month Text,3> <Year4>')) { }
            column(paymentTerm; paymentTerm.Description) { }
            column(Bill_to_Address; "Bill-to Address" + ' ' + "Bill-to Address 2") { }
            column(Work_Description; GetWorkDescription()) { }

            column(Delivery_To; "Delivery To") { }
            column(Delivery_Date; "Delivery Date") { }
            column(Price_Component; "Price Component") { }
            column(Term_By; "Term By") { }
            column(Term_Payment; "Term Payment") { }
            column(Validity_Date; "Validity Date") { }
            column(Additional_Notes; "Additional Notes") { }
            column(CheckItemReference; CheckItemReference) { }
            column(prepareName; getPrepareName("Salesperson Code")) { }
            column(CheckedBy; getFullNameEmp("Checked By")) { }
            column(ApprovedBy; getFullNameEmp("Approved By")) { }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Header";
                column(ItemNo_; "No.") { }
                column(Item_Reference_No_; "Item Reference No.") { }
                column(LineCount; Format(LineCount)) { }
                column(LineCount_f1; leadingByZero(Format(LineCount))) { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Part_Number; "Part Number") { }
                column(Part_Name; "Part Name") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Line_Amount; "Line Amount") { }
                column(Location_Code; "Location Code") { }
                column(Unit_Cost__LCY_; "Unit Cost (LCY)") { }
                column(Unit_Price; "Unit Price") { }
                column(OrignalSymbol; getSymbolCurrency("Sales Header"."Currency Code")) { }
                column(IDRSymbol; getSymbolCurrency('IDR')) { }
                column(Remarks; Remarks)
                {

                }
                column(HoneyComDiameter; getItemAttribute(SalesReceiveSetup."Honey Comb Diameter")) { }
                column(HoneyComLength; getItemAttribute(SalesReceiveSetup."Honey Comb Length")) { }
                column(HoneyCombThickness; getItemAttribute(SalesReceiveSetup."Honey Comb Thickness")) { }
                column(CPSI; getItemAttribute(SalesReceiveSetup.CPSI)) { }
                column(ManiteDiameter; getItemAttribute(SalesReceiveSetup."Mantle Diameter")) { }
                column(ManiteLength; getItemAttribute(SalesReceiveSetup."Mantle Length")) { }
                column(StandardHI; getItemAttribute(SalesReceiveSetup."Spec Standard/HI")) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    LineCount += 1;
                    if "Sales Line"."Item Reference No." = '' then
                        CheckItemReference := false;
                end;
            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                CheckItemReference := true;
                Clear(Customer_);
                Customer_.Reset();
                Customer_.SetRange("No.", "Sales Header"."Sell-to Customer No.");
                if Customer_.Find('-') then;

                Clear(salesPerson);
                salesPerson.Reset();
                salesPerson.SetRange(Code, "Sales Header"."Salesperson Code");
                if salesPerson.Find('-') then;

                generaLedgerSetup.Get();
                if "Sales Header"."Currency Code" = '' then
                    "Sales Header"."Currency Code" := generaLedgerSetup."LCY Code";

                Clear(paymentTerm);
                paymentTerm.Reset();
                paymentTerm.SetRange(Code, "Sales Header"."Payment Terms Code");
                if paymentTerm.Find('-') then;

            end;
        }
    }

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        Clear(SalesReceiveSetup);
        SalesReceiveSetup.Get();
    end;

    local procedure getExchangeRate(): Decimal
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CalculatedExchRate: Decimal;
    begin
        CalculatedExchRate := 0;
        if ("Sales Header"."Currency Code" <> '') AND ("Sales Header"."Currency Code" <> generaLedgerSetup."LCY Code") then begin
            CurrencyExchangeRate.FindCurrency("Sales Header"."Posting Date", "Sales Header"."Currency Code", 1);
            CalculatedExchRate :=
              Round(1 / "Sales Header"."Currency Factor" * CurrencyExchangeRate."Exchange Rate Amount", 0.000001);
        end;
        exit(CalculatedExchRate);
    end;

    local procedure getPrepareName(iSalesPersonCode: Code[20]): Text
    var
        salesPersonCode: Record "Salesperson/Purchaser";
    begin
        Clear(salesPersonCode);
        salesPersonCode.SetRange(Code, iSalesPersonCode);
        if salesPersonCode.Find('-') then
            exit(salesPersonCode.Name);
        exit('');
    end;

    local procedure getFullNameEmp(iEmpCode: Code[20]): Text
    var
        employee: Record Employee;
    begin
        Clear(employee);
        if employee.Get(iEmpCode) then begin
            exit(employee.FullName());
        end;
        exit('');
    end;

    local procedure getItemAttribute(iAttrName: Text): Text
    var
        ItemAttr: Record "Item Attribute";
        ItemAttrValueMap: Record "Item Attribute Value Mapping";
        ItemAttrValue: Record "Item Attribute Value";
    begin
        Clear(ItemAttr);
        ItemAttr.Reset();
        ItemAttr.SetRange(Name, iAttrName);
        if ItemAttr.Find('-') then begin
            Clear(ItemAttrValueMap);
            ItemAttrValueMap.Reset();
            ItemAttrValueMap.SetRange("No.", "Sales Line"."No.");
            ItemAttrValueMap.SetRange("Item Attribute ID", ItemAttr.ID);
            if ItemAttrValueMap.Find('-') then begin
                Clear(ItemAttrValue);
                ItemAttrValue.Reset();
                ItemAttrValue.SetRange("Attribute ID", ItemAttrValueMap."Item Attribute ID");
                ItemAttrValue.SetRange(ID, ItemAttrValueMap."Item Attribute Value ID");
                if ItemAttrValue.Find('-') then begin
                    exit(ItemAttrValue.Value);
                end;
            end;
        end;
        exit('');
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

    local procedure leadingByZero(iText: Text): Text
    var
        vtext: Text;
    begin
        Clear(vtext);
        vtext := PADSTR('', 3 - strlen(iText), '0') + iText;
        exit(vtext);
    end;

    var
        CheckItemReference: Boolean;
        CompanyInfo: Record "Company Information";
        Customer_: Record Customer;
        generaLedgerSetup: Record "General Ledger Setup";
        salesPerson: Record "Salesperson/Purchaser";
        paymentTerm: Record "Payment Terms";
        ModPage: Integer;
        MaxLine: Integer;
        RunningNo: Integer;
        LineCount: Integer;

        SalesReceiveSetup: Record "Sales & Receivables Setup";

        ReadingDataSkippedMsg: Label 'Loading field %1 will be skipped because there was an error when reading the data.\To fix the current data, contact your administrator.\Alternatively, you can overwrite the current data by entering data in the field.', Comment = '%1=field caption';

}
