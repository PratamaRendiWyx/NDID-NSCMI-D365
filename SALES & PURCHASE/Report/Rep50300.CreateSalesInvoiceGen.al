report 50300 "Create Sales Invoice Gen."
{
    Caption = 'Create Sales Invoice';
    Permissions = TableData "Sales Header" = i;
    ProcessingOnly = true;

    dataset
    {
        dataitem(CreateNew; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                //Action Here
                createNewSalesOrder();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    ShowCaption = false;

                    field(CustomerNo; v_CustomerNo)
                    {
                        Caption = 'Customer No.';
                        ApplicationArea = All;
                        TableRelation = Customer."No.";
                        ShowMandatory = true;
                        trigger OnValidate()
                        var
                            myInt: Integer;
                            Customer: Record Customer;
                        begin
                            if Customer.Get(v_CustomerNo) then
                                v_customerName := Customer.Name;
                        end;
                    }
                    field(CustomerName; v_customerName)
                    {
                        Caption = 'Customer Name';
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field(v_salestype; v_salestype)
                    {
                        Caption = 'Sales Type Type';
                        ApplicationArea = All;
                        trigger OnValidate()
                        var
                            myInt: Integer;
                            ReceivableSalesSetup: Record "Sales & Receivables Setup";
                            vSalesNos: Text;
                        begin
                            if ReceivableSalesSetup.Get() then begin
                                case v_salestype of
                                    v_salestype::Domestic:
                                        begin
                                            vSalesNos := ReceivableSalesSetup."Invoice Nos.";
                                        end;
                                    v_salestype::Export:
                                        begin
                                            vSalesNos := ReceivableSalesSetup."Invoice Nos. (Export)";
                                        end;
                                    v_salestype::Others:
                                        begin
                                            vSalesNos := ReceivableSalesSetup."Invoice Nos. (Others)";
                                        end;
                                end;
                                //Check sales nos
                                if vSalesNos = '' then
                                    Error('Please setup No. Series for sales invoice [Sales Type : %1]', Format(v_salestype));
                            end;
                        end;
                    }
                    field(vManualNos; vManualNos)
                    {
                        Caption = 'Manual Nos.';
                        ApplicationArea = All;
                        // Visible = false;
                    }
                    field(vNo; vNo)
                    {
                        Caption = 'No.';
                        // Visible = false;
                        ApplicationArea = All;
                        Enabled = vManualNos;
                    }

                }
            }

        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    local procedure createNewSalesOrder()
    var
        Text001: Label 'Are you sure want to create new Sales Invoice ?';
        SalesOrderPage: Page "Sales Invoice";
        SalesHeader: Record "Sales Header";
        vSalesNo: Code[20];
        ReceivableSalesSetup: Record "Sales & Receivables Setup";
        vSalesNos: Text;
        Customer: Record Customer;
    begin
        if Confirm(Text001) then begin
            Clear(vSalesNo);
            if v_CustomerNo = '' then
                Error('Please fill out the customer no.');
            //Manual No. Series
            if vManualNos then begin
                if vNo = '' then
                    Error('Please fill out the No.');
                vSalesNo := vNo;
            end else begin
                Clear(NoSeriesMgt);
                if ReceivableSalesSetup.Get() then begin
                    case v_salestype of
                        v_salestype::Domestic:
                            begin
                                vSalesNos := ReceivableSalesSetup."Invoice Nos.";
                            end;
                        v_salestype::Export:
                            begin
                                vSalesNos := ReceivableSalesSetup."Invoice Nos. (Export)";
                            end;
                        v_salestype::Others:
                            begin
                                vSalesNos := ReceivableSalesSetup."Invoice Nos. (Others)";
                            end;
                    end;
                    //Check sales nos
                    if vSalesNos = '' then
                        Error('Please setup No. Series for sales invoice [Sales Type : %1]', Format(v_salestype));
                    //Generate Sales Invoice No.
                    vSalesNo := NoSeriesMgt.GetNextNo(vSalesNos, WorkDate(), true);
                    //-
                end;
            end;
            //-
            Clear(SalesHeader);
            SalesHeader.Reset();
            SalesHeader.Init();
            SalesHeader."No." := vSalesNo;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            SalesHeader."Sales Type" := v_salestype;
            SalesHeader."Sell-to Customer No." := v_CustomerNo;
            SalesHeader.Validate("Sell-to Customer No.");
            SalesHeader."Document Date" := WorkDate();
            SalesHeader."Posting Date" := SalesHeader."Document Date";
            SalesHeader."Posting No." := vSalesNo;
            SalesHeader.Validate("Posting Date");

            Clear(Customer);
            Customer.Reset();
            Customer.SetRange("No.", v_CustomerNo);
            if Customer.Find('-') then
                SalesHeader."Company Bank Account Code" := Customer."Receiving Bank Account";

            if SalesHeader.Insert() then begin
                //Open New Record 
                Clear(SalesOrderPage);
                SalesOrderPage.SetRecord(SalesHeader);
                SalesOrderPage.Run();
            end;
        end;
    end;

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        CurrReport.UseRequestPage(true);
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        v_CustomerNo: Code[20];
        v_customerName: Text[100];
        v_jobtaskDescription: Text[100];
        v_salestype: Enum "Sales Type";
        vManualNos: Boolean;
        vNo: Code[20];
}
