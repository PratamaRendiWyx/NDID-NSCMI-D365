report 50500 "Packing Shipment"
{
    Caption = 'Delivery Order';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/PackingList.rdlc';
    ApplicationArea = Basic, Suite;
    dataset
    {
        dataitem("Pack. Header"; "Pack. Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Location_Code; "Location Code") { }
            column(TotalLineAmount; TotalLineAmount) { }
            column(userID; UserId) { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2> <Month Text> <Year4>')) { }
            column(Posting_Datev1; Format("Posting Date", 0, '<Day,2>-<Month Text,3>-<Year4>')) { }
            column(WorkDate; Format(WorkDate(), 0, '<Day,2> <Month Text> <Year4>')) { }
            column(LogoCompany; CompanyInfo.Picture) { }
            column(External_Document_No_; "External Document No.") { }
            column(Consignee_Name; "Consignee Name") { }
            column(Consignee_Address; "Consignee Address" + ' ' + "Consignee Address2") { }
            column(Consignee_Address2; "Consignee Address2") { }
            column(Consignee_Phone; "Consignee Phone") { }
            column(Consignee_Phone2; "Consignee Phone2") { }
            column(Port_of_Discharge; "Port of Discharge") { }
            column(Port_of_Loading; "Port of Loading") { }
            column(ETA; Format(ETA, 0, '<Day,2>-<Month Text,3>-<Year>')) { }
            column(ETD; Format(ETD, 0, '<Day,2>-<Month Text,3>-<Year>')) { }
            column(Name_of_Vessel; "Name of Vessel") { }
            column(Invoice; Invoice) { }
            column(Country_of_Origin; "Country of Origin") { }
            column(Terms; Terms) { }
            column(PO_No_; "PO No.") { }
            column(Delivery_Type; format("Delivery Type")) { }

            dataitem("Pack. Lines"; "Pack. Lines")
            {
                DataItemLink = "No." = field("No.");
                DataItemLinkReference = "Pack. Header";
                column(Package_No_; "Package No.")
                {

                }
                column(BilltoAddress; BilltoAddress) { }
                column(PartNo; Item."Common Item No.") { }
                column(LineCount; Format(LineCount)) { }
                column(BilltoContact; BilltoContact) { }
                column(CustomerName; CustomerName) { }
                column(BillTelpNo; BillTelpNo) { }
                column(customerPostingGroup; customerPostingGroup) { }
                column(LineCount1; leadingByZero(Format(LineCount))) { }
                column(ItemNo_; "No.") { }
                column(Description; Description) { }
                column(Nett_Weight; Item."Net Weight" * "Qty to Handle") { }
                column(Gross_Weight; Item."Gross Weight" * "Qty to Handle") { }
                column(Measurement; Measurement) { }
                column(Quantity; "Qty to Handle") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(UnitPacking; Format(vqtyPacking) + ' ' + vUomPacking) { }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    getInfoReport();
                    LineCount += 1;
                    Clear(Item);
                    Item.Reset();
                    Item.SetRange("No.", "Pack. Lines"."Item No.");
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
        Clear(RemarksLine);
        salesHeader.SetRange("No.", "Pack. Lines"."Source No.");
        if salesHeader.Find('-') then begin
            CustomerName := salesHeader."Bill-to Name";
            BilltoContact := salesHeader."Bill-to Contact";
            BilltoAddress := salesHeader."Bill-to Address" + ' ' + salesHeader."Bill-to Address 2";
            BillTelpNo := salesHeader."Sell-to Phone No.";
            if Customer.Get(salesHeader."No.") then begin
                customerPostingGroup := Customer."Customer Posting Group";
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
