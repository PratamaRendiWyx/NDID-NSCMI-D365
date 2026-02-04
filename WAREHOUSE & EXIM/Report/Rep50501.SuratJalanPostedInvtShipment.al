report 50501 "Surat Jalan (Invt. ship)"
{
    Caption = 'Surat Jalan (Posted Invt. Ship)';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/Surat Jalan Invt Ship.rdlc';
    ApplicationArea = Basic, Suite;
    dataset
    {
        dataitem("Invt. Shipment Header"; "Invt. Shipment Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Location_Code; "Location Code") { }
            column(TotalLineAmount; TotalLineAmount) { }
            column(userID; UserId) { }
            column(Remarks; Remarks) { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2> <Month Text> <Year4>')) { }
            column(Posting_Datev1; Format("Posting Date", 0, '<Day,2>-<Month Text,3>-<Year4>')) { }
            column(WorkDate; Format(WorkDate(), 0, '<Day,2> <Month Text> <Year4>')) { }
            column(LogoCompany; CompanyInfo.Picture) { }
            column(External_Document_No_; "External Document No.") { }
            column(Checked_By_Name; "Checked By Name") { }
            column(Prepared_By_Name; "Prepared By Name") { }
            column(Warehouse_Person_Name; "Warehouse Person Name") { }
            dataitem("Invt. Shipment Line"; "Invt. Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Invt. Shipment Header";
                column(BilltoAddress; BilltoAddress) { }
                column(PartNo; Item."Common Item No.") { }
                column(LineCount1; Format(LineCount)) { }
                column(BilltoContact; BilltoContact) { }
                column(CustomerName; CustomerName) { }
                column(BillTelpNo; BillTelpNo) { }
                column(customerPostingGroup; customerPostingGroup) { }
                column(LineCount; leadingByZero(Format(LineCount))) { }
                column(ItemNo_; "Item No.") { }
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
                    Item.SetRange("No.", "Invt. Shipment Line"."Item No.");
                    if Item.Find('-') then;
                end;
            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
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
        if "Invt. Shipment Header"."External Document No." <> '' then begin
            Clear(RemarksLine);
            salesHeader.SetRange("No.", "Invt. Shipment Header"."External Document No.");
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
                // SalesLine.SetRange("Document No.", "Invt. Shipment Line"."Order No.");
                // SalesLine.SetRange("Line No.", "Invt. Shipment Line"."Order Line No.");
                if SalesLine.Find('-') then begin
                    RemarksLine := ''//SalesLine.Remarks;
                end;
            end;
        end else begin
            if "Invt. Shipment Header"."Vendor No." <> '' then begin
                Clear(Vendor);
                Vendor.Reset();
                Vendor.SetRange("No.", "Invt. Shipment Header"."Vendor No.");
                if Vendor.Find('-') then begin
                    CustomerName := "Invt. Shipment Header"."Vendor Name";
                    BilltoContact := Vendor.Contact;
                    BilltoAddress := Vendor.Address + ' ' + vendor."Address 2";
                    BillTelpNo := Vendor."Phone No.";
                    customerPostingGroup := Vendor."Vendor Posting Group";
                end;
            end;
        end;
    end;

    var
        Vendor: Record Vendor;

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

        //Custom 
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
