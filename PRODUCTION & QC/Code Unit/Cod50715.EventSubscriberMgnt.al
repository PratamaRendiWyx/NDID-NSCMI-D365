codeunit 50715 "Event Subscriber Mgnt."
{

    Permissions = tabledata "Item Ledger Entry" = R,
    tabledata "Capacity Ledger Entry" = rmid;

    // "Refresh Production Order"
    [EventSubscriber(ObjectType::Report, Report::"Refresh Production Order", OnBeforeCalcProdOrderLines, '', false, false)]
    local procedure OnBeforeCalcProdOrderLines(var ProductionOrder: Record "Production Order"; Direction: Option Forward,Backward; CalcLines: Boolean; CalcRoutings: Boolean; CalcComponents: Boolean; var IsHandled: Boolean; var ErrorOccured: Boolean)
    var
        varproductionOrder: Record "Production Order";
        Label001: Label 'Nothing to handle for refresh line & component, cause item substitute exists for this order [%1]';
    begin
        varproductionOrder.Reset();
        varproductionOrder.SetRange("No.", ProductionOrder."No.");
        varproductionOrder.SetAutoCalcFields("Is Substitute (?)");
        if varproductionOrder.FindSet() then begin
            if varproductionOrder."Is Substitute (?)" then begin
                Message(Label001, varproductionOrder."No.");
                CalcLines := false;
                CalcComponents := false;
                IsHandled := true;
            end;
        end;
    end;

    // "Refresh Production Order"
    [EventSubscriber(ObjectType::Report, Report::"Refresh Production Order", OnBeforeCalcRoutingsOrComponents, '', false, false)]
    local procedure OnBeforeCalcRoutingsOrComponents(var ProductionOrder: Record "Production Order"; var ProdOrderLine: Record "Prod. Order Line"; var CalcComponents: Boolean; var CalcRoutings: Boolean; var IsHandled: Boolean)
    var
        varproductionOrder: Record "Production Order";
    begin
        varproductionOrder.Reset();
        varproductionOrder.SetRange("No.", ProductionOrder."No.");
        varproductionOrder.SetAutoCalcFields("Is Substitute (?)");
        if varproductionOrder.FindSet() then begin
            if varproductionOrder."Is Substitute (?)" then begin
                CalcComponents := false;
            end;
        end;
    end;

    // "Mfg. Item Jnl.-Post Line"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Mfg. Item Jnl.-Post Line", OnPostFlushedConsumpOnAfterCalcQtyToPost, '', false, false)]
    local procedure OnPostFlushedConsumpOnAfterCalcQtyToPost(ProductionOrder: Record "Production Order"; ProdOrderLine: Record "Prod. Order Line"; ProdOrderComponent: Record "Prod. Order Component"; ActOutputQtyBase: Decimal; var QtyToPost: Decimal; var OldItemJournalLine: Record "Item Journal Line"; var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; var CompItem: Record Item)
    var
        MfgCostCalcMgt: Codeunit "Mfg. Cost Calculation Mgt.";
    begin
        //Case backward when output Qty base = Rounding(Remaining Qty. Base, 1) 
        QtyToPost := MfgCostCalcMgt.CalcActNeededQtyBase(ProdOrderLine, ProdOrderComponent, ActOutputQtyBase) / ProdOrderComponent."Qty. per Unit of Measure";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnSetupSplitJnlLineOnBeforeReallocateTrkgSpecification', '', false, false)]
    local procedure OnSetupSplitJnlLineOnBeforeReallocateTrkgSpecification(var ItemTrackingCode: Record "Item Tracking Code"; var TempTrackingSpecification: Record "Tracking Specification" temporary; var ItemJnlLine: Record "Item Journal Line"; var SignFactor: Integer; var IsHandled: Boolean)
    var
        LateBindingMgt: Codeunit "Late Binding Management";
        Bool: Boolean;
        CurrFieldValue: Decimal;
        CompareValue: Decimal;
        ManufacturingSetup: Record "Manufacturing Setup";
        Diff: Decimal;
    begin
        ManufacturingSetup.Get();
        if Not ManufacturingSetup."Use Diff Tolerance" then
            exit;
        IsHandled := true;
        if SignFactor * ItemJnlLine.Quantity < 0 then // Demand
            if ItemTrackingCode."SN Specific Tracking" or ItemTrackingCode."Lot Specific Tracking" then
                LateBindingMgt.ReallocateTrkgSpecification(TempTrackingSpecification);

        TempTrackingSpecification.CalcSums(
                          "Qty. to Handle (Base)", "Qty. to Invoice (Base)", "Qty. to Handle", "Qty. to Invoice");

        CurrFieldValue := TempTrackingSpecification."Qty. to Handle (Base)";
        CompareValue := SignFactor * ItemJnlLine."Quantity (Base)";
        if CurrFieldValue <> CompareValue then begin
            Bool := true;
            Diff := Abs(CurrFieldValue) - Abs(CompareValue);
            Diff := Abs(Diff);
            if Diff < ManufacturingSetup."Diff. Tolerance" then
                if ItemJnlLine."Entry Type" in [ItemJnlLine."Entry Type"::Consumption] then
                    ItemJnlLine.Validate(Quantity, SignFactor * CurrFieldValue);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Transfer", OnAfterCreateItemJnlLine, '', true, true)]
    local procedure OnAfterCreateItemJnlLine(var ItemJnlLine: Record "Item Journal Line"; TransLine: Record "Transfer Line"; DirectTransHeader: Record "Direct Trans. Header"; DirectTransLine: Record "Direct Trans. Line")
    begin
        ItemJnlLine."Reason Code" := TransLine."Reason Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", OnBeforePostItemJournalLine, '', true, true)]
    local procedure OnBeforePostItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferReceiptHeader: Record "Transfer Receipt Header"; TransferReceiptLine: Record "Transfer Receipt Line"; CommitIsSuppressed: Boolean; TransLine: Record "Transfer Line"; PostedWhseRcptHeader: Record "Posted Whse. Receipt Header")
    begin
        ItemJournalLine."Reason Code" := TransferLine."Reason Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", OnAfterCreateItemJnlLine, '', true, true)]
    local procedure OnAfterCreateItemJnlLineShipment(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferShipmentHeader: Record "Transfer Shipment Header"; TransferShipmentLine: Record "Transfer Shipment Line")
    begin
        ItemJournalLine."Reason Code" := TransferLine."Reason Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Shipment", 'OnBeforeOnRun', '', true, true)]
    local procedure OnBeforeOnRun(var InvtDocumentHeader: Record "Invt. Document Header"; var SuppressCommit: Boolean; var HideProgressWindow: Boolean)
    var
        InvtDocumentLines: Record "Invt. Document Line";
    begin
        if InvtDocumentHeader."Gen. Bus. Posting Group" <> 'SCRAP-CONS' then
            exit;
        Clear(InvtDocumentLines);
        InvtDocumentLines.SetRange("Document No.", InvtDocumentHeader."No.");
        InvtDocumentLines.SetRange("Reason Code", '');
        if InvtDocumentLines.Find('-') then
            Error('Reason code are required, please check the lines.');
    end;

    // "Carry Out Action"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Carry Out Action", 'OnInsertProdOrderWithReqLine', '', true, true)]
    local procedure OnInsertProdOrderWithReqLine(var ProductionOrder: Record "Production Order"; var RequisitionLine: Record "Requisition Line")
    begin
        ProductionOrder.Shift := RequisitionLine.Shift;
        ProductionOrder."Production Line" := RequisitionLine."Production Line";
        ProductionOrder."Capacity Line" := RequisitionLine."Capacity Line";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnAfterCreateReservEntryFor', '', true, true)]
    local procedure OnAfterCreateReservEntryFor(var ReservationEntry: Record "Reservation Entry"; Sign: Integer; ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForQtyPerUOM: Decimal; Quantity: Decimal; QuantityBase: Decimal; ForReservEntry: Record "Reservation Entry")
    begin
        if ForReservEntry."New Lot No." <> '' then
            ReservationEntry."New Lot No." := ForReservEntry."New Lot No.";
    end;

    // OnAfterChangeStatusOnProdOrder | "Prod. Order Status Management"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnAfterChangeStatusOnProdOrder', '', true, true)]
    local procedure OnAfterChangeStatusOnProdOrder(var ProdOrder: Record "Production Order"; var ToProdOrder: Record "Production Order"; NewStatus: Enum "Production Order Status"; NewPostingDate: Date; NewUpdateUnitCost: Boolean; var SuppressCommit: Boolean)
    var
        ProdOrder1: Record "Production Order";
        ProdMgt: Codeunit ProdOrderManagement_PQ;
    begin
        // if NewStatus in [NewStatus::"Firm Planned", NewStatus::Released] then begin
        if NewStatus in [NewStatus::"Firm Planned"] then begin
            ProdMgt.refreshProductionOrder(ToProdOrder);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnBeforeChangeStatusOnProdOrder', '', true, true)]
    local procedure OnBeforeChangeStatusOnProdOrder(var ProductionOrder: Record "Production Order"; NewStatus: Option Quote,Planned,"Firm Planned",Released,Finished; var IsHandled: Boolean; NewPostingDate: Date; NewUpdateUnitCost: Boolean)
    begin
        ProductionOrder.CalcFields("Is Subcon (?)");
        if ProductionOrder."Is Subcon (?)" then
            exit;
        if NewStatus = NewStatus::Released then begin
            if ProductionOrder."Preparing Status" <> ProductionOrder."Preparing Status"::Completed then
                Error('Error, Can''t change status preparing status must be completed');
        end;
        if NewStatus = NewStatus::Finished then begin
            if ProductionOrder."Production Status" <> ProductionOrder."Production Status"::Completed then
                Error('Error, Can''t change status cause production status must be completed');
        end;
    end;

    //OnAfterProdOrderLineInsert
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order Lines", 'OnAfterProdOrderLineInsert', '', true, true)]
    local procedure OnAfterProdOrderLineInsert(var ProdOrder: Record "Production Order"; var ProdOrderLine: Record "Prod. Order Line"; var NextProdOrderLineNo: Integer)
    begin
        if ProdOrder.Status in [ProdOrder.Status::"Firm Planned", ProdOrder.Status::Released] then begin
            // if ProdOrder.IsSplitProcess then begin
            //Insert Additional Output
            InsertAdditionalOutput(ProdOrderLine);
            //-
            // end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnBeforeCheckBeforeFinishProdOrder', '', false, false)]
    local procedure OnBeforeCheckBeforeFinishProdOrder(var ProductionOrder: Record "Production Order"; var IsHandled: Boolean)
    var
        ILE: Record "Item Ledger Entry";
        QualitytestHeader: Record QualityTestHeader_PQ;
        ProdOrderLine: Record "Prod. Order Line";
        ItemQualityReq: Record ItemQualityRequirement_PQ;
        Item: Record Item;
        QtyCalsum: Decimal;
    begin
        ItemQualityReq.Reset();
        ItemQualityReq.SetRange("Item No.", ProductionOrder."Source No.");
        if ItemQualityReq.Find('-') then begin
            Clear(Item);
            Item.SetRange("No.", ProductionOrder."Source No.");
            if Item.Find('-') then begin
                if Item."Inventory Posting Group" <> 'FG' then
                    exit;
            end;

            Clear(QualitytestHeader);
            QualitytestHeader.SetRange("Source No.", ProductionOrder."No.");
            QualitytestHeader.SetRange("Source Type", QualitytestHeader."Source Type"::"Output Journal");
            if QualitytestHeader.Find('-') then begin
                Clear(ProdOrderLine);
                ProdOrderLine.SetRange("Prod. Order No.", ProductionOrder."No.");
                if ProdOrderLine.FindFirst() then begin
                    Clear(ILE);
                    ILE.SetRange("Document No.", ProdOrderLine."Prod. Order No.");
                    ILE.SetRange("Item No.", QualitytestHeader."Item No.");
                    ILE.SetRange("Lot No.", QualitytestHeader."Lot No.");
                    ILE.SetRange("Entry Type", ILE."Entry Type"::Output);
                    if ILE.FindSet() then begin
                        ILE.CalcSums(Quantity);
                        QtyCalsum := ILE.Quantity;
                        if QtyCalsum <> QualitytestHeader."Qty. Actual Test" then
                            Error('Actual test Qty <> Output Qty., Please Check / Reconcile., [%1]', ProdOrderLine."Prod. Order No.");
                    end;
                    // if QualitytestHeader."Qty. Actual Test" <> ProdOrderLine."Finished Quantity" then
                    //     Error('Actual test Qty <> Output Qty., Please Check / Reconcile.');
                end;
            end else begin
                Error('Nothing to handle, QT for this order [%1] not exists.', ProductionOrder."No.");
            end;
        end;

        //Additional Check 
        checkProdOrderLine(ProductionOrder."No.");
    end;
    //-

    local procedure checkProdOrderLine(iProdOrderNo: Code[20])
    var
        ProdOrderLine: Record "Prod. Order Line";
        QtyILE: Decimal;
        QtyCLE: Decimal;
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        ManufacturingSetup.Get();
        if Not ManufacturingSetup."Validation Check Finish Order" then
            exit;
        Clear(ProdOrderLine);
        ProdOrderLine.SetRange("Prod. Order No.", iProdOrderNo);
        if ProdOrderLine.FindSet() then begin
            repeat
                Clear(QtyCLE);
                Clear(QtyILE);
                QtyCLE := checkCapacityLedgerEntry(ProdOrderLine."Prod. Order No.", ProdOrderLine."Line No.", ProdOrderLine."Item No.");
                QtyILE := checkItemLedgerEntry(ProdOrderLine."Prod. Order No.", ProdOrderLine."Line No.", ProdOrderLine."Item No.");
                if ProdOrderLine."Finished Quantity" = 0 then begin
                    if ((QtyILE <> 0) Or (QtyCLE <> 0)) then
                        Error('Can''t change status to finish prod. order, Please Check ILE Qty. | CLE Qty. [01]. Item No. %1, Line No. %2, Qty. ILE %3, Qty. CLE %4', ProdOrderLine."Item No.", ProdOrderLine."Line No.", QtyILE, QtyCLE);
                end else begin
                    if ((QtyILE = 0) Or (QtyCLE = 0)) then
                        Error('Can''t change status to finish prod. order, Please Check ILE Qty. | CLE Qty. [02]. Item No. %1, Line No. %2, Qty. ILE %3, Qty. CLE %4', ProdOrderLine."Item No.", ProdOrderLine."Line No.", QtyILE, QtyCLE);
                end;
            until ProdOrderLine.Next() = 0;
        end;
    end;

    local procedure checkCapacityLedgerEntry(iProdOrderNo: Code[20]; iLineNo: Integer; iItemNo: Code[20]): Decimal
    var
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
    begin
        Clear(CapacityLedgerEntry);
        CapacityLedgerEntry.Reset();
        CapacityLedgerEntry.SetRange("Order No.", iProdOrderNo);
        CapacityLedgerEntry.SetRange("Order Line No.", iLineNo);
        CapacityLedgerEntry.SetRange("Item No.", iItemNo);
        if CapacityLedgerEntry.FindSet() then begin
            CapacityLedgerEntry.CalcSums(Quantity);
            exit(CapacityLedgerEntry.Quantity);
        end;
        exit(0);
    end;

    local procedure checkItemLedgerEntry(iProdOrderNo: Code[20]; iLineNo: Integer; iItemNo: Code[20]): Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        Clear(ItemLedgerEntry);
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Order No.", iProdOrderNo);
        ItemLedgerEntry.SetRange("Order Line No.", iLineNo);
        ItemLedgerEntry.SetRange("Source No.", iItemNo);
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Consumption);
        if ItemLedgerEntry.FindSet() then begin
            ItemLedgerEntry.CalcSums(Quantity);
            exit(ItemLedgerEntry.Quantity);
        end;
        exit(0);
    end;

    local procedure InsertAdditionalOutput(iProdOrderLine: Record "Prod. Order Line")
    var
        additionalItemOutput: Record "Additional Item Output";
        ProdOrderLine2: Record "Prod. Order Line";
        LineNo: Integer;
        tempQty: Decimal;
    begin
        Clear(tempQty);
        Clear(additionalItemOutput);
        additionalItemOutput.SetRange("Item No.", iProdOrderLine."Item No.");
        if additionalItemOutput.FindSet() then begin
            LineNo := iProdOrderLine."Line No." + 10;
            repeat
                ProdOrderLine2.Init();
                ProdOrderLine2.Status := iProdOrderLine.Status;
                ProdOrderLine2."Prod. Order No." := iProdOrderLine."Prod. Order No.";
                ProdOrderLine2."Line No." := LineNo;
                ProdOrderLine2.Validate("Item No.", additionalItemOutput.Code);
                if additionalItemOutput."Quantity (Base) Per" <> 0 then begin
                    tempQty := additionalItemOutput."Quantity (Base) Per" * iProdOrderLine.Quantity;
                    tempQty := Round(tempQty, 1, '>');
                    ProdOrderLine2.Validate(Quantity, tempQty);
                end
                else begin
                    tempQty := Round((iProdOrderLine.Quantity), 1, '>');
                    ProdOrderLine2.Validate(Quantity, tempQty);
                end;
                ProdOrderLine2.Validate("Due Date", iProdOrderLine."Due Date");
                ProdOrderLine2.Validate("Location Code", iProdOrderLine."Location Code");
                ProdOrderLine2.Validate("Production BOM No.", additionalItemOutput."Production BOM No.");
                ProdOrderLine2.Validate("Routing No.", additionalItemOutput."Routing No.");
                ProdOrderLine2.UpdateDatetime();
                ProdOrderLine2.Insert(true);
                LineNo += 10;
            until additionalItemOutput.Next() = 0;
        end;
    end;

    //handling process TO (Transfer Order for Lot Block)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeCheckLotNoInfoNotBlocked', '', false, false)]
    local procedure OnBeforeCheckLotNoInfoNotBlocked(var ItemJnlLine2: Record "Item Journal Line"; var IsHandled: Boolean; var ItemTrackingSetup: Record "Item Tracking Setup"; var TrackingSpecification: Record "Tracking Specification")
    var
        LotNoInfo: Record "Lot No. Information";
        InventorySetup: Record "Inventory Setup";
        TransferOrder: Record "Transfer Header";
        ManufacturingSetup: Record "Manufacturing Setup";
        ItemPrefix: Text; //
    begin
        InventorySetup.Get();
        Clear(LotNoInfo);
        LotNoInfo.SetRange("Item No.", ItemJnlLine2."Item No.");
        LotNoInfo.SetRange("Lot No.", TrackingSpecification."Lot No.");
        if LotNoInfo.Find('-') then
            if LotNoInfo."CCS Status" IN [LotNoInfo."CCS Status"::Hold, LotNoInfo."CCS Status"::Restricted] then begin
                if (ItemJnlLine2."Document Type" in [ItemJnlLine2."Document Type"::"Transfer Shipment", ItemJnlLine2."Document Type"::"Transfer Receipt", ItemJnlLine2."Document Type"::"Direct Transfer"]) then begin
                    ManufacturingSetup.Get();
                    ManufacturingSetup.TestField("Finish Goods Location");
                    IsHandled := true;
                    Clear(TransferOrder);
                    TransferOrder.SetRange("No.", ItemJnlLine2."Order No.");
                    if TransferOrder.Find('-') then begin
                        //new validation added, 12 Sep 2025
                        ItemPrefix := CopyStr(ItemJnlLine2."Item No.", 1, 3);
                        if ItemPrefix = 'RMB' then
                            if TransferOrder."Transfer-to Code" <> 'QC' then
                                IsHandled := false;
                        //-
                        if TransferOrder."Transfer-to Code" = ManufacturingSetup."Finish Goods Location" then
                            IsHandled := false;
                    end;
                end;
                //handling output
                if ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Output then
                    IsHandled := true;
                //-
                if ItemJnlLine2."Journal Template Name" = InventorySetup."QC Auto Reclass Template Name" then
                    IsHandled := true;
            end;
    end;

    // "Calculate Plan - Plan. Wksh."
    [EventSubscriber(ObjectType::Report, Report::"Calculate Plan - Plan. Wksh.", OnAfterItemOnPostDataItem, '', false, false)]
    local procedure OnAfterItemOnPostDataItem(var CurrTemplateName: Code[10]; var CurrWorksheetName: Code[10])
    var
        RequisitionLine: Record "Requisition Line";
        Item: Record Item;
        StringContain: Text[100];
        TempQTY: Decimal;
        ManufacturingSetup: Record "Manufacturing Setup";
        ProdCompLine: Record "Planning Component";
        TempQtyComp: Decimal;
    begin
        ManufacturingSetup.Get();
        Clear(RequisitionLine);
        RequisitionLine.SetRange("Worksheet Template Name", CurrTemplateName);
        RequisitionLine.SetRange("Journal Batch Name", CurrWorksheetName);
        RequisitionLine.SetRange(Type, RequisitionLine.Type::Item);
        if RequisitionLine.FindSet() then begin
            repeat
                Clear(StringContain);
                StringContain := RequisitionLine."No.";
                Clear(Item);
                Item.SetRange("No.", RequisitionLine."No.");
                Item.SetFilter("Item Category Code", 'AST*');
                if Item.Find('-') then begin
                    if StringContain.Contains('FSB') then begin
                        TempQTY := RequisitionLine.Quantity;
                        if ManufacturingSetup."Buffer Qty. Planning Worksheet" > 0 then begin
                            TempQTY := TempQTY * ManufacturingSetup."Buffer Qty. Planning Worksheet" / 100;
                            TempQTY += RequisitionLine.Quantity;
                            RequisitionLine.Validate(Quantity, TempQTY);
                            RequisitionLine.Modify();
                        end;
                    end;
                end;

                if RequisitionLine."Ref. Order Type" = RequisitionLine."Ref. Order Type"::"Prod. Order" then begin
                    Clear(ProdCompLine);
                    ProdCompLine.Reset();
                    ProdCompLine.SetRange("Worksheet Template Name", CurrTemplateName);
                    ProdCompLine.SetRange("Worksheet Batch Name", CurrWorksheetName);
                    ProdCompLine.SetRange("Worksheet Line No.", RequisitionLine."Line No.");
                    if ProdCompLine.FindSet() then begin
                        repeat
                            if ManufacturingSetup."Buffer Qty. Planning Worksheet" > 0 then begin
                                Clear(TempQtyComp);
                                TempQtyComp := ProdCompLine."Expected Quantity";
                                TempQtyComp := TempQtyComp * ManufacturingSetup."Buffer Qty. Transfer" / 100;
                                TempQtyComp := Round(TempQtyComp, 1, '>');
                                ProdCompLine.Validate("Expected Quantity", TempQtyComp);
                                ProdCompLine.Validate(Quantity, TempQtyComp);
                                ProdCompLine.Modify();
                            end;
                        until ProdCompLine.Next() = 0;
                    end;
                end;
            until RequisitionLine.Next() = 0;
        end;
    end;
    //  Clear(TempQTY);
    //         TempQTY := prodComponentLine."Expected Quantity";
    //         if ManufacturingSetup."Buffer Qty. Transfer" > 0 then begin
    //             TempQTY := TempQTY * ManufacturingSetup."Buffer Qty. Transfer" / 100;
    //             TempQTY += prodComponentLine."Expected Quantity";
    //         end;

    // OnTransferBOMProcessItemOnBeforeSetFlushingMethod //"Calculate Prod. Order"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", 'OnTransferBOMProcessItemOnBeforeSetFlushingMethod', '', false, false)]
    local procedure OnTransferBOMProcessItemOnBeforeSetFlushingMethod(var ProdOrderLine: Record "Prod. Order Line"; var ComponentSKU: Record "Stockkeeping Unit"; var ProdOrderComp: Record "Prod. Order Component"; ProdBOMLine: Record "Production BOM Line"; var IsHandled: Boolean)
    var
        maunfacturingsetup: Record "Manufacturing Setup";
    begin
        if maunfacturingsetup.Get() then begin
            if maunfacturingsetup."Default Flushing Method Comp." <> maunfacturingsetup."Default Flushing Method Comp."::" " then begin
                ComponentSKU."Flushing Method" := maunfacturingsetup."Default Flushing Method Comp.";
            end;
        end;
    end;

    // OnBeforePurchOrderHeaderInsert | "Req. Wksh.-Make Order"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnAfterInsertPurchOrderHeader', '', false, false)]
    local procedure OnAfterInsertPurchOrderHeader(var RequisitionLine: Record "Requisition Line"; var PurchaseOrderHeader: Record "Purchase Header"; CommitIsSuppressed: Boolean; SpecialOrder: Boolean)
    begin
        PurchaseOrderHeader."Order Date" := RequisitionLine."Order Date";
        PurchaseOrderHeader."Posting Date" := RequisitionLine."Order Date";
        PurchaseOrderHeader."Document Date" := RequisitionLine."Order Date";
    end;
}
