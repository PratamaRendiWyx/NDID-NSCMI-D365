report 50303 "Sales Order"
{
    Caption = 'Sales Order';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/SalesOrder.rdlc';
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

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Header";
                column(ItemNo_; "No.") { }
                column(LineCount; Format(LineCount)) { }
                column(LineCount_f1; leadingByZero(Format(LineCount))) { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Part_Number; "Part Number") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Line_Amount; "Line Amount") { }
                column(Location_Code; "Location Code") { }
                column(Unit_Cost__LCY_; "Unit Cost (LCY)") { }
                column(Unit_Price; "Unit Price") { }
                column(OrignalSymbol; getSymbolCurrency("Sales Header"."Currency Code")) { }
                column(IDRSymbol; getSymbolCurrency('IDR')) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    if Type = Type::Item then
                        LineCount += 1;
                end;
            }

            /*dataitem("Integer"; "Integer")
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
            */

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
        MaxLine := 27;
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
        CompanyInfo: Record "Company Information";
        Customer_: Record Customer;
        generaLedgerSetup: Record "General Ledger Setup";
        salesPerson: Record "Salesperson/Purchaser";
        paymentTerm: Record "Payment Terms";
        ModPage: Integer;
        MaxLine: Integer;
        RunningNo: Integer;
        LineCount: Integer;

        ReadingDataSkippedMsg: Label 'Loading field %1 will be skipped because there was an error when reading the data.\To fix the current data, contact your administrator.\Alternatively, you can overwrite the current data by entering data in the field.', Comment = '%1=field caption';


}
