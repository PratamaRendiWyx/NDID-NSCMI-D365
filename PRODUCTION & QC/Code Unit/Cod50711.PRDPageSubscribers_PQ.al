codeunit 50711 PRDPageSubscribers_PQ
{

    //  - Removed some code on StandardCostWorksheetOnAfterGetRecord which caused an error when trying to implement the
    //    Standard Cost changed.


    trigger OnRun()
    begin
    end;

    var
        DateTemp: Text[30];
        //CalcCurrCost: Codeunit CalculateCurrentCost_PQ;
        MPText000: Label 'Item Not Found';
        VersionMgt: Codeunit VersionManagement;
        TimeExpendedPct: Decimal;
        OperationName: Text[100];

    [EventSubscriber(ObjectType::Page, 30, 'OnAfterGetRecordEvent', '', false, false)]
    local procedure ItemCardOnAfterGetRecord(var Rec: Record Item)
    var
        RtngActiveVersionCode: Code[20];
        BOMActiveVersionCode: Code[20];
        VersionMgt: Codeunit VersionManagement;
    begin
        if Rec."Routing No." <> '' then
            RtngActiveVersionCode := VersionMgt.GetRtngVersion(Rec."Routing No.", WorkDate, true);  // TRUE = (only certified)

        if Rec."Production BOM No." <> '' then
            BOMActiveVersionCode := VersionMgt.GetBOMVersion(Rec."Production BOM No.", WorkDate, true);  // TRUE = (only certified)
    end;


    [EventSubscriber(ObjectType::Page, PAGE::"Demand Forecast Variant Matrix", 'OnOpenPageEvent', '', false, false)]
    local procedure ProductionForecastMatrixOnOpenPage(var Rec: Record "Forecast Item Variant Loc" temporary)
    var
        CY: Text[30];
        PY: Text[30];
        StrAsNum: Integer;
        ItemT1: Record Item;
        TextManagement: Codeunit "Filter Tokens";
    begin
        CY := Format(WorkDate);
        CY := CopyStr(CY, (StrLen(CY) - 1), 2);
        Evaluate(StrAsNum, CY);
        StrAsNum := StrAsNum - 1;
        PY := Format(StrAsNum);
        DateTemp := '1/1/' + PY + '..' + '12/31/' + PY;
        //ApplicationManagement.MakeDateFilter(DateTemp);
        TextManagement.MakeDateFilter(DateTemp);
    end;

    [EventSubscriber(ObjectType::Page, PAGE::"Demand Forecast Variant Matrix", 'OnAfterGetRecordEvent', '', false, false)]
    local procedure ProductionForecastMatrixOnAfterGetRecord(var Rec: Record "Forecast Item Variant Loc" temporary)
    var
        ItemT1: Record Item;
    begin
        ItemT1.SetRange("No.", Rec."No.");
        ItemT1.SetFilter("Date Filter", DateTemp);
        if ItemT1.FindSet then
            ItemT1.CalcFields("Qty On Sales Invoice");
    end;

    [EventSubscriber(ObjectType::Page, 99000788, 'OnAfterGetRecordEvent', '', false, false)]
    local procedure ProductionBOMLinesOnAfterGetRecord(var Rec: Record "Production BOM Line")
    var
        ProdBOMLine: Record "Production BOM Line";
    begin
        Rec.CalcFields(Rec."BOM Number", Rec."Item Flushing Method");
    end;

    [EventSubscriber(ObjectType::Page, 99000788, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure ProductionBOMLinesOnValidateNo(var Rec: Record "Production BOM Line")
    var
        ProdBOMLines: Record "Production BOM Line";
    begin
        Rec.CalcFields(Rec."BOM Number", Rec."Item Flushing Method");
    end;

    [EventSubscriber(ObjectType::Page, 99000788, 'OnAfterValidateEvent', 'Quantity per', false, false)]
    local procedure ProductionBOMLinesOnValidateQtyPer(var Rec: Record "Production BOM Line")
    var
        ProdBOMLines: Record "Production BOM Line";
    begin
        Rec.CalcFields(Rec."BOM Number", Rec."Item Flushing Method");
    end;

    [EventSubscriber(ObjectType::Page, 99000788, 'OnAfterValidateEvent', 'Unit of Measure Code', false, false)]
    local procedure ProductionBOMLinesOnValidateUnitOfMeasure(var Rec: Record "Production BOM Line")
    var
        ProdBOMLines: Record "Production BOM Line";
    begin
        Rec.CalcFields(Rec."BOM Number", Rec."Item Flushing Method");
    end;

    [EventSubscriber(ObjectType::Page, 99000788, 'OnAfterValidateEvent', 'Scrap %', false, false)]
    local procedure ProductionBOMLinesOnValidateScrapPercent(var Rec: Record "Production BOM Line")
    var
        ProdBOMLines: Record "Production BOM Line";
    begin
        Rec.CalcFields(Rec."BOM Number", Rec."Item Flushing Method");
    end;

    [EventSubscriber(ObjectType::Page, 99000786, 'OnAfterActionEvent', 'Update Current Unit Cost', false, false)]
    local procedure ProductionBOMOnAfterActionUpdateUnitCost(var Rec: Record "Production BOM Header")
    begin
        Rec.SetRange(Rec."No.", Rec."No.");
        REPORT.Run(REPORT::UpdatecostonBOMlines_PQ, true, false, Rec);
        Rec.SetRange(Rec."No.");
    end;

    local procedure PlannedProdOrderLinesOnOpenPage(var Rec: Record "Prod. Order Line")
    var
        PlannedProdOrderLine: Record "Prod. Order Line";
        AlertColor: Boolean;
    begin
        AlertColor := true;
    end;

    [EventSubscriber(ObjectType::Page, 99000816, 'OnAfterGetRecordEvent', '', false, false)]
    local procedure ProductionOrderStatisticsOnAfterGetRecord(var Rec: Record "Production Order")
    var
        ProdOrder: Record "Production Order";
        CapacityExpHours: Decimal;
        CapacityActHours: Decimal;
        StdCostEach: Decimal;
        ExpCostEach: Decimal;
        ActCostEach: Decimal;
        ExpPartsPerHr: Decimal;
        ActPartsPerHr: Decimal;
        VarAmtExp: array[6] of Decimal;
        VarPctExp: array[6] of Decimal;
        VarAmtCap: Decimal;
        VarHrsCap: Decimal;
        VarPartsPerHr: Decimal;
        TimeExpendedPctExp: Decimal;
        VarAmtCap2: Decimal;
        VarHrsCap2: Decimal;
        VarPartsPerHr2: Decimal;
        ExpCapNeed: Decimal;
        ActTimeUsed: Decimal;
        CapacityUoM: Code[10];
        StdCost: array[6] of Decimal;
        ExpCost: array[6] of Decimal;
        ActCost: array[6] of Decimal;
        i: Integer;
        VarAmt: array[6] of Decimal;
        VarPct: array[6] of Decimal;
        DummyVar: Decimal;
    begin
        StdCostEach := 0;
        ExpCostEach := 0;
        ActCostEach := 0;
        ExpPartsPerHr := 0;
        ActPartsPerHr := 0;
        VarAmtCap := 0;
        VarHrsCap := 0;
        VarPartsPerHr := 0;

        CapacityExpHours := ExpCapNeed / 60;
        CapacityActHours := ActTimeUsed / 60;
        VarAmtCap := ActTimeUsed - ExpCapNeed;
        VarHrsCap := CapacityActHours - CapacityExpHours;
        if Rec.Quantity <> 0 then begin
            StdCostEach := StdCost[6] / Rec.Quantity;
            ExpCostEach := ExpCost[6] / Rec.Quantity;
            ActCostEach := ActCost[6] / Rec.Quantity;

            ExpPartsPerHr := CapacityExpHours / Rec.Quantity;
            ActPartsPerHr := CapacityActHours / Rec.Quantity;
            VarPartsPerHr := ActPartsPerHr - ExpPartsPerHr;
        end;

        for i := 1 to ArrayLen(VarAmt) do begin
            VarAmtExp[i] := ActCost[i] - ExpCost[i];
            VarPctExp[i] := CalcIndicatorPct(ExpCost[i], ActCost[i]);
        end;
        TimeExpendedPct := CalcIndicatorPct(ExpCapNeed, ActTimeUsed);
    end;

    local procedure CalcIndicatorPct(Value: Decimal; "Sum": Decimal): Decimal
    begin
        if Value = 0 then
            exit(0);

        exit(Round((Sum - Value) / Value * 100, 1));
    end;

    [EventSubscriber(ObjectType::Page, 99000817, 'OnOpenPageEvent', '', false, false)]
    local procedure ProductionOrderRoutingOnOpenPage(var Rec: Record "Prod. Order Routing Line")
    var
        AlertColor: Boolean;
    begin
        AlertColor := true;
    end;

    [EventSubscriber(ObjectType::Page, 99000818, 'OnOpenPageEvent', '', false, false)]
    local procedure ProductionOrderComponentsOnOpenPage(var Rec: Record "Prod. Order Component")
    var
        i: Integer;
        ProdOrderComp: Record "Prod. Order Component";
    begin
        i := 0;
    end;

    [EventSubscriber(ObjectType::Page, 99000818, 'OnAfterGetRecordEvent', '', false, false)]
    local procedure ProductionOrderComponentsOnAfterGetRecord(var Rec: Record "Prod. Order Component")
    var
        ProdOrderComponent: Record "Prod. Order Component";
        AlertColor: Boolean;
        ProdOrderCompT: Record "Prod. Order Component";
        MatlConstraintDate: Date;
        i: Integer;
    begin
        i := i + 1;
        if i = 1 then
            // GetMatlConstraintDate(Rec);
            //code here from local function
            MatlConstraintDate := 0D;
        ProdOrderCompT.SetRange(Status, Rec.Status);
        ProdOrderCompT.SetRange("Prod. Order No.", Rec."Prod. Order No.");
        ProdOrderCompT.SetRange("Prod. Order Line No.", Rec."Prod. Order Line No.");
        if ProdOrderCompT.FindSet then
            repeat
                if ProdOrderCompT."Earliest Available Date" > MatlConstraintDate then
                    MatlConstraintDate := ProdOrderCompT."Earliest Available Date";
            until ProdOrderCompT.Next = 0;

        AlertColor := false;
        if Rec."Earliest Available Date" = MatlConstraintDate then
            AlertColor := true;
    end;

    [EventSubscriber(ObjectType::Page, 99000830, 'OnOpenPageEvent', '', false, false)]
    local procedure FirmPlannedProdOrderOnOpenPage(var Rec: Record "Prod. Order Line")
    var
        AlertColor: Boolean;
    begin
        AlertColor := true;
    end;

    [EventSubscriber(ObjectType::Page, 99000846, 'OnAfterGetRecordEvent', '', false, false)]
    local procedure ConsumptionJnlOnAfterGetRecord(var Rec: Record "Item Journal Line")
    var
        ItemJnlMgt: Codeunit ItemJnlManagement;
        TotalAmount: Decimal;
        ItemJnlLine: Record "Item Journal Line";
        ProdOrderDescription: Text;
    begin
        TotalAmount := 0;
        ItemJnlLine.Reset;
        ItemJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name");
        ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        ItemJnlLine.CalcSums(Amount);
        TotalAmount := ItemJnlLine."Unit Amount";
        ItemJnlMgt.GetConsump(Rec, ProdOrderDescription);
    end;

    [EventSubscriber(ObjectType::Page, 99000846, 'OnNewRecordEvent', '', false, false)]
    local procedure ConsumptionJnlOnAfterNewRecord(var Rec: Record "Item Journal Line")
    var
        ItemJnlMgt: Codeunit ItemJnlManagement;
        TotalAmount: Decimal;
        ItemJnlLine: Record "Item Journal Line";
        ProdOrderDescription: Text;
    begin
        TotalAmount := 0;
        ItemJnlLine.Reset;
        ItemJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name");
        ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        ItemJnlLine.CalcSums(Amount);
        TotalAmount := ItemJnlLine."Unit Amount";
        ItemJnlMgt.GetConsump(Rec, ProdOrderDescription);
    end;

    [EventSubscriber(ObjectType::Page, 99000846, 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure ConsumptionJnOnValidatelQuantity(var Rec: Record "Item Journal Line")
    var
        ItemJnlMgt: Codeunit ItemJnlManagement;
        TotalAmount: Decimal;
        ItemJnlLine: Record "Item Journal Line";
        ProdOrderDescription: Text;
    begin
        TotalAmount := 0;
        ItemJnlLine.Reset;
        ItemJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name");
        ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        ItemJnlLine.CalcSums(Amount);
        TotalAmount := ItemJnlLine."Unit Amount";
    end;

    [EventSubscriber(ObjectType::Page, 99000846, 'OnAfterValidateEvent', 'Unit of Measure Code', false, false)]
    local procedure ConsumptionJnlOnValidateUnitOfMeasure(var Rec: Record "Item Journal Line")
    var
        ItemJnlMgt: Codeunit ItemJnlManagement;
        TotalAmount: Decimal;
        ItemJnlLine: Record "Item Journal Line";
        ProdOrderDescription: Text;
    begin
        TotalAmount := 0;
        ItemJnlLine.Reset;
        ItemJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name");
        ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        ItemJnlLine.CalcSums(Amount);
        TotalAmount := ItemJnlLine."Unit Amount";
    end;

    [EventSubscriber(ObjectType::Page, 99000846, 'OnAfterValidateEvent', 'Unit Cost', false, false)]
    local procedure ConsumptionJnOnValidatelUnitCost(var Rec: Record "Item Journal Line")
    var
        ItemJnlMgt: Codeunit ItemJnlManagement;
        TotalAmount: Decimal;
        ItemJnlLine: Record "Item Journal Line";
        ProdOrderDescription: Text;
    begin
        TotalAmount := 0;
        ItemJnlLine.Reset;
        ItemJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name");
        ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        ItemJnlLine.CalcSums(Amount);
        TotalAmount := ItemJnlLine."Unit Amount";
    end;

    [EventSubscriber(ObjectType::Page, 99000846, 'OnAfterValidateEvent', 'Unit Amount', false, false)]
    local procedure ConsumptionJnOnValidatelUnitAmt(var Rec: Record "Item Journal Line")
    var
        ItemJnlMgt: Codeunit ItemJnlManagement;
        TotalAmount: Decimal;
        ItemJnlLine: Record "Item Journal Line";
        ProdOrderDescription: Text;
    begin
        TotalAmount := 0;
        ItemJnlLine.Reset;
        ItemJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name");
        ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        ItemJnlLine.CalcSums(Amount);
        TotalAmount := ItemJnlLine."Unit Amount";
    end;

    [EventSubscriber(ObjectType::Page, 99000846, 'OnAfterActionEvent', 'ItemsByLocation', false, false)]
    local procedure ConsumptionJnOnAfterActionlItemByLocation(var Rec: Record "Item Journal Line")
    var
        item: Record Item;
        ItemsByLocation: Page "Items by Location";
        MPText000: Label 'Item was not found';
    begin
        if item.Get(Rec."Item No.") then begin
            ItemsByLocation.SetRecord(item);
            ItemsByLocation.Run;
        end else
            Error(MPText000);
    end;

    [EventSubscriber(ObjectType::Page, 5510, 'OnAfterActionEvent', 'ItemsByLocation', false, false)]
    local procedure ProductionJnlOnAfterActionItemByLocation(var Rec: Record "Item Journal Line")
    var
        Item: Record Item;
        ItemsByLocation: Page "Items by Location";
    begin
        if Item.Get(Rec."Item No.") then begin
            ItemsByLocation.SetRecord(Item);
            ItemsByLocation.Run;
        end else
            Error(MPText000);
    end;

    local procedure PlanningWorksheetOnValidateUnitCost(var Rec: Record "Requisition Line")
    var
        ReqWkSheet: Page "Req. Worksheet";
        TotalProdOrd: Decimal;
        TotalPurchOrd: Decimal;
        TotalTransfOrd: Decimal;
        WorksheetTotal: Decimal;
    begin
        //ReqWkSheet.RESET;
        Rec.SetCurrentKey(Rec."Worksheet Template Name", Rec."Journal Batch Name", Rec."Planning Line Origin", Rec."Replenishment System");
        Rec.SetFilter(Rec."Worksheet Template Name", Rec."Worksheet Template Name");
        Rec.SetFilter(Rec."Journal Batch Name", Rec."Journal Batch Name");
        Rec.SetFilter(Rec."Replenishment System", 'Prod. Order');
        Rec.CalcSums(Rec."Cost Amount");
        TotalProdOrd := Rec."Cost Amount";
        Rec.SetFilter(Rec."Replenishment System", 'Purchase');
        Rec.CalcSums(Rec."Cost Amount");
        TotalPurchOrd := Rec."Cost Amount";
        Rec.SetFilter(Rec."Replenishment System", 'Transfer');
        Rec.CalcSums(Rec."Cost Amount");
        TotalTransfOrd := Rec."Cost Amount";
        WorksheetTotal := TotalProdOrd + TotalPurchOrd + TotalTransfOrd;  //PlannedTotal + PlanningTotal;
    end;

    local procedure SimulatedProdOrderOnOpenPage(var Rec: Record "Production Order")
    var
        AlertColor: Boolean;
    begin
        AlertColor := true;
    end;

    [EventSubscriber(ObjectType::Page, 99000788, 'OnAfterActionEvent', 'ViewBOM', false, false)]
    local procedure ProductionBOMLinesOnAfterActionViewBOM(var Rec: Record "Production BOM Line")
    var
        ProdBOMT: Record "Production BOM Header";
    begin
        ProdBOMT.SetRange("No.", Rec."BOM Number");
        PAGE.Run(PAGE::"Production BOM", ProdBOMT);
    end;

    [EventSubscriber(ObjectType::Page, 99000788, 'OnAfterActionEvent', 'ViewRouting', false, false)]
    local procedure ProductionBOMLinesOnAfterActionViewRouter(var Rec: Record "Production BOM Line")
    var
        ProdRoutT: Record "Routing Header";
    begin
        ProdRoutT.SetRange("No.", Rec."Routing Number");
        PAGE.Run(PAGE::Routing, ProdRoutT);
    end;

    [EventSubscriber(ObjectType::Page, 99000789, 'OnAfterActionEvent', 'ViewBOM', false, false)]
    local procedure ProdBOMVerLinesOnAfterActionViewBOM(var Rec: Record "Production BOM Line")
    var
        ProdBOMT: Record "Production BOM Header";
    begin
        ProdBOMT.SetRange("No.", Rec."BOM Number");
        PAGE.Run(PAGE::"Production BOM", ProdBOMT);
    end;

    [EventSubscriber(ObjectType::Page, 99000789, 'OnAfterActionEvent', 'ViewRouter', false, false)]
    local procedure ProdBOMVerLinesOnAfterActionViewRouter(var Rec: Record "Production BOM Line")
    var
        ProdRoutT: Record "Routing Header";
    begin
        ProdRoutT.SetRange("No.", Rec."Routing Number");
        PAGE.Run(PAGE::Routing, ProdRoutT);
    end;

    [EventSubscriber(ObjectType::Page, 99000823, 'OnAfterGetRecordEvent', '', false, false)]
    local procedure OutPutJnlOnAfterGetRecord(var Rec: Record "Item Journal Line")
    var
        ItemJnlMgt: Codeunit ItemJnlManagement;
        TotalAmount: Decimal;
        ItemJnlLine: Record "Item Journal Line";
        ProdOrderDescription: Text;
    begin
        TotalAmount := 0;
        ItemJnlLine.Reset;
        ItemJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name");
        ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        ItemJnlLine.CalcSums(Amount);
        TotalAmount := ItemJnlLine."Unit Amount";
        ItemJnlMgt.GetConsump(Rec, ProdOrderDescription);
        ItemJnlMgt.GetOutput(Rec, ProdOrderDescription, OperationName);
    end;

    [EventSubscriber(ObjectType::Page, 5841, 'OnAfterGetRecordEvent', '', false, false)]
    local procedure StandardCostWorksheetOnAfterGetRecord(var Rec: Record "Standard Cost Worksheet")
    var
        ItemT: Record Item;
    begin
        if (Rec."No." <> '') and (ItemT.Get(Rec."No.")) then begin
            // below some how caused error when trying to implement the standard cost change
            //CASE ItemT."Replenishment System" OF
            //ItemT."Replenishment System"::Assembly :
            //"MP Current Unit Cost" := "New Standard Cost";
            //ItemT."Replenishment System"::"Prod. Order" :
            //"MP Current Unit Cost" := CalcCurrCost.CalcItemStdCostWkSh(ItemT."No.",FALSE,TRUE);
            //ELSE
            //"MP Current Unit Cost" := ItemT."Unit Cost";
            //END;
            ItemT.CalcFields(Inventory);
            Rec."Qty. On Hand" := ItemT.Inventory;
        end;
    end;

    [EventSubscriber(ObjectType::Page, 99000787, 'OnAfterGetRecordEvent', '', false, false)]
    local procedure ProductionBOMListOnAfterGetRecord(var Rec: Record "Production BOM Header")
    var
        ActiveVersionCode: Code[20];
    begin
        ActiveVersionCode := VersionMgt.GetBOMVersion(Rec."No.", WorkDate, true);
    end;

    [EventSubscriber(ObjectType::Page, 99000832, 'OnOpenPageEvent', '', false, false)]
    local procedure ReleasedProdOrderOnOpenPage(var Rec: Record "Prod. Order Line")
    var
        AlertColor: Boolean;
    begin
        AlertColor := true;
    end;

    [EventSubscriber(ObjectType::Page, 9327, 'OnAfterActionEvent', 'Estimate vs Actual Detail', false, false)]
    local procedure FinishedProdOrderOnAfterActionEstvsActual(var Rec: Record "Production Order")
    begin
        REPORT.Run(REPORT::ProdOrderExpectActual_PQ, true, false, Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure DocumentAttachmentFactboxOnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        ProductionOrder: Record "Production Order";
    begin
        case
            DocumentAttachment."Table ID" of
            DATABASE::"Production Order":
                begin
                    RecRef.Open(DATABASE::"Production Order");
                    if ProductionOrder.Get(DocumentAttachment."Production Order Status", DocumentAttachment."No.") then
                        RecRef.GetTable(ProductionOrder);
                end;
        end;
    end;

}
