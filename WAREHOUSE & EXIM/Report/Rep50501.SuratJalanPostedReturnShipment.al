report 50502 "Surat Jalan (Return Ship)"
{
    Caption = 'Surat Jalan (Return Ship)';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/Surat Jalan Return Ship.rdlc';
    ApplicationArea = Basic, Suite;
    dataset
    {
        dataitem("Return Shipment Header"; "Return Shipment Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Location_Code; "Location Code") { }
            column(TotalLineAmount; TotalLineAmount) { }
            column(Additional_Notes; "Additional Notes")
            {

            }
            column(userID; UserId) { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2> <Month Text> <Year4>')) { }
            column(Posting_Datev1; Format("Posting Date", 0, '<Day,2>-<Month Text,3>-<Year4>')) { }
            column(WorkDate; Format(WorkDate(), 0, '<Day,2> <Month Text> <Year4>')) { }
            column(LogoCompany; CompanyInfo.Picture) { }
            column(External_Document_No_; "Return Order No.") { }
            column(BilltoAddress; "Pay-to Address" + ' ' + "Pay-to Address 2") { }
            column(BilltoContact; "Pay-to Contact") { }
            column(CustomerName; "Pay-to Name") { }
            column(BillTelpNo; GlbVendor."Phone No.") { }
            column(customerPostingGroup; "Vendor Posting Group") { }
            column(Checked_By_Name; "Checked By Name") { }
            column(Prepared_By_Name; "Prepared By Name") { }
            column(Warehouse_Person_Name; "Warehouse Person Name") { }
            dataitem("Return Shipment Line"; "Return Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Return Shipment Header";
                column(LineCount; leadingByZero(Format(LineCount))) { }
                column(PartNo; Item."Common Item No.") { }
                column(LineCount1; Format(LineCount)) { }
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
                    if "Return Shipment Line".Type <> "Return Shipment Line".Type::Item then
                        CurrReport.Skip();
                    LineCount += 1;
                    Clear(Item);
                    Item.Reset();
                    Item.SetRange("No.", "Return Shipment Line"."No.");
                    if Item.Find('-') then;
                end;
            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                getInfoReport();
            end;
        }
    }


    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        Clear(GlbVendor);
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
    begin
        Clear(GlbVendor);
        GlbVendor.Reset();
        GlbVendor.SetRange("No.", "Return Shipment Header"."Buy-from Vendor No.");
        if not GlbVendor.Find('-') then;
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
        GlbVendor: Record Vendor;

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
