report 50318 "Delivery Packing List"
{
    Caption = 'Delivery Packing List';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/Delivery Packing List.rdlc';
    ApplicationArea = Basic, Suite;
    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Location_Code; "Location Code") { }
            column(TotalLineAmount; TotalLineAmount) { }
            column(userID; UserId) { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2> <Month Text> <Year4>')) { }
            column(Shipment_Date; Format("Shipment Date", 0, '<Day,2> <Month Text> <Year4>')) { }
            column(Posting_Datev1; Format("Posting Date", 0, '<Day,2>-<Month Text,3>-<Year4>')) { }
            column(WorkDate; Format(WorkDate(), 0, '<Day,2> <Month Text> <Year4>')) { }
            column(LogoCompany; CompanyInfo.Picture) { }
            column(External_Document_No_; "External Document No.") { }
            column(Trucking_No_; warehouseMgnt.getInfoGenWseshipment("No.", 0))
            {

            }
            column(ReportType; ReportType)
            {

            }
            column(chekedByName; warehouseMgnt.getinfoEmployeeName(warehouseMgnt.getInfoEmployeeWseshipment("No.", 1))) { }
            column(PreparedByName; warehouseMgnt.getinfoEmployeeName(warehouseMgnt.getInfoEmployeeWseshipment("No.", 0))) { }
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Shipment Header";
                column(BilltoAddress; BilltoAddress) { }
                column(PartNo; Item."Common Item No.") { }
                column(ShippingLotNo; Item."Shipping Lot No." + Format("Posting Date", 0, '<Year><Month,2><Day,2>')) { }
                column(LineCount1; Format(LineCount)) { }
                column(TotalQty; TotalQty) { }
                column(BilltoContact; BilltoContact) { }
                column(CustomerName; CustomerName) { }
                column(BillTelpNo; BillTelpNo) { }
                column(customerPostingGroup; customerPostingGroup) { }
                column(LineCount; leadingByZero(Format(LineCount))) { }
                column(ItemNo_; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Quantity_Frmt; GenCU.FormatNumber(Quantity)) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(UnitPacking; Format(vqtyPacking) + ' ' + vUomPacking) { }
                column(Remars; RemarksLine) { }
                column(ModelAttr; getItemAttribute('Model No.')) { }

                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Item No." = FIELD("No."), "Location Code" = field("Location Code"), "Document No." = field("Document No.")
                    , "Document Line No." = field("Line No.");
                    DataItemTableView = sorting("Entry No.");
                    DataItemLinkReference = "Sales Shipment Line";
                    column(Lot_No_; "Lot No.") { }
                    column(Quantity_Lot; Abs(Quantity))
                    {

                    }
                    column(UOMILE; "Unit of Measure Code") { }
                    column(PartName; Description) { }
                    column(Package_No_; "Package No.") { }
                    column(Shipping_Mark_No_; "Shipping Mark No.") { }
                    column(Box_Qty_; "Box Qty.") { }
                    trigger OnAfterGetRecord()
                    var
                        myInt: Integer;
                    begin
                        LineCount += 1;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    getInfoReport();
                    Clear(Item);
                    Item.Reset();
                    Item.SetRange("No.", "Sales Shipment Line"."No.");
                    if Item.Find('-') then;
                    TotalQty += Quantity;
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
        TotalQty := 0;
        Clear(GenCU);
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

    local procedure getItemAttribute(iAttrName: Text): Text
    var
        ItemAttr: Record "Item Attribute";
        ItemAttrValueMap: Record "Item Attribute Value Mapping";
        ItemAttrValue: Record "Item Attribute Value";
    begin
        Clear(ItemAttr);
        ItemAttr.Reset();
        ItemAttr.SetRange(Name, iAttrName);
        ItemAttr.SetRange(Blocked, false);
        if ItemAttr.Find('-') then begin
            Clear(ItemAttrValueMap);
            ItemAttrValueMap.Reset();
            ItemAttrValueMap.SetRange("No.", "Sales Shipment Line"."No.");
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
        TotalQty: Decimal;
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

        ItemAttributes: Record "Item Attribute";

        GenCU: Codeunit CLODValidation_SP;

}
