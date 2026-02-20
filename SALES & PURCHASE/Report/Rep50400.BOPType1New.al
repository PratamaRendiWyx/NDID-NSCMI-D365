report 50400 "BOP Type 1 New"
{
    Caption = 'Print BOP';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/BOP Type1 New.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "Document No.", "Document Line No.", "Item No.";
            column(Entry_No_; "Entry No.") { }
            column(Package_No_; "Package No.")
            {

            }
            // column(glbCustomer; Format(glbCustomer)) { }
            column(glbCustomer; getCustomerName(glbShipmentHeader."Sell-to Customer No.", glbShipmentHeader."Sell-to Customer Name")) { }
            column(CustomerName; glbShipmentHeader."Sell-to Customer Name") { }
            column(CustomerPoNo_; glbShipmentHeader."External Document No.") { }
            column(Status1; format(glbShipmentLines."Status Approval")) { }
            column(ApprovalDate; format(glbShipmentLines."Approval Date", 0, '<Day,2>-<Month,2>-<Year4>')) { } //Format(approvalEntry."Last Date-Time Modified", 0, '<Day,2>-<Month,2>-<Year>
            column(CustomerNo; glbShipmentHeader."Sell-to Customer No.") { }
            column(SpesificationNo; getItemAttribute('Specification No')) { }
            // column(StatusApproval;glbShipmentHeader.)
            /*
            BOP - Outside Diameter
            BOP - Inside Diameter
            BOP - Length
            BOP - Over Hang
            BOP - Matrix Length
            BOP - Thickness - Mantle
            BOP - Thickness - Matrix
            BOP - Cell Density
            BOP - Gross Weight
            */
            column(Standard1; getItemAttribute('BOP - Outside Diameter')) { }
            column(Standard2; getItemAttribute('BOP - Inside Diameter')) { }
            column(Standard3; getItemAttribute('BOP - Length')) { }
            column(Standard4; getItemAttribute('BOP - Over Hang')) { }
            column(Standard5; getItemAttribute('BOP - Matrix Length')) { }
            column(Standard6; getItemAttribute('BOP - Thickness - Mantle')) { }
            column(Standard7; getItemAttribute('BOP - Thickness - Matrix')) { }
            column(Standard8; getItemAttribute('BOP - Cell Density')) { }
            column(Standard9; getItemAttribute('BOP - Gross Weight')) { }
            //-
            column(DrawingNo; getItemAttribute('Drawing No.')) { }
            column(ShipmentLotNo; glbItem."Shipping Lot No.") { }
            column(glbBOPDocNo; glbBOPDocReffList."Document No.") { }
            column(glbBOPRevNo; glbBOPDocReffList.Revision) { }
            column(glbBOPDate; Format(glbBOPDocReffList.Date, 0, '<Day,2>-<Month,2>-<Year4>')) { }
            column(ShipmentLotNoDate; glbItem."Shipping Lot No." + Format("Posting Date", 0, '<Year,2><Month,2><Day,2>')) { }
            column(Description; Description) { }
            column(Posting_Date; Format("Posting Date", 0, '<Month Text> <Day,2>, <Year4>')) { }
            column(Quantity_ILE; Abs(Quantity)) { AutoFormatType = 1; }
            column(Expiration_Date; Format("Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(TestNoList; TestNoList) { }
            column(Document_No_; "Document No.") { }
            column(Item_Desc; getItemDesc("Item No.")) { }
            column(TotalQty; TotalQty) { }
            column(Lot_No_; "Lot No.") { }

            column(Item_Description; getNewItemDescription(Description)) { }
            dataitem(QualityTestHeader_PQ; QualityTestHeader_PQ)
            {
                DataItemTableView = sorting("Lot No./Serial No.") where(IsPrimary = const(true));
                DataItemLink = "Item No." = field("Item No."), "Lot No." = field("Lot No.");
                DataItemLinkReference = "Item Ledger Entry";
                column(Qty_at_Test_Time; "Qty at Test-Time") { }
                column(TestStatus; format(Status)) { }
                column(Test_Qty; "Test Qty") { }
                column(ManufacturerDate; Format(getManufacturerDate(QualityTestHeader_PQ), 0, '<Year4>/<Month,2>/<Day,2>')) { }
                column(Lot_No__Serial_No_; "Lot No./Serial No.") { }
                column(vQty; vQty) { }
                column(vUOM; getUOMDesc(vUOM)) { }
                column(getQtyUOMOnItemUOM; getQtyUOMOnItemUOM(vPackaging, "Item No.")) { }
                column(vQtyPack; vQtyPack) { }
                dataitem(QualityTestLines_PQ; QualityTestLines_PQ)
                {
                    DataItemLink = "Test No." = field("Test No.");
                    DataItemLinkReference = QualityTestHeader_PQ;
                    // DataItemTableView = sorting("Test No.", "Line No.");
                    column(Sampling_to; "Sampling to") { }
                    column(Display1; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 1)) { }
                    column(Display2; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 2)) { }
                    column(Display3; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 3)) { }
                    column(Display4; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 4)) { }
                    column(Display5; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 5)) { }
                    column(Display6; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 6)) { }
                    column(Display7; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 7)) { }
                    column(Display8; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 8)) { }
                    column(Display9; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 9)) { }
                    column(Display10; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 10)) { }
                    column(Display11; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 11)) { }
                    column(Display12; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 12)) { }
                    column(Display13; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 13)) { }
                    column(Display14; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 14)) { }
                    column(Display15; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 15)) { }
                    column(Display16; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 16)) { }
                    column(Display17; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 17)) { }
                    column(Display18; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 18)) { }
                    column(Display19; getValueQT(QualityTestHeader_PQ."Test No.", QualityTestLines_PQ."Sampling to", 19)) { }
                    column(MantleValue; getValueMantleFoil(QualityTestHeader_PQ."Test No.", 1)) { }
                    column(FoilValue; getValueMantleFoil(QualityTestHeader_PQ."Test No.", 2)) { }
                    trigger OnAfterGetRecord()
                    var
                        myInt: Integer;
                    begin
                        if not Display then
                            CurrReport.Skip();
                    end;

                    trigger OnPreDataItem()
                    var
                        myInt: Integer;
                    begin
                        SetRange(Display, true);
                        SetFilter("Sampling to", '>0');
                        // if glbSampleto = glbSampleto::Single then
                        //     SetRange("Sampling to", 1);
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    if Not (QualityTestHeader_PQ."Test Status" IN [QualityTestHeader_PQ."Test Status"::Certified, QualityTestHeader_PQ."Test Status"::Closed]) then
                        CurrReport.Skip();
                    if TestNoList = '' then
                        TestNoList := QualityTestHeader_PQ."Test No."
                    else
                        TestNoList += '|' + QualityTestHeader_PQ."Test No.";
                end;

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    // SetFilter(Status, '%1|%2', Status::Certified, Status::Closed);
                end;
            }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                TotalQty += Abs(Quantity);
                Clear(glbShipmentHeader);
                glbShipmentHeader.Reset();
                glbShipmentHeader.SetRange("No.", "Document No.");
                if not glbShipmentHeader.FindSet() then;

                Clear(glbShipmentLines);
                glbShipmentLines.Reset();
                glbShipmentLines.SetRange("Document No.", "Item Ledger Entry"."Document No.");
                glbShipmentLines.SetRange("Line No.", "Item Ledger Entry"."Document Line No.");
                if not glbShipmentLines.FindSet() then;

                Clear(glbItem);
                glbItem.Reset();
                glbItem.SetRange("No.", "Item No.");
                if not glbItem.FindSet() then;

                Clear(glbBOPDocReffList);
                glbBOPDocReffList.Reset();
                glbBOPDocReffList.SetRange("Customer No.", glbShipmentHeader."Sell-to Customer No.");
                glbBOPDocReffList.SetRange("Item No.", glbItem."No.");
                if not glbBOPDocReffList.Find('-') then;
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
                    //list field name
                    field(Customer; glbCustomer)
                    {
                        Caption = 'Customer';
                        ApplicationArea = All;
                    }
                    field(glbSampleto; glbSampleto)
                    {
                        Caption = 'Sample to';
                        ApplicationArea = All;
                        Visible = false;
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


    var
    //myInt: Integer;

    var
        glbLotNo: Text;

    local procedure getValueQT(iTestNo: Code[20]; iLineNo: Integer; iDisplaySeq: Integer): Text
    var
        QTLine: Record QualityTestLines_PQ;
        qualityResult: Record QCQualityMeasureOptions_PQ;
        tempText: Text;
        TypeHelper: Codeunit "Type Helper";
        LocNumber: Decimal;
    begin
        Clear(QTLine);
        QTLine.Reset();
        QTLine.SetRange("Test No.", iTestNo);
        QTLine.SetRange("Sampling to", iLineNo);
        QTLine.SetRange("Display Report Seq.", iDisplaySeq);
        if QTLine.FindSet() then begin
            if QTLine."Result Type" = QTLine."Result Type"::List then begin
                Clear(qualityResult);
                qualityResult.Reset();
                qualityResult.SetRange("Quality Measure Code", QTLine."Quality Measure");
                qualityResult.SetRange(Code, QTLine.Result);
                if qualityResult.Find('-') then begin
                    tempText := qualityResult.Description;
                    exit(tempText);
                end;
            end else begin
                tempText := Format(QTLine."Actual Measure", 0, '<Precision,1:1><Standard Format,1><Comma,.>');
                // if QTLine.IsInteger then
                //     tempText := tempText.Replace('.0', '');
                exit(tempText);
            end;
        end;
    end;

    local procedure getValueMantleFoil(iTestNo: Code[20]; iSeq: Integer): Text
    var
        QTLine: Record QualityTestLines_PQ;
        qualityResult: Record QCQualityMeasureOptions_PQ;
        tempText: Text;
    begin
        Clear(QTLine);
        QTLine.Reset();
        QTLine.SetRange("Test No.", iTestNo);
        if iSeq = 1 then
            QTLine.SetRange("Quality Measure", 'MM')
        else
            QTLine.SetRange("Quality Measure", 'FM');
        if QTLine.FindSet() then begin
            if QTLine."Result Type" = QTLine."Result Type"::List then begin
                // Clear(qualityResult);
                // qualityResult.Reset();
                // qualityResult.SetRange("Quality Measure Code", QTLine."Quality Measure");
                // if qualityResult.Find('-') then
                exit(QTLine.Result);
            end else begin
                tempText := Format(QTLine."Actual Measure", 0, '<Standard Format,0><Comma,.>');
                if QTLine.IsInteger then
                    tempText := tempText.Replace('.0', '');
                exit(tempText);
            end;
        end;
    end;

    local procedure getValueActAndResultList(): Text
    var
        qualityResult: Record QCQualityMeasureOptions_PQ;
        tempText: Text;
    begin
        if QualityTestLines_PQ."Result Type" = QualityTestLines_PQ."Result Type"::List then begin
            Clear(qualityResult);
            qualityResult.Reset();
            qualityResult.SetRange("Quality Measure Code", QualityTestLines_PQ."Quality Measure");
            if qualityResult.Find('-') then
                exit(qualityResult.Description);
        end else begin
            tempText := Format(QualityTestLines_PQ."Actual Measure", 0, '<Standard Format,0><Comma,.>');
            if QualityTestLines_PQ.IsInteger then
                tempText := tempText.Replace('.00', '.0');
            exit(tempText);
        end;
    end;

    //Specification No | Drawing No.
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
            ItemAttrValueMap.SetRange("No.", "Item Ledger Entry"."Item No.");
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

    local procedure getItemDesc(iNo: Text): Text
    var
        Items: Record Item;
    begin
        Clear(Items);
        Items.Reset();
        Items.SetRange("No.", iNo);
        if Items.Find('-') then
            exit(Items.Description);
        exit('');
    end;

    local procedure getCustomerName(iCustomerNo: Code[20]; iCustomerName: Text): Text
    begin
        if iCustomerNo = 'C0007' then
            exit(Format(glbCustomer))
        else
            exit(iCustomerName);
    end;

    var
        vQty: Decimal;
        vPackaging: Text;
        vUOM: Text;
        vQtyPack: Decimal;

        CustomerPoNo: Text;
        NoContainer: Text;
        TotalQty: Decimal;



    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        TotalQty := 0;
    end;

    local procedure getManufacturerDate(var qualityTestHeader: Record QualityTestHeader_PQ): Date
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        Clear(ItemLedgerEntry);
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Item No.", qualityTestHeader."Item No.");
        ItemLedgerEntry.SetRange("Variant Code", qualityTestHeader."Variant Code");
        // ItemLedgerEntry.SetRange("Lot No.", qualityTestHeader."Lot No./Serial No.");
        ItemLedgerEntry.SetRange("Lot No.", glbLotNo);
        ItemLedgerEntry.SetCurrentKey("Posting Date");
        ItemLedgerEntry.Ascending;
        if ItemLedgerEntry.FindFirst() then
            exit(ItemLedgerEntry."Posting Date");
        exit(0D);
    end;

    local procedure getSpesificationValue(var qualityTestLine: Record QualityTestLines_PQ): Text
    var
        OptionResult: Record QCQualityMeasureOptions_PQ;
    begin
        if qualityTestLine."Result Type" = qualityTestLine."Result Type"::List then begin
            Clear(OptionResult);
            OptionResult.Reset();
            OptionResult.SetRange(Code, qualityTestLine.Result);
            if OptionResult.Find('-') then
                exit(OptionResult.Description);
        end else
            exit(Format(qualityTestLine."Lower Limit") + ' ~ ' + Format(qualityTestLine."Upper Limit") + ' ' + qualityTestLine."Testing UOM");
    end;

    local procedure getQtyUOMOnItemUOM(ICodePackaging: Text; iItemNo: Text): Decimal
    var
        itemUom: Record "Item Unit of Measure";
    begin
        Clear(itemUom);
        itemUom.Reset();
        itemUom.SetRange("Item No.", iItemNo);
        itemUom.SetRange(Code, ICodePackaging);
        if itemUom.Find('-') then
            exit(itemUom."Qty. per Unit of Measure");
        exit(0);
    end;

    local procedure getUOMDesc(iUOM: Text): Text
    var
        unitOfMeasure: Record "Unit of Measure";
    begin
        Clear(unitOfMeasure);
        unitOfMeasure.Reset();
        unitOfMeasure.SetRange(Code, iUOM);
        if unitOfMeasure.Find('-') then
            exit(unitOfMeasure.Description);
        exit('');
    end;

    local procedure getNewItemDescription(iDescription: Text): Text
    var
        NewText: Text;
        StrPosInt: Integer;
    begin
        NewText := iDescription;
        StrPosInt := StrPos(iDescription, '@');
        if StrPosInt > 0 then
            NewText := CopyStr(iDescription, 1, StrPosInt - 1);
        exit(NewText);
    end;

    var
        TestNoList: Text;
        glbShipmentHeader: Record "Sales Shipment Header";
        glbShipmentLines: Record "Sales Shipment Line";
        glbItem: Record Item;
        glbCustomer: enum "BOP Customer";
        glbSampleto: enum "Sample to BOP";
        glbBOPDocReffList: Record "BOP Refference Document";
}
