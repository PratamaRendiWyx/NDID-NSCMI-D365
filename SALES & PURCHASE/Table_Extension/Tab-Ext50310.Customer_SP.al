tableextension 50310 Customer_SP extends Customer
{
    fields
    {
        field(50300; "Receiving Bank Account"; COde[29])
        {
            Caption = 'Receiving Bank Account';
            TableRelation = "Bank Account"."No.";
            trigger OnValidate()
            var
                myInt: Integer;
                bankaccount: Record "Bank Account";
            begin
                if "Receiving Bank Account" <> '' then begin
                    Clear(bankaccount);
                    bankaccount.Reset();
                    bankaccount.SetRange("No.", "Receiving Bank Account");
                    if bankaccount.Find('-') then begin
                        "Receiving Bank Name" := bankaccount.Name;
                    end;
                end;
            end;
        }
        field(50301; "Receiving Bank Name"; Text[100])
        {
            Caption = 'Receiving Bank Name';
            Editable = false;
        }
    }

    procedure CalcAvailableCreditCstm(): Decimal
    begin
        exit(CalcAvailableCreditCommonCstm(false));
    end;

    local procedure CalcAvailableCreditCommonCstm(CalledFromUI: Boolean) Result: Decimal
    var
        CreditLimitLCY: Decimal;
        IsHandled: Boolean;
        TotalAmountLCY: Decimal;
    begin
        Clear(TotalAmountLCY);
        CreditLimitLCY := "Credit Limit (LCY)";
        if CreditLimitLCY = 0 then
            exit(0);
        if CalledFromUI then
            exit(CreditLimitLCY - GetTotalAmountLCYUI());
        TotalAmountLCY := GetTotalAmountLCYCstm();
        exit(CreditLimitLCY - TotalAmountLCY);
    end;

    procedure GetTotalAmountLCYCstm() TotalAmountLCY: Decimal
    var
        xSecurityFilter: SecurityFilter;
        IsHandled: Boolean;
    begin
        xSecurityFilter := SecurityFiltering;
        SecurityFiltering(SecurityFiltering::Ignored);
        CalcFields("Balance (LCY)", "Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)", "Outstanding Invoices (LCY)",
          "Outstanding Serv. Orders (LCY)", "Serv Shipped Not Invoiced(LCY)", "Outstanding Serv.Invoices(LCY)");
        if SecurityFiltering <> xSecurityFilter then
            SecurityFiltering(xSecurityFilter);

        exit(GetTotalAmountLCYCommon());
    end;

    local procedure GetTotalAmountLCYCommon(): Decimal
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        SalesLine: Record "Sales Line";
        [SecurityFiltering(SecurityFilter::Filtered)]
        ServiceLine: Record "Service Line";
        SalesOutstandingAmountFromShipment: Decimal;
        ServOutstandingAmountFromShipment: Decimal;
        InvoicedPrepmtAmountLCY: Decimal;
        RetRcdNotInvAmountLCY: Decimal;
        AdditionalAmountLCY: Decimal;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        SalesOutstandingAmountFromShipment := SalesLine.OutstandingInvoiceAmountFromShipment("No.");
        ServOutstandingAmountFromShipment := ServiceLine.OutstandingInvoiceAmountFromShipment("No.");
        InvoicedPrepmtAmountLCY := GetInvoicedPrepmtAmountLCYcstm();
        RetRcdNotInvAmountLCY := GetReturnRcdNotInvAmountLCY();
        //check exclude close
        getOutstandingLCY();
        //-

        exit("Balance (LCY)" + voustandingOrderLCY + vshippedNotInvoicedLCY + "Outstanding Invoices (LCY)" +
          "Outstanding Serv. Orders (LCY)" + "Serv Shipped Not Invoiced(LCY)" + "Outstanding Serv.Invoices(LCY)" -
          SalesOutstandingAmountFromShipment - ServOutstandingAmountFromShipment - InvoicedPrepmtAmountLCY - RetRcdNotInvAmountLCY +
          AdditionalAmountLCY);
    end;

    local procedure getOutstandingLCY()
    var
        salesLine: Record "Sales Line";
        salesHeader: Record "Sales Header";
        customerNo: Code[20];
    begin
        Clear(voustandingOrderLCY);
        Clear(vshippedNotInvoicedLCY);
        Clear(salesHeader);
        salesHeader.Reset();
        salesHeader.SetRange("Bill-to Customer No.", "No.");
        salesHeader.SetRange(IsClose, false);
        salesHeader.SetRange("Document Type", salesHeader."Document Type"::Order);
        if salesHeader.FindSet() then begin
            repeat
                Clear(salesLine);
                salesLine.SetRange("Document No.", salesHeader."No.");
                salesLine.SetRange("Document Type", salesLine."Document Type"::Order);
                if salesLine.FindSet() then begin
                    repeat
                        voustandingOrderLCY += salesLine."Outstanding Amount (LCY)";
                        vshippedNotInvoicedLCY += salesLine."Shipped Not Invoiced (LCY)";
                    until salesLine.Next() = 0;
                end;
            until salesHeader.Next() = 0;
        end;
    end;

    procedure GetInvoicedPrepmtAmountLCYcstm() InvoicedPrepmtAmountLCY: Decimal
    var
        [SecurityFiltering(SecurityFilter::Ignored)]
        SalesLine: Record "Sales Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        SalesLine.ReadIsolation := IsolationLevel::ReadUncommitted;
        SalesLine.SetCurrentKey("Document Type", "Bill-to Customer No.");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Bill-to Customer No.", "No.");
        SalesLine.SetRange("Is Closed", false);
        SalesLine.CalcSums("Prepmt. Amount Inv. (LCY)", "Prepmt. VAT Amount Inv. (LCY)");
        exit(SalesLine."Prepmt. Amount Inv. (LCY)" + SalesLine."Prepmt. VAT Amount Inv. (LCY)");
    end;

    var
        voustandingOrderLCY: Decimal;
        vshippedNotInvoicedLCY: Decimal;
}
