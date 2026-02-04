codeunit 50314 "Reservation Mgt."
{
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnRegisterChangeOnChangeTypeInsertOnBeforeInsertReservEntry, '', false, false)]
    local procedure OnRegisterChangeOnChangeTypeInsertOnBeforeInsertReservEntry(var TrackingSpecification: Record "Tracking Specification"; var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; FormRunMode: Option)
    begin
        ModifyRun := false;
        ShippingMark := NewTrackingSpecification."Shipping Mark No.";
        BoxQty := NewTrackingSpecification."Box Qty.";
        USDFSCode := NewTrackingSpecification."USDFS Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", OnAfterSetDates, '', false, false)]
    local procedure OnAfterSetDates(var ReservationEntry: Record "Reservation Entry")
    begin
        ReservationEntry."Box Qty." := BoxQty;
        ReservationEntry."USDFS Code" := USDFSCode;
        ReservationEntry."Shipping Mark No." := ShippingMark;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", OnCreateReservEntryExtraFields, '', false, false)]
    local procedure OnCreateReservEntryExtraFields(var InsertReservEntry: Record "Reservation Entry"; OldTrackingSpecification: Record "Tracking Specification"; NewTrackingSpecification: Record "Tracking Specification")
    begin
        InsertReservEntry."Box Qty." := NewTrackingSpecification."Box Qty.";
        InsertReservEntry."USDFS Code" := NewTrackingSpecification."USDFS Code";
        InsertReservEntry."Shipping Mark No." := NewTrackingSpecification."Shipping Mark No.";
    end;

    //OnAfterEntriesAreIdentical
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnAfterEntriesAreIdentical, '', false, false)]
    local procedure OnAfterEntriesAreIdentical(ReservEntry1: Record "Reservation Entry"; ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean)
    begin
        IdenticalArray[2] :=
          (ReservEntry1."Box Qty." = ReservEntry2."Box Qty.") and
          (ReservEntry1."Shipping Mark No." = ReservEntry2."Shipping Mark No.") and
          (ReservEntry1."USDFS Code" = ReservEntry2."USDFS Code");
    end;

    //OnAfterCopyTrackingSpec
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnAfterCopyTrackingSpec, '', false, false)]
    local procedure OnAfterCopyTrackingSpec(var SourceTrackingSpec: Record "Tracking Specification"; var DestTrkgSpec: Record "Tracking Specification")
    begin
        if ModifyRun = false then begin
            SourceTrackingSpec."Box Qty." := DestTrkgSpec."Box Qty.";
            SourceTrackingSpec."Shipping Mark No." := DestTrkgSpec."Shipping Mark No.";
            SourceTrackingSpec."USDFS Code" := DestTrkgSpec."USDFS Code";
        end else begin
            //for modified value flow
            DestTrkgSpec."Box Qty." := SourceTrackingSpec."Box Qty.";
            DestTrkgSpec."Shipping Mark No." := SourceTrackingSpec."Shipping Mark No.";
            DestTrkgSpec."USDFS Code" := SourceTrackingSpec."USDFS Code";
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnAfterMoveFields, '', false, false)]
    local procedure OnAfterMoveFields(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry")
    begin
        ReservEntry."Box Qty." := TrkgSpec."Box Qty.";
        ReservEntry."Shipping Mark No." := TrkgSpec."Shipping Mark No.";
        ReservEntry."USDFS Code" := TrkgSpec."USDFS Code";
    end;

    //Item Jnl.-Post Line | OnBeforeInsertSetupTempSplitItemJnlLine
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnBeforeInsertSetupTempSplitItemJnlLine, '', false, false)]
    local procedure OnBeforeInsertSetupTempSplitItemJnlLine(var TempTrackingSpecification: Record "Tracking Specification" temporary; var TempItemJournalLine: Record "Item Journal Line" temporary; var PostItemJnlLine: Boolean; var ItemJournalLine2: Record "Item Journal Line"; SignFactor: Integer; FloatingFactor: Decimal)
    begin
        TempItemJournalLine."Box Qty." := TempTrackingSpecification."Box Qty.";
        TempItemJournalLine."Shipping Mark No." := TempTrackingSpecification."Shipping Mark No.";
        TempItemJournalLine."USDFS Code" := TempTrackingSpecification."USDFS Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnAfterInitItemLedgEntry, '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        NewItemLedgEntry."Box Qty." := ItemJournalLine."Box Qty.";
        NewItemLedgEntry."Shipping Mark No." := ItemJournalLine."Shipping Mark No.";
        NewItemLedgEntry."USDFS Code" := ItemJournalLine."USDFS Code";
    end;


    var
        BoxQty: Decimal;
        ShippingMark: Code[20];
        USDFSCode: Text[100];
        ModifyRun: Boolean;
}
