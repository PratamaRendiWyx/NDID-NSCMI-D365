report 50404 "BOPManualType1"
{
    Caption = 'Print BOP Manual Type 1';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportDesign/BOPManualType1.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(BOPManualHeader; "BOPManualHeader_SP")
        {
            RequestFilterFields = "No.";

            column(Document_No_; "No.") { }
            column(CustomerName; "Customer Name") { }
            column(CustomerPoNo_; "Customer PO No.") { }
            column(Status1; format("Status Approval")) { }
            column(ApprovalDate; format("Approval Date", 0, '<Day,2>-<Month,2>-<Year4>')) { }
            column(Posting_Date; Format("Posting Date", 0, '<Month Text> <Day,2>, <Year4>')) { }
            column(glbCustomer; "Customer Name") { }
            column(CustomerNo; "Customer Name") { }

            dataitem(BOPManualTracking; "BOPManualTracking_SP")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.", "Tracking Line No.");

                column(Entry_No_; "Tracking Line No.") { }
                column(Quantity_ILE; '') { AutoFormatType = 1; }
                column(Lot_No_; "Lot No.") { }
                column(Item_Desc; getItemDesc("Item No.")) { }
                column(Item_Description; getNewItemDescription(getItemDesc("Item No."))) { }
                column(TotalQty; TotalQty) { }
                column(TestNoList; TestNoList) { }

                column(SpesificationNo; getItemAttribute("Item No.", 'Specification No')) { }
                column(Standard1; getItemAttribute("Item No.", 'BOP - Outside Diameter')) { }
                column(Standard2; getItemAttribute("Item No.", 'BOP - Inside Diameter')) { }
                column(Standard3; getItemAttribute("Item No.", 'BOP - Length')) { }
                column(Standard4; getItemAttribute("Item No.", 'BOP - Over Hang')) { }
                column(Standard5; getItemAttribute("Item No.", 'BOP - Matrix Length')) { }
                column(Standard6; getItemAttribute("Item No.", 'BOP - Thickness - Mantle')) { }
                column(Standard7; getItemAttribute("Item No.", 'BOP - Thickness - Matrix')) { }
                column(Standard8; getItemAttribute("Item No.", 'BOP - Cell Density')) { }
                column(Standard9; getItemAttribute("Item No.", 'BOP - Gross Weight')) { }
                column(DrawingNo; getItemAttribute("Item No.", 'Drawing No.')) { }

                column(ShipmentLotNo; glbItem."Shipping Lot No.") { }
                column(glbBOPDocNo; glbBOPDocReffList."Document No.") { }
                column(glbBOPRevNo; glbBOPDocReffList.Revision) { }
                column(glbBOPDate; Format(glbBOPDocReffList.Date, 0, '<Day,2>-<Month,2>-<Year4>')) { }
                column(ShipmentLotNoDate; glbItem."Shipping Lot No." + Format(BOPManualHeader."Posting Date", 0, '<Year,2><Month,2><Day,2>')) { }
                column(Description; glbItem.Description) { }

                dataitem(QualityTestHeader_PQ; QualityTestHeader_PQ)
                {
                    DataItemTableView = sorting("Lot No./Serial No.") where(IsPrimary = const(true));
                    DataItemLink = "Item No." = field("Item No."), "Lot No./Serial No." = field("Lot No.");

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

                        trigger OnPreDataItem()
                        begin
                            if glbSampleto = glbSampleto::Single then
                                SetRange("Sampling to", 1);
                        end;

                    }

                    trigger OnAfterGetRecord()
                    begin
                        if TestNoList = '' then
                            TestNoList := QualityTestHeader_PQ."Test No."
                        else
                            TestNoList += '|' + QualityTestHeader_PQ."Test No.";
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if FilterLineNo <> 0 then
                        SetRange("Line No.", FilterLineNo);
                end;

                trigger OnAfterGetRecord()
                begin
                    //TotalQty += Abs(Quantity);

                    Clear(glbItem);
                    if not glbItem.Get("Item No.") then;

                    Clear(glbBOPDocReffList);
                    glbBOPDocReffList.Reset();
                    glbBOPDocReffList.SetRange("Item No.", "Item No.");
                    if not glbBOPDocReffList.FindSet() then;
                end;
            }
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
                    field(glbSampleto; glbSampleto)
                    {
                        Caption = 'Sample to';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        TotalQty := 0;
    end;

    var
        glbSampleto: enum "Sample to BOP";
        glbCustomer: enum "BOP Customer";
        TotalQty: Decimal;
        TestNoList: Text;
        glbItem: Record Item;
        glbBOPDocReffList: Record "BOP Refference Document";
        vQty: Decimal;
        vPackaging: Text;
        vUOM: Text;
        vQtyPack: Decimal;
        FilterLineNo: Integer;

    procedure SetLineFilter(pLineNo: Integer)
    begin
        FilterLineNo := pLineNo;
    end;

    local procedure getValueQT(iTestNo: Code[20]; iLineNo: Integer; iDisplaySeq: Integer): Text
    var
        QTLine: Record QualityTestLines_PQ;
        qualityResult: Record QCQualityMeasureOptions_PQ;
    begin
        QTLine.Reset();
        QTLine.SetRange("Test No.", iTestNo);
        QTLine.SetRange("Sampling to", iLineNo);
        QTLine.SetRange("Display Report Seq.", iDisplaySeq);
        if QTLine.FindFirst() then begin
            if QTLine."Result Type" = QTLine."Result Type"::List then begin
                qualityResult.Reset();
                qualityResult.SetRange("Quality Measure Code", QTLine."Quality Measure");
                qualityResult.SetRange(Code, QTLine.Result);
                if qualityResult.FindFirst() then
                    exit(qualityResult.Description);
            end else
                exit(Format(QTLine."Actual Measure", 0, '<Precision,1:1><Standard Format,1><Comma,.>'));
        end;
        exit('');
    end;

    local procedure getValueMantleFoil(iTestNo: Code[20]; iSeq: Integer): Text
    var
        QTLine: Record QualityTestLines_PQ;
    begin
        QTLine.Reset();
        QTLine.SetRange("Test No.", iTestNo);
        if iSeq = 1 then
            QTLine.SetRange("Quality Measure", 'MM')
        else
            QTLine.SetRange("Quality Measure", 'FM');
        if QTLine.FindFirst() then begin
            if QTLine."Result Type" = QTLine."Result Type"::List then
                exit(QTLine.Result)
            else
                exit(Format(QTLine."Actual Measure", 0, '<Standard Format,0><Comma,.>'));
        end;
        exit('');
    end;

    local procedure getItemAttribute(iItemNo: Code[20]; iAttrName: Text): Text
    var
        ItemAttr: Record "Item Attribute";
        ItemAttrValueMap: Record "Item Attribute Value Mapping";
        ItemAttrValue: Record "Item Attribute Value";
    begin
        ItemAttr.Reset();
        ItemAttr.SetRange(Name, iAttrName);
        if ItemAttr.FindFirst() then begin
            ItemAttrValueMap.Reset();
            ItemAttrValueMap.SetRange("Table ID", 27);
            ItemAttrValueMap.SetRange("No.", iItemNo);
            ItemAttrValueMap.SetRange("Item Attribute ID", ItemAttr.ID);
            if ItemAttrValueMap.FindFirst() then begin
                ItemAttrValue.Reset();
                ItemAttrValue.SetRange("Attribute ID", ItemAttrValueMap."Item Attribute ID");
                ItemAttrValue.SetRange(ID, ItemAttrValueMap."Item Attribute Value ID");
                if ItemAttrValue.FindFirst() then
                    exit(ItemAttrValue.Value);
            end;
        end;
        exit('');
    end;

    local procedure getItemDesc(iNo: Text): Text
    var
        Items: Record Item;
    begin
        if Items.Get(iNo) then
            exit(Items.Description);
        exit('');
    end;

    local procedure getManufacturerDate(var qualityTestHeader: Record QualityTestHeader_PQ): Date
    var
        ILE: Record "Item Ledger Entry";
    begin
        ILE.Reset();
        ILE.SetRange("Item No.", qualityTestHeader."Item No.");
        ILE.SetRange("Lot No.", qualityTestHeader."Lot No./Serial No.");
        ILE.SetCurrentKey("Posting Date");
        ILE.Ascending(true);
        if ILE.FindFirst() then
            exit(ILE."Posting Date");
        exit(0D);
    end;

    local procedure getUOMDesc(iUOM: Text): Text
    var
        UOM: Record "Unit of Measure";
    begin
        if UOM.Get(iUOM) then
            exit(UOM.Description);
        exit('');
    end;

    local procedure getQtyUOMOnItemUOM(ICodePackaging: Text; iItemNo: Text): Decimal
    var
        itemUom: Record "Item Unit of Measure";
    begin
        if itemUom.Get(iItemNo, ICodePackaging) then
            exit(itemUom."Qty. per Unit of Measure");
        exit(0);
    end;

    local procedure getNewItemDescription(iDescription: Text): Text
    var
        StrPosInt: Integer;
    begin
        StrPosInt := StrPos(iDescription, '@');
        if StrPosInt > 0 then
            exit(CopyStr(iDescription, 1, StrPosInt - 1));
        exit(iDescription);
    end;
}