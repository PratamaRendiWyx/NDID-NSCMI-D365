codeunit 50710 PRDTableSubscribers_PQ
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterValidateEvent', 'Standard Cost', false, false)]
    local procedure ItemOnAfterValidateStandardCost(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        CostCalcLogT2: Record UnitandCurrCostCalcLog_PQ;
        CostCalcLogT: Record UnitandCurrCostCalcLog_PQ;
        NextEntryNo: Integer;
    begin
        if Rec."Standard Cost" <> xRec."Standard Cost" then begin
            Rec."Last Unit Cost Calc. Date" := WorkDate;
            Rec."Last Std Cost Change" := WorkDate;

            //update audit
            CostCalcLogT2.Reset;
            if CostCalcLogT2.FindLast then
                NextEntryNo := CostCalcLogT2."Entry No." + 1
            else
                NextEntryNo := 1;

            CostCalcLogT.Init;
            CostCalcLogT."Entry No." := NextEntryNo;
            CostCalcLogT."Item No." := Rec."No.";
            CostCalcLogT."Action Date" := WorkDate;
            CostCalcLogT."Calculation Date" := 0D;
            CostCalcLogT."User ID" := UserId;
            CostCalcLogT."Entry Type" := CostCalcLogT."Entry Type"::"Std Cost Field Change";
            CostCalcLogT."Previous Std. Cost" := Rec."Unit Cost";
            CostCalcLogT."Calcd or Entered Std. Cost" := Rec."Standard Cost";
            CostCalcLogT."Item Card Lot Size" := Rec."Lot Size";
            CostCalcLogT."Time of Day" := Time;
            CostCalcLogT."Last CurrCost Calc BOM No." := Rec."Production BOM No.";
            CostCalcLogT."Last CurrCost Calc Router No." := Rec."Routing No.";
            CostCalcLogT."Indirect Cost %" := Rec."Indirect Cost %";
            CostCalcLogT."Scrap %" := Rec."Scrap %";
            CostCalcLogT."Overhead Rate" := Rec."Overhead Rate";
            CostCalcLogT.Insert;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterValidateEvent', 'Lot Size', false, false)]
    local procedure ItemOnAfterValidateLotSize(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        CostCalcLogT2: Record UnitandCurrCostCalcLog_PQ;
        CostCalcLogT: Record UnitandCurrCostCalcLog_PQ;
        NextEntryNo: Integer;
    begin
        if Rec."Lot Size" <> xRec."Lot Size" then
            Rec."Last Lot Size Change" := Today;
    end;

    [EventSubscriber(ObjectType::Table, 5412, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure ProdOrdRtgPersonnelOnAfterValidateNo(var Rec: Record "Prod. Order Routing Personnel"; var xRec: Record "Prod. Order Routing Personnel"; CurrFieldNo: Integer)
    var
        ResourceT: Record Resource;
    begin
        if ResourceT.Get(Rec."No.") then
            Rec.Description := ResourceT.Name;
    end;

    [EventSubscriber(ObjectType::Table, 99000803, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure RoutingPersonnelOnAfterValidateNo(var Rec: Record "Routing Personnel"; var xRec: Record "Routing Personnel"; CurrFieldNo: Integer)
    var
        ResourceT: Record Resource;
    begin
        if ResourceT.Get(Rec."No.") then
            Rec.Description := ResourceT.Name;
    end;


    //[EventSubscriber(ObjectType::Table, 5407, 'OnAfterValidateEvent', 'Unit Cost', false, false)]
    local procedure ProdOrderComponentOnAfterValidateUnitCost(var Rec: Record "Prod. Order Component"; var xRec: Record "Prod. Order Component"; CurrFieldNo: Integer)
    var
        UnitCostText: Label 'You are not allowed to edit this field.';
    begin
        if xRec."Unit Cost" <> Rec."Unit Cost" then
            Error(UnitCostText);
    end;

    //[EventSubscriber(ObjectType::Table, 5409, 'OnAfterValidateEvent', 'Input Quantity', false, false)]
    local procedure ProdOrderRoutingLineOnAfterValidateInputQuantity(var Rec: Record "Prod. Order Routing Line"; var xRec: Record "Prod. Order Routing Line"; CurrFieldNo: Integer)
    var
        InputQtyText: Label 'You are not allowed to edit the Input Quantity field.';
    begin
        if xRec."Input Quantity" <> Rec."Input Quantity" then
            Error(InputQtyText);
    end;

    [EventSubscriber(ObjectType::Table, 5407, 'OnBeforeRoundExpectedQuantity', '', false, false)]
    local procedure OnBeforeRoundExpectedQuantity(var ProdOrderComponent: Record "Prod. Order Component"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Report, 99001025, 'OnBeforeCalcProdOrder', '', false, false)]
    local procedure OnBeforeCalcProdOrder(var ProductionOrder: Record "Production Order"; Direction: Option Forward,Backward)
    var
        ProdOrderLine2: Record "Prod. Order Line";
        ReservEntry: Record "Reservation Entry";
        MPSetup: Record "Manufacturing Setup";
    begin
        MPSetup.Get();
        if MPSetup."Upd Plned Shpt Date on ReSched" then begin
            ProdOrderLine2.SetRange(Status, ProductionOrder.Status);
            ProdOrderLine2.SetRange("Prod. Order No.", ProductionOrder."No.");
            if ProdOrderLine2.Find('-') then
                repeat
                    with ReservEntry do begin
                        SetSourceFilter(DATABASE::"Prod. Order Line", ProdOrderLine2.Status.AsInteger(), ProdOrderLine2."Prod. Order No.", 0, true);
                        SetSourceFilter('', ProdOrderLine2."Line No.");
                        SetRange("Reservation Status", "Reservation Status"::Reservation);
                        if FindSet() then begin
                            ModifyAll("Source Batch Name", 'Temp0001', false);
                        end;
                    end;
                until ProdOrderLine2.Next = 0;
        end;
    end;


    [EventSubscriber(ObjectType::Report, 99001025, 'OnBeforeCalcProdOrderLines', '', false, false)]
    local procedure OnBeforeCalcProdOrderLines(var ProductionOrder: Record "Production Order"; Direction: Option Forward,Backward; CalcLines: Boolean; CalcRoutings: Boolean; CalcComponents: Boolean; var IsHandled: Boolean; var ErrorOccured: Boolean)
    var
        ProdOrderLine2: Record "Prod. Order Line";
        ReservEntry: Record "Reservation Entry";
        MPSetup: Record "Manufacturing Setup";
    begin
        MPSetup.Get();
        if MPSetup."Upd Plned Shpt Date on ReSched" then begin
            ProdOrderLine2.SetRange(Status, ProductionOrder.Status);
            ProdOrderLine2.SetRange("Prod. Order No.", ProductionOrder."No.");
            if ProdOrderLine2.Find('-') then
                repeat
                    with ReservEntry do begin
                        SetSourceFilter(DATABASE::"Prod. Order Line", ProdOrderLine2.Status.AsInteger(), ProdOrderLine2."Prod. Order No.", 0, true);
                        SetSourceFilter('Temp0001', ProdOrderLine2."Line No.");
                        SetRange("Reservation Status", "Reservation Status"::Reservation);
                        if FindSet() then begin
                            ModifyAll("Source Batch Name", '', false);
                        end;
                    end;
                until ProdOrderLine2.Next = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Report, 99001025, 'OnBeforeCalcRoutingsOrComponents', '', false, false)]
    local procedure OnBeforeCalcRoutingsOrComponents(var ProductionOrder: Record "Production Order"; var ProdOrderLine: Record "Prod. Order Line"; var CalcComponents: Boolean; var CalcRoutings: Boolean; var IsHandled: Boolean)
    var
        ProdOrderLine2: Record "Prod. Order Line";
        ReservEntry: Record "Reservation Entry";
        MPSetup: Record "Manufacturing Setup";
    begin
        MPSetup.Get();
        if MPSetup."Upd Plned Shpt Date on ReSched" then begin
            ProdOrderLine2.SetRange(Status, ProductionOrder.Status);
            ProdOrderLine2.SetRange("Prod. Order No.", ProductionOrder."No.");
            if ProdOrderLine2.Find('-') then
                repeat
                    with ReservEntry do begin
                        SetSourceFilter(DATABASE::"Prod. Order Line", ProdOrderLine2.Status.AsInteger(), ProdOrderLine2."Prod. Order No.", 0, true);
                        SetSourceFilter('Temp0001', ProdOrderLine2."Line No.");
                        SetRange("Reservation Status", "Reservation Status"::Reservation);
                        if FindSet() then begin
                            ModifyAll("Source Batch Name", '', false);
                        end;
                    end;
                until ProdOrderLine2.Next = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 99000831, 'OnBeforeCloseReservEntry', '', false, false)]
    local procedure OnBeforeCloseReservEntry(var ReservEntry: Record "Reservation Entry"; ReTrack: Boolean; DeleteAll: Boolean)
    var
        ReservEntryBuffer: Record ReservationEntryBuffer_PQ;
        ReservEntry2: Record "Reservation Entry";
        Item: Record Item;
        MPSetup: Record "Manufacturing Setup";
    begin
        MPSetup.Get();
        if MPSetup."Upd Plned Shpt Date on ReSched" then begin
            if ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Prospect then
                exit;

            if ReservEntry."Reservation Status" <> ReservEntry."Reservation Status"::Surplus then begin
                if Item.Get(ReservEntry."Item No.") then;
                ReservEntry2.Get(ReservEntry."Entry No.", not ReservEntry.Positive);
                if (Item."Order Tracking Policy" = Item."Order Tracking Policy"::None) and
                (not TransferLineWithItemTracking(ReservEntry2)) and
                (((ReservEntry.Binding = ReservEntry.Binding::"Order-to-Order") and ReservEntry2.Positive) or
                    (ReservEntry2."Source Type" = DATABASE::"Item Ledger Entry") or not ReservEntry2.TrackingExists)
                then begin
                    if ReservEntry2."Source Type" = 37 then begin
                        ReservEntryBuffer.Reset();
                        ReservEntryBuffer.TransferFields(ReservEntry);
                        if ReservEntryBuffer.Insert() then;

                        ReservEntryBuffer.Reset();
                        ReservEntryBuffer.TransferFields(ReservEntry2);
                        if ReservEntryBuffer.Insert() then;
                    end
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Report, 99001025, 'OnAfterRefreshProdOrder', '', false, false)]
    local procedure OnAfterRefreshProdOrder(var ProductionOrder: Record "Production Order"; ErrorOccured: Boolean)
    var
        ReservEntryBuffer: Record ReservationEntryBuffer_PQ;
        ReservEntryBuffer2: Record ReservationEntryBuffer_PQ;
        ReservEntry2: Record "Reservation Entry";
        SalesLn: Record "Sales Line";
        ProdOrderLn: Record "Prod. Order Line";
        ProdOrder: Record "Production Order";
        NewDueDate: Date;
        MPSetup: Record "Manufacturing Setup";
    begin
        MPSetup.Get();
        if MPSetup."Upd Plned Shpt Date on ReSched" then begin
            ReservEntryBuffer.Reset;
            ReservEntryBuffer.SetRange("Source Type", 5406);
            ReservEntryBuffer.SetRange("Source ID", ProductionOrder."No.");
            if ReservEntryBuffer.FindLast() then begin
                ReservEntryBuffer2.Reset();
                ReservEntryBuffer2.SetRange("Entry No.", ReservEntryBuffer."Entry No.");
                if ReservEntryBuffer2.FindSet() then
                    repeat
                        if ReservEntryBuffer2."Source Type" = 37 then begin
                            SalesLn.Reset();
                            SalesLn.SetRange("Document Type", SalesLn."Document Type"::Order);
                            SalesLn.SetRange("Document No.", ReservEntryBuffer2."Source ID");
                            SalesLn.SetRange("Line No.", ReservEntryBuffer2."Source Ref. No.");
                            if SalesLn.FindFirst() then begin
                                ProdOrder.Reset();
                                NewDueDate := ProductionOrder."Ending Date";
                                if ProdOrder.Get(ProductionOrder.Status, ProductionOrder."No.") then
                                    NewDueDate := ProdOrder."Ending Date";
                                SalesLn.SuspendStatusCheck(true);
                                SalesLn.Validate("Planned Shipment Date", NewDueDate);
                                SalesLn.Modify();
                            end
                        end;

                        ReservEntry2.Reset();
                        ReservEntry2.TransferFields(ReservEntryBuffer2);
                        ReservEntry2.Validate("Expected Receipt Date", NewDueDate);
                        ReservEntry2.Validate("Shipment Date", NewDueDate);
                        if ReservEntry2.Insert() then;
                    until ReservEntryBuffer2.Next() = 0;
            end;

            ReservEntryBuffer2.Reset();
            ReservEntryBuffer2.SetRange("Entry No.", ReservEntryBuffer."Entry No.");
            if ReservEntryBuffer2.FindSet() then
                ReservEntryBuffer2.DeleteAll();
        end;
    end;

    local procedure TransferLineWithItemTracking(ReservEntry: Record "Reservation Entry"): Boolean
    begin
        exit((ReservEntry."Source Type" = DATABASE::"Transfer Line") and ReservEntry.TrackingExists);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        RecStatus: Enum "Production Order Status";
    begin
        case RecRef.Number of
            DATABASE::"Production Order":
                begin
                    FieldRef := RecRef.Field(1);
                    RecStatus := FieldRef.Value;
                    DocumentAttachment.Validate("Production Order Status", RecStatus);

                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;
}
