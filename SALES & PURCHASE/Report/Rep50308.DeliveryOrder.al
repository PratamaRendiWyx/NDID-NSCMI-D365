report 50308 "Delivery Order"
{
    Caption = 'Delivery Order';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/Delivery Order.rdlc';
    ApplicationArea = Basic, Suite;
    dataset
    {
        dataitem("Posted DO Header"; "Posted DO Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Order_No_; "Order No.") { }
            column(Location_Code; "Location Code") { }
            column(TotalLineAmount; TotalLineAmount) { }
            column(userID; UserId) { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2> <Month Text> <Year4>')) { }
            column(Posting_Datev1; Format("Posting Date", 0, '<Day,2>-<Month Text,3>-<Year4>')) { }
            column(WorkDate; Format(WorkDate(), 0, '<Day,2> <Month Text> <Year4>')) { }
            column(LogoCompany; CompanyInfo.Picture) { }
            column(External_Document_No_; "Vendor Shipment No.") { }
            column(Trucking_No_; '') { }
            column(Notes; Notes) { }
            column(BilltoAddress; "Ship-to Address" + ' ' + "Ship-to Address 2") { }
            column(Prepared_By_Name; "Prepared By Name") { }
            column(Checked_By_Name; "Checked By Name") { }
            column(Warehouse_Person_Name; "Warehouse Person Name") { }
            dataitem("Posted DO Line"; "Posted DO Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Posted DO Header";
                column(PartNo; Item."Common Item No.") { }
                column(LineCount1; Format(LineCount)) { }
                column(BilltoContact; BilltoContact) { }
                column(VendorName; VendorName) { }
                column(BillTelpNo; BillTelpNo) { }
                column(VendorPostingGroup; VendorPostingGroup) { }
                column(LineCount; leadingByZero(Format(LineCount))) { }
                column(ItemNo_; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(UnitPacking; Format(vqtyPacking) + ' ' + vUomPacking) { }
                column(Remars; Remarks) { }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    getInfoReport();
                    LineCount += 1;
                    Clear(Item);
                    Item.Reset();
                    Item.SetRange("No.", "Posted DO Line"."No.");
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
        PurchaseHeader: Record "Purchase Header";
        Vendor: Record Vendor;
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(PurchaseHeader);
        Clear(VendorName);
        Clear(VendorPostingGroup);
        Clear(BilltoAddress);
        Clear(BilltoContact);
        Clear(BillTelpNo);
        Clear(RemarksLine);
        PurchaseHeader.SetRange("No.", "Posted DO Line"."Order No.");
        if PurchaseHeader.Find('-') then begin
            VendorName := PurchaseHeader."Buy-from Vendor Name";
            BilltoContact := PurchaseHeader."Buy-from Contact";
            BilltoAddress := PurchaseHeader."Ship-to Address" + ' ' + PurchaseHeader."Ship-to Address 2";
            if Vendor.Get(PurchaseHeader."Buy-from Vendor No.") then begin
                VendorPostingGroup := Vendor."Vendor Posting Group";
                BillTelpNo := Vendor."Phone No.";
            end;
            //get info sales line 
            Clear(PurchaseLine);
            PurchaseLine.Reset();
            PurchaseLine.SetRange("Document No.", "Posted DO Line"."Order No.");
            PurchaseLine.SetRange("Line No.", "Posted DO Line"."Order Line No.");
            if PurchaseLine.Find('-') then begin
                RemarksLine := PurchaseLine.Remarks;
            end;
        end;
    end;

    var

        VendorPostingGroup: Text;
        VendorName: Text;
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
