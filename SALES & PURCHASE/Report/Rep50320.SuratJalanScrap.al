report 50320 "Surat Jalan (Scrap)"
{
    Caption = 'Surat Jalan (Scrap)';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/Surat Jalan Scrap.rdlc';
    ApplicationArea = Basic, Suite;
    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(PreparedBy; "Prepared By Name") { }
            column(CheckBy; "Checked By Name") { }
            column(WarehouseBy; "Warehouse Person Name") { }
            column(Location_Code; "Location Code") { }
            column(TotalLineAmount; TotalLineAmount) { }
            column(userID; UserId) { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2> <Month Text> <Year4>')) { }
            column(Posting_Datev1; Format("Posting Date", 0, '<Day,2>-<Month Text,3>-<Year4>')) { }
            column(WorkDate; Format(WorkDate(), 0, '<Day,2> <Month Text> <Year4>')) { }
            column(LogoCompany; CompanyInfo.Picture) { }
            column(External_Document_No_; "External Document No.") { }
            column(Trucking_No_; "Trucking No.")
            {

            }
            column(ReportType; ReportType)
            {

            }
            column(BilltoAddress; "Sales Shipment Header"."Bill-to Address" + ' ' + "Sales Shipment Header"."Bill-to Address 2") { }
            column(BilltoContact; "Sales Shipment Header"."Sell-to Contact") { }
            column(CustomerName; "Sales Shipment Header"."Sell-to Customer Name") { }
            column(BillTelpNo; "Sales Shipment Header"."Sell-to Phone No.") { }
            column(customerPostingGroup; "Sales Shipment Header"."Customer Posting Group") { }
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Shipment Header";
                column(PartNo; Item."Common Item No.") { }
                column(LineCount1; Format(LineCount)) { }
                column(LineCount; leadingByZero(Format(LineCount))) { }
                column(ItemNo_; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(UnitPacking; Format(vqtyPacking) + ' ' + vUomPacking) { }
                column(Remars; RemarksLine) { }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    getInfoReport();
                    LineCount += 1;
                    Clear(Item);
                    Item.Reset();
                    Item.SetRange("No.", "Sales Shipment Line"."No.");
                    if Item.Find('-') then;
                end;

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    SetFilter(Quantity, '<>0');
                end;
            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
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
                    field(ReportType; ReportType)
                    {
                        Caption = 'Print for';
                        ApplicationArea = Basic, Suite;
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
        //get list signature
        v_total_amount := 0;
        MaxLine := 8;
        LineCount := 0;
    end;

    local procedure getQtyPacking(iItemNo: Text; iUOMPacking: Text): Decimal
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        v_QtyUnitOfmeasurePacking: Decimal;
    begin
        Clear(ItemUnitOfMeasure);
        Clear(v_QtyUnitOfmeasurePacking);
        ItemUnitOfMeasure.SetRange("Item No.", iItemNo);
        ItemUnitOfMeasure.SetRange(Code, iUOMPacking);
        if ItemUnitOfMeasure.Find('-') then begin
            v_QtyUnitOfmeasurePacking := ItemUnitOfMeasure."Qty. per Unit of Measure";
        end;
        exit(v_QtyUnitOfmeasurePacking);
    end;

    local procedure leadingByZero(iText: Text): Text
    var
        vtext: Text;
    begin
        Clear(vtext);
        vtext := PADSTR('', 3 - strlen(iText), '0') + iText;
        exit(vtext);
    end;

    local procedure getUOMDesc(iCode: Text): Text
    var
        unitOfMeasure: Record "Unit of Measure";
    begin
        Clear(unitOfMeasure);
        if unitOfMeasure.Get(iCode) then begin
            exit(unitOfMeasure.Description);
        end;
        exit('');
    end;

    local procedure getInfoReport()
    var
        salesHeader: Record "Sales Header";
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
    begin
        Clear(salesHeader);
        Clear(CustomerName);
        Clear(customerPostingGroup);
        Clear(BilltoAddress);
        Clear(BilltoContact);
        Clear(BillTelpNo);
        Clear(RemarksLine);
        salesHeader.SetRange("No.", "Sales Shipment Line"."Order No.");
        if salesHeader.Find('-') then begin
            CustomerName := salesHeader."Bill-to Name";
            BilltoContact := salesHeader."Bill-to Contact";
            BilltoAddress := salesHeader."Bill-to Address" + ' ' + salesHeader."Bill-to Address 2";
            BillTelpNo := salesHeader."Sell-to Phone No.";
            if Customer.Get(salesHeader."No.") then begin
                customerPostingGroup := Customer."Customer Posting Group";
            end;
            //get info sales line 
            Clear(SalesLine);
            SalesLine.Reset();
            SalesLine.SetRange("Document No.", "Sales Shipment Line"."Order No.");
            SalesLine.SetRange("Line No.", "Sales Shipment Line"."Order Line No.");
            if SalesLine.Find('-') then begin
                RemarksLine := SalesLine.Remarks;
            end;
        end;
    end;

    var

        customerPostingGroup: Text;
        CustomerName: Text;
        v_total_amount: Decimal;
        TotalAmount: Decimal;
        TotalAmountWithVat: Decimal;
        TotalVatAMount: Decimal;

        BillTelpNo: Text;

        TotalLineAmount: Decimal;

        BilltoAddress: Text;
        BilltoContact: Text;

        TotalWHTAMount: Decimal;
        WHTPercentage: Decimal;

        warehouseMgnt: Codeunit "Warehouse Management";

        //Custom 
        ReportType: enum PrintForSJ;
        ModPage: Integer;
        MaxLine: Integer;
        RunningNo: Integer;
        LineCount: Integer;
        CompanyInfo: Record "Company Information";
        customer: Record Customer;
        generaLedgerSetup: Record "General Ledger Setup";
        TexNO: Text[250];
        paymentterms: Record "Payment Terms";

        vqtyPacking: Decimal;
        vUomPacking: Text;

        QtyUnitOfmeasurePacking: Decimal;
        Item: Record Item;
        RemarksLine: Text;
}
