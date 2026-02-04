codeunit 50718 ProdOrderManagement_PQ
{
    Permissions = tabledata "Item Ledger Entry" = R,
    tabledata "Capacity Ledger Entry" = rmid;
    // "Planning Line Management"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Planning Line Management", OnTransferRoutingLineOnBeforeCalcRoutingCostPerUnit, '', false, false)]
    local procedure OnTransferRoutingLineOnBeforeCalcRoutingCostPerUnit(var PlanningRoutingLine: Record "Planning Routing Line"; ReqLine: Record "Requisition Line"; RoutingLine: Record "Routing Line")
    begin
        if RoutingLine."Fix Run Time" then begin
            if RoutingLine."Fix Time" <> 0 then begin
                PlanningRoutingLine."Run Time" := RoutingLine."Fix Time" / PlanningRoutingLine."Output Quantity";
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order Lines", OnBeforeCheckMultiLevelStructure, '', false, false)]
    local procedure OnBeforeCheckMultiLevelStructure(ProductionOrder: Record "Production Order"; Direction: Option Forward,Backward; var IsHandled: Boolean)
    begin
        // IsHandled := true;
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Prod. Order Routing Line", OnAfterCopyFromRoutingLine, '', false, false)]
    // local procedure OnAfterCopyFromRoutingLine(var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; RoutingLine: Record "Routing Line")
    // begin
    //     ProdOrderRoutingLine."Fixed Run Time" := RoutingLine."Fix Run Time";
    //     // if ProdOrderRoutingLine."Fixed Run Time" then
    //     //     ProdOrderRoutingLine."Run Time" := RoutingLine."Fix Time";
    // end;

    // "Calculate Prod. Order"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", OnTransferRoutingOnBeforeCalcRoutingCostPerUnit, '', false, false)]
    procedure OnTransferRoutingOnBeforeCalcRoutingCostPerUnit(var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; ProdOrderLine: Record "Prod. Order Line"; RoutingLine: Record "Routing Line")
    begin
        if RoutingLine."Fix Run Time" then begin
            if RoutingLine."Fix Time" <> 0 then begin
                ProdOrderRoutingLine."Run Time" := RoutingLine."Fix Time" / ProdOrderLine.Quantity;
            end;
        end;
    end;


    /* [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnBeforePostOutput, '', false, false)]
    local procedure OnBeforePostOutput(var ItemJnlLine: Record "Item Journal Line")
    var
        workcenterUtilityCost: Record "Work Center Utility Cost New";
        laborCost: Decimal;
        workcenterInderectCost: Record "Work Center Indirect Cost";
        utilityCost: Decimal;
        indirectCost: Decimal;
    begin
        Clear(utilityCost);
        Clear(indirectCost);
        Clear(laborCost);

        if ItemJnlLine.Type = ItemJnlLine.Type::"Work Center" then begin
            if ItemJnlLine."No." = '' then
                exit;
        end;

        if ItemJnlLine."Wait Time" <> 0 then begin
            ItemJnlLine."Run Time" := ItemJnlLine."Run Time" - ItemJnlLine."Wait Time";
            ItemJnlLine.Validate("Run Time");
        end;

        Clear(laborCost);
        ItemJnlLine."Concurrent Capacity" := 1;
        //overhead cost (Work center) per-item
        if ItemJnlLine.Type = ItemJnlLine.Type::"Work Center" then begin
            Clear(workcenterUtilityCost);
            workcenterUtilityCost.Reset();
            workcenterUtilityCost.SetRange("Work Center", ItemJnlLine."No.");
            workcenterUtilityCost.SetRange("Item No.", ItemJnlLine."Item No.");
            workcenterUtilityCost.SetFilter("Starting Date", '<=%1', ItemJnlLine."Posting Date");
            workcenterUtilityCost.SetFilter("Ending Date", '>=%1|%2', ItemJnlLine."Posting Date", 0D);
            if workcenterUtilityCost.FindSet() then begin
                workcenterUtilityCost.CalcSums("Unit Cost");
                if workcenterUtilityCost."Unit Cost" <> 0 then begin
                    utilityCost := workcenterUtilityCost."Unit Cost";
                    ItemJnlLine."Utility Cost" := workcenterUtilityCost."Unit Cost";
                    ItemJnlLine."Overhead Rate" := ItemJnlLine."Overhead Rate" + workcenterUtilityCost."Unit Cost";
                end;
            end;
            //get info labor cost 
            laborCost := getLaborCost(ItemJnlLine."No.", ItemJnlLine."Posting Date", ItemJnlLine."Cost Category");
            ItemJnlLine."Labor Cost" := laborCost;
            //-
            //get info indirect cost 
            Clear(workcenterInderectCost);
            workcenterInderectCost.Reset();
            workcenterInderectCost.SetRange("Work Center", ItemJnlLine."No.");
            workcenterInderectCost.SetFilter("Starting Date", '<=%1', ItemJnlLine."Posting Date");
            workcenterInderectCost.SetFilter("Ending Date", '>=%1|%2', ItemJnlLine."Posting Date", 0D);
            if workcenterInderectCost.FindSet() then begin
                workcenterInderectCost.CalcSums("Unit Cost");
                indirectCost := workcenterInderectCost."Unit Cost";
                ItemJnlLine."Overhead Rate" += workcenterInderectCost."Unit Cost";
                ItemJnlLine."Add. Indirect Cost" := workcenterInderectCost."Unit Cost";
            end;
            //-
        end;

        //Added at 28 Nov 2024, validation check cost value
        if laborCost = 0 then
            Error('Error, Labor cost can''t be zero or empty, check journal line at line no [%1] and work center [%2]', ItemJnlLine."Line No.", ItemJnlLine."No.");
        if indirectCost = 0 then
            Error('Error, Indirect cost can''t be zero or empty, check journal line at line no [%1] and work center [%2]', ItemJnlLine."Line No.", ItemJnlLine."No.");
        if utilityCost = 0 then
            Error('Error, Utility cost can''t be zero or empty, check journal line at line no [%1] and work center [%2]', ItemJnlLine."Line No.", ItemJnlLine."No.");
        //-

        //Added at 28 Nov 2024, validation check transaction consumption on prod. order no
        checkTransactionConsumption(ItemJnlLine."Order No.");
        //- 

    end;
 */
    local procedure checkTransactionConsumption(iProdOrderNo: Code[20])
    var
        Text001: Text;
        ILE: Record "Item Ledger Entry";
    begin
        Text001 := 'Error, Consumption process is not available on Prod Order No. : ';
        Clear(ILE);
        ILE.Reset();
        ILE.SetRange("Document No.", iProdOrderNo);
        ILE.SetRange("Entry Type", ILE."Entry Type"::Consumption);
        if not ILE.FindSet() then
            Error(Text001 + ' [%1]', iProdOrderNo);
    end;

    /*     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnBeforeInsertItemLedgEntry, '', false, false)]
        local procedure OnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean; OldItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLineOrigin: Record "Item Journal Line")
        begin
            ItemLedgerEntry.Remark := ItemJournalLine.Remark;
        end; */

    /* [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnBeforeCalcDirAndIndirCostAmts, '', false, false)]
    local procedure OnBeforeCalcDirAndIndirCostAmts(var ItemJournalLine: Record "Item Journal Line"; var DirCostAmt: Decimal; var IndirCostAmt: Decimal; CapQty: Decimal; var IsHandled: Boolean)
    var
        CostAmt: Decimal;
    begin
        //New add, by rnd, request frm chz-san, 05/April/24
        // if ItemJournalLine."Labor Capacity" <> 0 then
        CapQty := ItemJournalLine."Labor Capacity";
        //-
        if ItemJournalLine."Labor Cost" <> 0 then begin
            CostAmt := CapQty * ItemJournalLine."Labor Cost" * ItemJournalLine."Run Time";
            // CostAmt := ItemJournalLine."Labor Cost" * ItemJournalLine."Run Time";
            DirCostAmt := CostAmt;
            // IndirCostAmt := (ItemJournalLine."Overhead Rate" * CapQty * ItemJournalLine."Run Time");
            IndirCostAmt := (ItemJournalLine."Overhead Rate" * ItemJournalLine."Run Time");
            IsHandled := true;
        end else begin
            CostAmt := 0;
            DirCostAmt := CostAmt;
            IndirCostAmt := (ItemJournalLine."Overhead Rate" * ItemJournalLine."Run Time");
            IsHandled := true;
        end;
    end; */

    /* [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnBeforeInsertCapLedgEntry, '', false, false)]
    local procedure OnBeforeInsertCapLedgEntry(var CapLedgEntry: Record "Capacity Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    var
        CostAmt: Decimal;
        CapQty: Decimal;
        IndirCostAmt: Decimal;
        DirCostAmt: Decimal;
    begin
        // CapLedgEntry.Operator := ItemJournalLine.Operator;
        // CapLedgEntry."Cost Per-Operator" := ItemJournalLine."Cost Per-Operator";
        CapLedgEntry."Labor Capacity" := ItemJournalLine."Labor Capacity";
        CapLedgEntry.Temperature := ItemJournalLine.Temperature;
        CapLedgEntry."Wait Time" := ItemJournalLine."Wait Time";
        CapLedgEntry."Utility Cost" := ItemJournalLine."Utility Cost";
        CapLedgEntry."Labor Cost" := ItemJournalLine."Labor Cost";
        CapLedgEntry."Cost Category" := ItemJournalLine."Cost Category";
        CapLedgEntry.Remark := ItemJournalLine.Remark;
        CapLedgEntry."Add. Indirect Cost" := ItemJournalLine."Add. Indirect Cost";
    end; */

    /*
     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Output Jnl.-Expl. Route", OnBeforeOutputItemJnlLineInsert, '', false, false)]
     local procedure OnBeforeOutputItemJnlLineInsert(var ItemJournalLine: Record "Item Journal Line"; LastOperation: Boolean)
     var
         workcenterUtilityCost: Record "Work Centeter Utility Cost New";
         laborCost: Decimal;
     begin
         Clear(laborCost);
         ItemJournalLine."Concurrent Capacity" := 1;
         //overhead cost (Work center) per-item
         if ItemJournalLine.Type = ItemJournalLine.Type::"Work Center" then begin
             Clear(workcenterUtilityCost);
             workcenterUtilityCost.Reset();
             workcenterUtilityCost.SetRange("Work Center", ItemJournalLine."No.");
             workcenterUtilityCost.SetRange("Item No.", ItemJournalLine."Item No.");
             if workcenterUtilityCost.FindSet() then begin
                 workcenterUtilityCost.CalcSums("Unit Cost");
                 if workcenterUtilityCost."Unit Cost" <> 0 then begin
                     ItemJournalLine."Utility Cost" := workcenterUtilityCost."Unit Cost";
                     ItemJournalLine."Overhead Rate" += workcenterUtilityCost."Unit Cost";
                 end;
             end;
             //get info labor cost 
             laborCost := getLaborCost(ItemJournalLine."No.", ItemJournalLine."Posting Date", ItemJournalLine."Cost Category");
             ItemJournalLine."Labor Cost" := laborCost;
             //-
         end;
     end;
     */

    /* local procedure getLaborCost(iWorkCenter: Code[20]; iPostingDate: Date; iCostCategory: Enum "Cost Category"): Decimal
    var
        laborCost: Record "Work Center Labor Cost";
        o_result: Decimal;
    begin
        Clear(o_result);
        Clear(laborCost);
        laborCost.Reset();
        laborCost.SetRange("Work Center", iWorkCenter);
        laborCost.SetFilter("Starting Date", '<=%1', iPostingDate);
        laborCost.SetFilter("Ending Date", '>=%1|%2', iPostingDate, 0D);
        laborCost.SetRange("Cost Type", iCostCategory);
        if laborCost.FindSet() then begin
            o_result := laborCost."Unit Cost";
        end;
        exit(o_result);
    end;
 */
    local procedure getLocationFroManfSetup(): Text
    var
        ManufacturingSetup: Record "Manufacturing Setup";
        locationFrom: Text;
    begin
        if ManufacturingSetup.Get() then begin
            locationFrom := ManufacturingSetup."Components at Location";
            exit(locationFrom);
        end;
        exit('');
    end;

    //Create transfer order 
    procedure createTransferOrderFromProdComponent(var prodOrderComponent: Record "Prod. Order Component"; iProdOrderNo: Code[20]; IsDirectTransfer: Boolean; iInstransitCode: Text; iTransferFromCode: Code[20])
    var
        TransferHeader: Record "Transfer Header";
        TransferLines: Record "Transfer Line";
        ManufacturingSetup: Record "Manufacturing Setup";
        ProductionOrder: Record "Production Order";
        ProductionOrderLine: Record "Prod. Order Line";
        locationFrom: Text;
        LocationTo: Text;
        LineNo: Integer;
        IntransitLocation: Code[20];
        Locations: Record Location;
        StringContain: Text;
        FSBSubcon: Boolean;
        counter: Integer;
    begin
        Clear(counter);
        Clear(ProductionOrder);
        ProductionOrder.Reset();
        ProductionOrder.SetRange("No.", iProdOrderNo);
        if not ProductionOrder.Find('-') then
            Error('Production Order No not found.');

        //get in-transit location 
        Clear(IntransitLocation);
        Clear(Locations);
        Locations.Reset();
        Locations.SetRange("Use As In-Transit", true);
        if Locations.Find('-') then
            IntransitLocation := Locations.Code;
        //-

        Clear(ProductionOrderLine);
        ProductionOrderLine.Reset();
        ProductionOrderLine.SetRange("Prod. Order No.", iProdOrderNo);
        if ProductionOrderLine.FindFirst() then;

        LocationTo := ProductionOrder."Location Code";
        if ManufacturingSetup.Get() then
            locationFrom := ManufacturingSetup."Default Source Location Comp.";
        if iTransferFromCode <> '' then
            locationFrom := iTransferFromCode;

        //Insert transfer Order Header 
        Clear(TransferHeader);
        TransferHeader.Insert(true);

        TransferHeader.IsFromProdOrder := true;
        TransferHeader."Prod. Order No." := iProdOrderNo;
        TransferHeader."Transfer-from Code" := locationFrom;
        TransferHeader."Transfer-to Code" := LocationTo;
        TransferHeader."Direct Transfer" := IsDirectTransfer;
        TransferHeader."In-Transit Code" := IntransitLocation;

        TransferHeader."Posting Date" := WorkDate;
        TransferHeader."Shipment Date" := WorkDate;

        if ProductionOrder."Starting Date" > WorkDate then begin
            TransferHeader."Posting Date" := CalcDate('-1D', WorkDate);
            TransferHeader."Shipment Date" := CalcDate('-1D', WorkDate);
        end else begin
            TransferHeader."Posting Date" := CalcDate('-1D', ProductionOrderLine."Starting Date");
            TransferHeader."Shipment Date" := CalcDate('-1D', ProductionOrderLine."Starting Date");
        end;

        TransferHeader."Shortcut Dimension 1 Code" := ProductionOrder."Shortcut Dimension 1 Code";
        TransferHeader."Shortcut Dimension 2 Code" := ProductionOrder."Shortcut Dimension 2 Code";
        TransferHeader.Modify(true);

        //insert Transfer Line
        LineNo := 1000;
        repeat
            Clear(StringContain);
            StringContain := prodOrderComponent."Item No.";
            if StringContain.Contains('FSB') then begin
                FSBSubcon := checkFSBItemSubCon(prodOrderComponent."Item No.");
                if FSBSubcon then begin
                    CreateTransferLine(TransferHeader, prodOrderComponent, LineNo);
                    counter += 1;
                end;
            end else begin
                prodOrderComponent.CalcFields("Inventory Posting Group");
                if prodOrderComponent."Inventory Posting Group" = 'RM' then begin
                    CreateTransferLine(TransferHeader, prodOrderComponent, LineNo);
                    counter += 1;
                end;
            end;
            LineNo += 10;
        until prodOrderComponent.Next() = 0;

        if counter = 0 then
            Error('Nothing to handle.');

        ShowCreatedDocument(TransferHeader);
    end;

    local procedure checkFSBItemSubCon(iItemNo: Code[20]): Boolean
    var
        Check: Boolean;
        Item: Record Item;
    begin
        Clear(Item);
        Item.Reset();
        Item.SetRange("No.", iItemNo);
        Item.SetRange("Is Subcon (?)", true);
        if Item.Find('-') then
            exit(true);
    end;

    local procedure ShowCreatedDocument(var itransferHeader: Record "Transfer Header")
    var
        OfficeMgt: Codeunit "Office Management";
        TranferOrderPage: Page "Transfer Order";
        OpenPage: Boolean;
        IsHandled: Boolean;
        OpenNewTransferOrderQst: Label 'The document transfer order has been generated. Do you want to open the document?', Comment = '%1 = No. of the document.';
    begin
        IsHandled := false;

        OpenPage := Confirm(StrSubstNo(OpenNewTransferOrderQst, itransferHeader."No."), true);
        if OpenPage then begin
            Clear(TranferOrderPage);
            TranferOrderPage.SetRecord(itransferHeader);
            TranferOrderPage.Run();
        end;
    end;

    procedure CreateTransferLine(var TransferHeader: Record "Transfer Header"; var prodComponentLine: Record "Prod. Order Component"; iLineNo: Integer)
    var
        TransferLine: Record "Transfer Line";
        Quantity: Decimal;
        QuantityBase: Decimal;
        ManufacturingSetup: Record "Manufacturing Setup";
        TempQTY: Decimal;
    begin
        ManufacturingSetup.Get();
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        TransferLine.SetRange("Prod. Order No.", prodComponentLine."Prod. Order No.");
        TransferLine.SetRange("Prod. Order Line No.", prodComponentLine."Prod. Order Line No.");
        TransferLine.SetRange("Prod. Comp. Line No.", prodComponentLine."Line No.");
        TransferLine.SetRange("Item No.", prodComponentLine."Item No.");

        //round-up qty 
        //prodComponentLine."Expected Quantity" := Round(prodComponentLine."Expected Quantity", 1, '>');
        //-

        if not TransferLine.FindSet then begin
            Clear(TransferLine);
            TransferLine.Validate("Line No.", iLineNo);
            TransferLine.Validate("Document No.", TransferHeader."No.");
            TransferLine.Validate("Item No.", prodComponentLine."Item No.");
            Clear(TempQTY);
            TempQTY := prodComponentLine."Expected Quantity";
            if ManufacturingSetup."Buffer Qty. Transfer" > 0 then begin
                TempQTY := TempQTY * ManufacturingSetup."Buffer Qty. Transfer" / 100;
                TempQTY += prodComponentLine."Expected Quantity";
                TempQTY := Round(TempQTY, 1, '>');
            end;
            TransferLine.Validate(Quantity, TempQTY);

            TransferLine.Validate("Prod. Order No.", prodComponentLine."Prod. Order No.");
            TransferLine.Validate("Prod. Order Line No.", prodComponentLine."Prod. Order Line No.");
            TransferLine.Validate("Shortcut Dimension 1 Code", TransferHeader."Shortcut Dimension 1 Code");
            TransferLine.Validate("Shortcut Dimension 2 Code", TransferHeader."Shortcut Dimension 2 Code");

            TransferLine.Validate("Prod. Comp. Line No.", prodComponentLine."Line No.");

            TransferLine.Validate("Shipment Date", TransferHeader."Shipment Date");
            TransferLine.Insert(true);

            Quantity := TransferLine.Quantity;
            QuantityBase := TransferLine."Quantity (Base)";

            // CreateReservationEntry(TransferLine, NSIDNProdTransferLine);
        end else begin
            Clear(TempQTY);
            TempQTY := prodComponentLine."Expected Quantity";
            if ManufacturingSetup."Buffer Qty. Transfer" > 0 then begin
                TempQTY := TempQTY * ManufacturingSetup."Buffer Qty. Transfer" / 100;
                TempQTY += prodComponentLine."Expected Quantity";
            end;
            Quantity := TransferLine.Quantity + TempQTY;
            QuantityBase := TransferLine."Quantity (Base)" + TempQTY;

            // DeleteReservationEntry(TransferLine);

            TransferLine.Validate(Quantity, Quantity);
            TransferLine.Modify(true);

            // CreateReservationEntry(TransferLine, NSIDNProdTransferLine);
        end;
    end;


    procedure VerifyNoInboundWhseHandlingOnLocation(LocationCode: Code[10])
    var
        Location: Record Location;
    begin
        if not Location.Get(LocationCode) then
            exit;

        Location.TestField("Require Put-away", false);
        Location.TestField("Require Receive", false);
    end;

    procedure VerifyNoOutboundWhseHandlingOnLocation(LocationCode: Code[10])
    var
        Location: Record Location;
    begin
        if not Location.Get(LocationCode) then
            exit;

        Location.TestField("Require Pick", false);
        Location.TestField("Require Shipment", false);
    end;

    local procedure createTrasnferLine()
    begin

    end;

    // Refresh production order
    procedure refreshProductionOrder(var iProductionOrder: Record "Production Order")
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrder: Record "Production Order";
        ProdOrderStatusMgt: Codeunit "Prod. Order Status Management";
        RoutingNo: Code[20];
        ErrorOccured: Boolean;
        IsHandled: Boolean;
    begin
        InitRefresh(iProductionOrder);

        Window.Open(
                 Text000 +
                 Text001 +
                 Text002);

        if iProductionOrder.Status = iProductionOrder.Status::Finished then begin
            Error('Can''t refresh status production = Finish.');
        end;

        iProductionOrder.TestField("Due Date");

        if CalcLines and IsComponentPicked(iProductionOrder) then
            if not Confirm(StrSubstNo(DeletePickedLinesQst, iProductionOrder."No.")) then begin
                Error('Error Nothing to handle.');
            end;

        Window.Update(1, iProductionOrder.Status);
        Window.Update(2, iProductionOrder."No.");

        RoutingNo := GetRoutingNo(iProductionOrder);
        UpdateRoutingNo(iProductionOrder, RoutingNo, iProductionOrder);

        ProdOrderLine.LockTable();
        OnBeforeCalcProdOrder(iProductionOrder, Direction);
        CheckReservationExist(iProductionOrder);

        if CalcLines then begin
            OnBeforeCalcProdOrderLines(iProductionOrder, Direction, CalcLines, CalcRoutings, CalcComponents, IsHandled, ErrorOccured);
            if not IsHandled then
                if not CreateProdOrderLines.Copy(iProductionOrder, Direction, iProductionOrder."Variant Code", false) then
                    ErrorOccured := true;
        end else begin
            ProdOrderLine.SetRange(Status, iProductionOrder.Status);
            ProdOrderLine.SetRange("Prod. Order No.", iProductionOrder."No.");
            IsHandled := false;
            OnBeforeCalcRoutingsOrComponents(iProductionOrder, ProdOrderLine, CalcComponents, CalcRoutings, IsHandled);
            if not IsHandled then
                if CalcRoutings or CalcComponents then begin
                    if ProdOrderLine.Find('-') then
                        repeat
                            if CalcRoutings then begin
                                ProdOrderRtngLine.SetRange(Status, iProductionOrder.Status);
                                ProdOrderRtngLine.SetRange("Prod. Order No.", iProductionOrder."No.");
                                ProdOrderRtngLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
                                ProdOrderRtngLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
                                if ProdOrderRtngLine.FindSet(true) then
                                    repeat
                                        ProdOrderRtngLine.SetSkipUpdateOfCompBinCodes(true);
                                        ProdOrderRtngLine.Delete(true);
                                    until ProdOrderRtngLine.Next() = 0;
                            end;
                            if CalcComponents then begin
                                ProdOrderComp.SetRange(Status, iProductionOrder.Status);
                                ProdOrderComp.SetRange("Prod. Order No.", iProductionOrder."No.");
                                ProdOrderComp.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
                                ProdOrderComp.DeleteAll(true);
                            end;
                        until ProdOrderLine.Next() = 0;
                    if ProdOrderLine.Find('-') then
                        repeat
                            if CalcComponents then
                                CheckProductionBOMStatus(ProdOrderLine."Production BOM No.", ProdOrderLine."Production BOM Version Code");
                            if CalcRoutings then
                                CheckRoutingStatus(ProdOrderLine."Routing No.", ProdOrderLine."Routing Version Code");
                            ProdOrderLine."Due Date" := iProductionOrder."Due Date";
                            IsHandled := false;
                            OnBeforeCalcProdOrderLine(ProdOrderLine, Direction, CalcLines, CalcRoutings, CalcComponents, IsHandled, ErrorOccured);
                            if not IsHandled then
                                if not CalcProdOrder.Calculate(ProdOrderLine, Direction, CalcRoutings, CalcComponents, false, false) then
                                    ErrorOccured := true;
                        until ProdOrderLine.Next() = 0;
                end;
        end;
        OnProductionOrderOnAfterGetRecordOnAfterCalcRoutingsOrComponents(iProductionOrder, CalcLines, CalcRoutings, CalcComponents, ErrorOccured);

        if (Direction = Direction::Backward) and (iProductionOrder."Source Type" = iProductionOrder."Source Type"::Family) then begin
            iProductionOrder.SetUpdateEndDate();
            iProductionOrder.Validate(iProductionOrder."Due Date", iProductionOrder."Due Date");
        end;

        if iProductionOrder.Status = iProductionOrder.Status::Released then begin
            ProdOrderStatusMgt.FlushProdOrder(iProductionOrder, iProductionOrder.Status, WorkDate());
            WhseProdRelease.Release(iProductionOrder);
            if CreateInbRqst then
                WhseOutputProdRelease.Release(iProductionOrder);
        end;

        OnAfterRefreshProdOrder(iProductionOrder, ErrorOccured);
        if ErrorOccured then
            Message(Text005, ProdOrder.TableCaption(), ProdOrderLine.FieldCaption("Bin Code"));
    end;

    procedure findCurrWorkDate(iStartDate: Date): Date
    var
        Check: Boolean;
        BaseCalendarChange: Record "Base Calendar Change";
        DateUpd: Date;
        Day: Text;
        CheckWeekly: Boolean;
    begin
        //Check Base Calendar
        Check := true;
        Clear(DateUpd);
        DateUpd := iStartDate;
        while Check do begin
            Clear(BaseCalendarChange);
            BaseCalendarChange.SetRange(Date, DateUpd);
            BaseCalendarChange.SetRange(Nonworking, true);
            if BaseCalendarChange.Find('-') then
                DateUpd := DateUpd + 1
            else begin
                //check recurring non working day
                Clear(Day);
                Day := getDayofWeek(DateUpd);
                Clear(BaseCalendarChange);
                BaseCalendarChange.Reset();
                BaseCalendarChange.SetRange("Recurring System", BaseCalendarChange."Recurring System"::"Weekly Recurring");
                BaseCalendarChange.SetRange(Nonworking, true);
                if BaseCalendarChange.FindSet() then begin
                    Clear(CheckWeekly);
                    repeat
                        if Format(BaseCalendarChange.Day) = Day then begin
                            DateUpd := DateUpd + 1;
                            CheckWeekly := true;
                        end;
                    until BaseCalendarChange.Next() = 0;
                    if not CheckWeekly then
                        Check := false;
                end else begin
                    Check := false;
                end;
            end;
        end;
        exit(DateUpd);
    end;

    local procedure getDayofWeek(iDate: Date): Text
    var
        DayOfWeek: Integer;
        Day: Text;
    begin
        DayOfWeek := Date2DWY(iDate, 1);
        case DayOfWeek of
            1:
                begin
                    Day := 'Monday';
                end;
            2:
                begin
                    Day := 'Tuesday';
                end;
            3:
                begin
                    Day := 'Wednesday';
                end;
            4:
                begin
                    Day := 'Thursday';
                end;
            5:
                begin
                    Day := 'Friday';
                end;
            6:
                begin
                    Day := 'Saturday';
                end;
            7:
                begin
                    Day := 'Sunday';
                end;
        end;
        exit(Day);
    end;

    local procedure InitRefresh(var iProdOrder: Record "Production Order")
    begin
        CalcLines := true;
        CalcRoutings := true;
        CalcComponents := true;
        Direction := Direction::Backward;
    end;

    var
        Text000: Label 'Refreshing Production Orders...\\';
        Text001: Label 'Status         #1##########\';
        Text002: Label 'No.            #2##########';
        Text003: Label 'Routings must be calculated, when lines are calculated.';
        Text004: Label 'Component Need must be calculated, when lines are calculated.';
        CalcProdOrder: Codeunit "Calculate Prod. Order";
        CreateProdOrderLines: Codeunit "Create Prod. Order Lines";
        WhseProdRelease: Codeunit "Whse.-Production Release";
        WhseOutputProdRelease: Codeunit "Whse.-Output Prod. Release";
        Window: Dialog;
        Direction: Option Forward,Backward;
        CalcLines: Boolean;
        CalcRoutings: Boolean;
        CalcComponents: Boolean;
        CreateInbRqst: Boolean;
        Text005: Label 'One or more of the lines on this %1 require special warehouse handling. The %2 for these lines has been set to blank.';
        DeletePickedLinesQst: Label 'Components for production order %1 have already been picked. Do you want to continue?', Comment = 'Production order no.: Components for production order 101001 have already been picked. Do you want to continue?';

    local procedure CheckReservationExist(var iProductionOrder: Record "Production Order")
    var
        ProdOrderLine2: Record "Prod. Order Line";
        ProdOrderComp2: Record "Prod. Order Component";
    begin
        // Not allowed to refresh if reservations exist
        if not (CalcLines or CalcComponents) then
            exit;

        ProdOrderLine2.SetRange(Status, iProductionOrder.Status);
        ProdOrderLine2.SetRange("Prod. Order No.", iProductionOrder."No.");
        if ProdOrderLine2.Find('-') then
            repeat
                if CalcLines then begin
                    ProdOrderLine2.CalcFields("Reserved Qty. (Base)");
                    if ProdOrderLine2."Reserved Qty. (Base)" <> 0 then
                        if ShouldCheckReservedQty(
                             ProdOrderLine2."Prod. Order No.", 0, Database::"Prod. Order Line",
                             ProdOrderLine2.Status, ProdOrderLine2."Line No.", Database::"Prod. Order Component")
                        then
                            ProdOrderLine2.TestField("Reserved Qty. (Base)", 0);
                end;

                if CalcComponents then begin
                    ProdOrderComp2.SetRange(Status, ProdOrderLine2.Status);
                    ProdOrderComp2.SetRange("Prod. Order No.", ProdOrderLine2."Prod. Order No.");
                    ProdOrderComp2.SetRange("Prod. Order Line No.", ProdOrderLine2."Line No.");
                    ProdOrderComp2.SetAutoCalcFields("Reserved Qty. (Base)");
                    if ProdOrderComp2.Find('-') then
                        repeat
                            OnCheckReservationExistOnBeforeCheckProdOrderComp2ReservedQtyBase(ProdOrderComp2);
                            if ProdOrderComp2."Reserved Qty. (Base)" <> 0 then
                                if ShouldCheckReservedQty(
                                     ProdOrderComp2."Prod. Order No.", ProdOrderComp2."Line No.",
                                     Database::"Prod. Order Component", ProdOrderComp2.Status,
                                     ProdOrderComp2."Prod. Order Line No.", Database::"Prod. Order Line")
                                then
                                    ProdOrderComp2.TestField("Reserved Qty. (Base)", 0);
                        until ProdOrderComp2.Next() = 0;
                end;
            until ProdOrderLine2.Next() = 0;
    end;

    local procedure ShouldCheckReservedQty(ProdOrderNo: Code[20]; LineNo: Integer; SourceType: Integer; Status: Enum "Production Order Status"; ProdOrderLineNo: Integer; SourceType2: Integer): Boolean
    var
        ReservEntry: Record "Reservation Entry";
    begin
        with ReservEntry do begin
            SetSourceFilter(SourceType, Status.AsInteger(), ProdOrderNo, LineNo, true);
            SetSourceFilter('', ProdOrderLineNo);
            SetRange("Reservation Status", "Reservation Status"::Reservation);
            if FindFirst() then begin
                Get("Entry No.", not Positive);
                exit(
                  not (("Source Type" = SourceType2) and
                       ("Source ID" = ProdOrderNo) and ("Source Subtype" = Status.AsInteger())));
            end;
        end;

        exit(false);
    end;

    local procedure UpdateRoutingNo(var ProductionOrder: Record "Production Order"; RoutingNo: Code[20]; var productionOrder1: Record "Production Order")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateRoutingNo(productionOrder1, RoutingNo, IsHandled, CalcLines, CalcComponents, CalcRoutings);
        if IsHandled then
            exit;

        with ProductionOrder do
            if RoutingNo <> "Routing No." then begin
                "Routing No." := RoutingNo;
                Modify();
            end;
    end;

    local procedure CheckProductionBOMStatus(ProdBOMNo: Code[20]; ProdBOMVersionNo: Code[20])
    var
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOMVersion: Record "Production BOM Version";
    begin
        if ProdBOMNo = '' then
            exit;

        if ProdBOMVersionNo = '' then begin
            ProductionBOMHeader.Get(ProdBOMNo);
            ProductionBOMHeader.TestField(Status, ProductionBOMHeader.Status::Certified);
        end else begin
            ProductionBOMVersion.Get(ProdBOMNo, ProdBOMVersionNo);
            ProductionBOMVersion.TestField(Status, ProductionBOMVersion.Status::Certified);
        end;
    end;

    local procedure CheckRoutingStatus(RoutingNo: Code[20]; RoutingVersionNo: Code[20])
    var
        RoutingHeader: Record "Routing Header";
        RoutingVersion: Record "Routing Version";
    begin
        if RoutingNo = '' then
            exit;

        if RoutingVersionNo = '' then begin
            RoutingHeader.Get(RoutingNo);
            RoutingHeader.TestField(Status, RoutingHeader.Status::Certified);
        end else begin
            RoutingVersion.Get(RoutingNo, RoutingVersionNo);
            RoutingVersion.TestField(Status, RoutingVersion.Status::Certified);
        end;
    end;

    procedure InitializeRequest(Direction2: Option Forward,Backward; CalcLines2: Boolean; CalcRoutings2: Boolean; CalcComponents2: Boolean; CreateInbRqst2: Boolean)
    begin
        Direction := Direction2;
        CalcLines := CalcLines2;
        CalcRoutings := CalcRoutings2;
        CalcComponents := CalcComponents2;
        CreateInbRqst := CreateInbRqst2;
    end;

    local procedure IsComponentPicked(ProdOrder: Record "Production Order"): Boolean
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        ProdOrderComp.SetRange(Status, ProdOrder.Status);
        ProdOrderComp.SetRange("Prod. Order No.", ProdOrder."No.");
        ProdOrderComp.SetFilter("Qty. Picked", '<>0');
        exit(not ProdOrderComp.IsEmpty);
    end;

    local procedure GetRoutingNo(ProdOrder: Record "Production Order") RoutingNo: Code[20]
    var
        Item: Record Item;
        StockkeepingUnit: Record "Stockkeeping Unit";
        Family: Record Family;
    begin
        RoutingNo := ProdOrder."Routing No.";
        case ProdOrder."Source Type" of
            ProdOrder."Source Type"::Item:
                begin
                    if Item.Get(ProdOrder."Source No.") then
                        RoutingNo := Item."Routing No.";
                    if StockkeepingUnit.Get(ProdOrder."Location Code", ProdOrder."Source No.", ProdOrder."Variant Code") and
                        (StockkeepingUnit."Routing No." <> '')
                    then
                        RoutingNo := StockkeepingUnit."Routing No.";
                end;
            ProdOrder."Source Type"::Family:
                if Family.Get(ProdOrder."Source No.") then
                    RoutingNo := Family."Routing No.";
        end;

        OnAfterGetRoutingNo(ProdOrder, RoutingNo);
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterGetRoutingNo(var ProductionOrder: Record "Production Order"; var RoutingNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRefreshProdOrder(var ProductionOrder: Record "Production Order"; ErrorOccured: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnInit(var Direction: Option; var CalcLines: Boolean; var CalcRoutings: Boolean; var CalcComponents: Boolean; var CreateInbRqst: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcProdOrder(var ProductionOrder: Record "Production Order"; Direction: Option Forward,Backward)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcProdOrderLine(var ProdOrderLine: Record "Prod. Order Line"; var Direction: Option Forward,Backward; CalcLines: Boolean; CalcRoutings: Boolean; CalcComponents: Boolean; var IsHandled: Boolean; var ErrorOccured: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcProdOrderLines(var ProductionOrder: Record "Production Order"; Direction: Option Forward,Backward; CalcLines: Boolean; CalcRoutings: Boolean; CalcComponents: Boolean; var IsHandled: Boolean; var ErrorOccured: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcRoutingsOrComponents(var ProductionOrder: Record "Production Order"; var ProdOrderLine: Record "Prod. Order Line"; var CalcComponents: Boolean; var CalcRoutings: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateRoutingNo(var ProductionOrder: Record "Production Order"; RoutingNo: Code[20]; var IsHandled: Boolean; var CalcLines: Boolean; var CalcComponents: Boolean; var CalcRoutings: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckReservationExistOnBeforeCheckProdOrderComp2ReservedQtyBase(var ProdOrderComp2: Record "Prod. Order Component")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterInitReport()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnProductionOrderOnAfterGetRecordOnAfterCalcRoutingsOrComponents(var ProductionOrder: Record "Production Order"; CalcLines: Boolean; CalcRoutings: Boolean; CalcComponents: Boolean; var ErrorOccured: Boolean)
    begin
    end;

}
