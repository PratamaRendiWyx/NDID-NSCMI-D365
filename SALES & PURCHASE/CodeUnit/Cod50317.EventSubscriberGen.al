codeunit 50317 "Event Subscriber Gen."
{
    var
        InvtSetup: Record "Inventory Setup";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Phys. Invt. Order-Finish (Y/N)", OnBeforeOnRun, '', false, false)]
    local procedure OnBeforeOnRun(var Rec: Record "Phys. Invt. Order Header"; var IsHandled: Boolean)
    var
        PhysInvtOrderHeader: Record "Phys. Invt. Order Header";
    begin
        IsHandled := true;
        PhysInvtOrderHeader.Copy(Rec);

        if Confirm(ConfirmFinishQst, false) then
            CODEUNIT.Run(CODEUNIT::"Phys. Invt. Order-Finish - Cst", PhysInvtOrderHeader);

        Rec := PhysInvtOrderHeader;
    end;

    var
        ConfirmFinishQst: Label 'Do you want to finish the order?';

    [EventSubscriber(ObjectType::Table, Database::"Phys. Invt. Record Line", OnBeforeRunPhysInvtTrackingLinesOnShowUsedTrackLines, '', false, false)]
    local procedure OnBeforeRunPhysInvtTrackingLinesOnShowUsedTrackLines(var PhysInvtRecordLine: Record "Phys. Invt. Record Line"; var TempInvtOrderTracking: Record "Invt. Order Tracking" temporary; var IsHandled: Boolean)
    var
        ExpPhysInvtTracking1: Record "Invt. Order Tracking" temporary;
        ExpPhysInvtTracking2: Record "Invt. Order Tracking" temporary;
        ExpPhysInvtTracking3: Record "Invt. Order Tracking" temporary;
        TempDat: Text;
        CurrDat: Text;
        InvtOrderTrackingLines: Page "Invt. Order Tracking Lines";
    begin
        //Flag Old data 
        TempInvtOrderTracking.ModifyAll("Is Old Data", true);
        ExpPhysInvtTracking3.DeleteAll();

        ExpPhysInvtTracking1.Copy(TempInvtOrderTracking, true);
        ExpPhysInvtTracking2.Copy(TempInvtOrderTracking, true);
        Clear(TempDat);
        Clear(CurrDat);
        if ExpPhysInvtTracking1.FindSet() then begin
            repeat
                CurrDat := ExpPhysInvtTracking1."Lot No.";
                if CurrDat <> TempDat then begin
                    ExpPhysInvtTracking2.Reset();
                    ExpPhysInvtTracking2.SetRange("Lot No.", ExpPhysInvtTracking1."Lot No.");
                    if ExpPhysInvtTracking2.FindSet() then begin
                        ExpPhysInvtTracking2.CalcSums("Qty. Expected (Base)");
                        //-
                        // if ExpPhysInvtTracking2."Qty. Expected (Base)" > 0 then begin
                        // TempInvtOrderTracking.Init();
                        ExpPhysInvtTracking3."Lot No." := ExpPhysInvtTracking2."Lot No.";
                        ExpPhysInvtTracking3."Qty. Expected (Base)" := ExpPhysInvtTracking2."Qty. Expected (Base)";
                        ExpPhysInvtTracking3.Insert();
                        // end;
                    end;
                end;
                TempDat := CurrDat;
            until ExpPhysInvtTracking1.Next() = 0;
        end;

        IsHandled := true;
        if ExpPhysInvtTracking3.FindSet() then begin
            Clear(InvtOrderTrackingLines);
            InvtOrderTrackingLines.SetRecord(ExpPhysInvtTracking3);
            InvtOrderTrackingLines.SetSources(ExpPhysInvtTracking3);
            InvtOrderTrackingLines.LookupMode(true);
            if InvtOrderTrackingLines.RunModal() = ACTION::LookupOK then begin
                InvtOrderTrackingLines.GetRecord(ExpPhysInvtTracking3);
                PhysInvtRecordLine.Validate("Serial No.", ExpPhysInvtTracking3."Serial No.");
                PhysInvtRecordLine.Validate("Lot No.", ExpPhysInvtTracking3."Lot No.");
                PhysInvtRecordLine.Validate("Package No.", ExpPhysInvtTracking3."Package No.");
            end;
        end;
    end;

    // QCFunctionLibrary_PQ
    [EventSubscriber(ObjectType::Codeunit, Codeunit::QCFunctionLibrary_PQ, OnCreateLotOrSerialNoInformation, '', false, false)]
    local procedure OnCreateLotOrSerialNoInformation(var LotInformation: Record "Lot No. Information"; var ItemLedgEntry: Record "Item Ledger Entry")
    begin
        if ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Output then begin
            LotInformation."USDFS Code" := ItemLedgEntry."USDFS Code";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Phys. Invt. Order Line", OnCalcQtyAndTrackLinesExpectedOnAfterDeleteLineWhseEntry2, '', false, false)]
    local procedure OnCalcQtyAndTrackLinesExpectedOnAfterDeleteLineWhseEntry2(var ExpInvtOrderTracking: Record "Exp. Invt. Order Tracking"; var PhysInvtOrderLine: Record "Phys. Invt. Order Line")
    var
        ExpPhysInvtTracking1: Record "Exp. Invt. Order Tracking";
        ExpPhysInvtTracking2: Record "Exp. Invt. Order Tracking";
        TempDat: Text;
        CurrDat: Text;
    begin

        InvtSetup.Get();
        if Not InvtSetup."Ignore Package No. for Exp.Qty" then
            exit;

        //Flag Old data 
        ExpInvtOrderTracking.SetRange("Quantity (Base)");
        ExpInvtOrderTracking.ModifyAll("Is Old Data", true);

        //Flag New Data
        ExpPhysInvtTracking1.Copy(ExpInvtOrderTracking);
        ExpPhysInvtTracking2.Copy(ExpInvtOrderTracking);
        Clear(TempDat);
        Clear(CurrDat);
        if ExpPhysInvtTracking1.FindSet() then begin
            repeat
                CurrDat := ExpPhysInvtTracking1."Order No" + '#' + Format(ExpPhysInvtTracking1."Order Line No.") + '#' + ExpPhysInvtTracking1."Lot No.";
                if CurrDat <> TempDat then begin
                    ExpPhysInvtTracking2.Reset();
                    ExpPhysInvtTracking2.SetRange("Order No", ExpPhysInvtTracking1."Order No");
                    ExpPhysInvtTracking2.SetRange("Lot No.", ExpPhysInvtTracking1."Lot No.");
                    ExpPhysInvtTracking2.SetRange("Order Line No.", ExpPhysInvtTracking1."Order Line No.");
                    if ExpPhysInvtTracking2.FindSet() then begin
                        ExpPhysInvtTracking2.CalcSums("Quantity (Base)");
                        //Delete Old Data 
                        ExpInvtOrderTracking.Reset();
                        ExpInvtOrderTracking.SetRange("Is Old Data", true);
                        ExpInvtOrderTracking.SetRange("Lot No.", ExpPhysInvtTracking2."Lot No.");
                        ExpInvtOrderTracking.SetRange("Order No", ExpPhysInvtTracking2."Order No");
                        ExpInvtOrderTracking.SetRange("Order Line No.", ExpPhysInvtTracking2."Order Line No.");
                        ExpInvtOrderTracking.DeleteAll();
                        //-
                        if ExpPhysInvtTracking2."Quantity (Base)" > 0 then begin
                            ExpInvtOrderTracking.Init();
                            ExpInvtOrderTracking."Order No" := ExpPhysInvtTracking2."Order No";
                            ExpInvtOrderTracking."Order Line No." := ExpPhysInvtTracking2."Order Line No.";
                            ExpInvtOrderTracking."Lot No." := ExpPhysInvtTracking2."Lot No.";
                            ExpInvtOrderTracking."Quantity (Base)" := ExpPhysInvtTracking2."Quantity (Base)";
                            ExpInvtOrderTracking.Insert();
                        end;
                    end;
                end;
                TempDat := CurrDat;
            until ExpPhysInvtTracking1.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Phys. Invt. Order Line", OnCalcQtyAndTrackLinesExpectedOnAfterDeleteLineItemLedgEntry2, '', false, false)]
    local procedure OnCalcQtyAndTrackLinesExpectedOnAfterDeleteLineItemLedgEntry2(var ExpPhysInvtTracking: Record "Exp. Invt. Order Tracking"; var PhysInvtOrderLine: Record "Phys. Invt. Order Line")
    var
        ExpPhysInvtTracking1: Record "Exp. Invt. Order Tracking";
        ExpPhysInvtTracking2: Record "Exp. Invt. Order Tracking";
        TempDat: Text;
        CurrDat: Text;
    begin

        InvtSetup.Get();
        if Not InvtSetup."Ignore Package No. for Exp.Qty" then
            exit;

        //Flag Old data 
        ExpPhysInvtTracking.SetRange("Quantity (Base)");
        ExpPhysInvtTracking.ModifyAll("Is Old Data", true);

        //Flag New Data
        ExpPhysInvtTracking1.Copy(ExpPhysInvtTracking);
        ExpPhysInvtTracking2.Copy(ExpPhysInvtTracking);
        Clear(TempDat);
        Clear(CurrDat);
        if ExpPhysInvtTracking1.FindSet() then begin
            repeat
                CurrDat := ExpPhysInvtTracking1."Order No" + '#' + Format(ExpPhysInvtTracking1."Order Line No.") + '#' + ExpPhysInvtTracking1."Lot No.";
                if CurrDat <> TempDat then begin
                    ExpPhysInvtTracking2.Reset();
                    ExpPhysInvtTracking2.SetRange("Order No", ExpPhysInvtTracking1."Order No");
                    ExpPhysInvtTracking2.SetRange("Lot No.", ExpPhysInvtTracking1."Lot No.");
                    ExpPhysInvtTracking2.SetRange("Order Line No.", ExpPhysInvtTracking1."Order Line No.");
                    if ExpPhysInvtTracking2.FindSet() then begin
                        ExpPhysInvtTracking2.CalcSums("Quantity (Base)");
                        //Delete Old Data 
                        ExpPhysInvtTracking.Reset();
                        ExpPhysInvtTracking.SetRange("Is Old Data", true);
                        ExpPhysInvtTracking.SetRange("Lot No.", ExpPhysInvtTracking2."Lot No.");
                        ExpPhysInvtTracking.SetRange("Order No", ExpPhysInvtTracking2."Order No");
                        ExpPhysInvtTracking.SetRange("Order Line No.", ExpPhysInvtTracking2."Order Line No.");
                        ExpPhysInvtTracking.DeleteAll();
                        //-
                        if ExpPhysInvtTracking2."Quantity (Base)" > 0 then begin
                            ExpPhysInvtTracking.Init();
                            ExpPhysInvtTracking."Order No" := ExpPhysInvtTracking2."Order No";
                            ExpPhysInvtTracking."Order Line No." := ExpPhysInvtTracking2."Order Line No.";
                            ExpPhysInvtTracking."Lot No." := ExpPhysInvtTracking2."Lot No.";
                            ExpPhysInvtTracking."Quantity (Base)" := ExpPhysInvtTracking2."Quantity (Base)";
                            ExpPhysInvtTracking.Insert();
                        end;
                    end;
                end;
                TempDat := CurrDat;
            until ExpPhysInvtTracking1.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Calc. Phys. Invt. Order (Bins)", 'OnBeforePhysInvtOrderLineModify', '', false, false)]
    local procedure OnBeforeLineModify(var PhysInvtOrderLine: Record "Phys. Invt. Order Line"; CalcQtyExpected: Boolean)
    begin
        InvtSetup.Get();
        if Not InvtSetup."Ignore Package No. for Exp.Qty" then
            exit;
        if CalcQtyExpected then begin
            PhysInvtOrderLine.Validate("Qty. Expected (Base)", CalcExpectedQtyIgnoringPackage(PhysInvtOrderLine));
            PhysInvtOrderLine."Qty. Exp. Calculated" := true;
        end;
    end;

    // Event: sebelum baris di-modify oleh standard calc.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Phys. Invt.-Calc. Qty. One", 'OnOnRunOnBeforePhysInvtOrderLineModify', '', false, false)]
    local procedure OnBeforeCalcQtyExpected(var PhysInvtOrderLine: Record "Phys. Invt. Order Line")
    var
        QtyExpected: Decimal;
    begin
        InvtSetup.Get();
        if Not InvtSetup."Ignore Package No. for Exp.Qty" then
            exit;
        // Hitung expected tanpa pecah Package:
        QtyExpected := CalcExpectedQtyIgnoringPackage(PhysInvtOrderLine);

        PhysInvtOrderLine.Validate("Qty. Expected (Base)", QtyExpected);
        PhysInvtOrderLine."Qty. Exp. Calculated" := true;
        // Engine standard akan melakukan Modify setelah event ini
    end;

    local procedure CalcExpectedQtyIgnoringPackage(Line: Record "Phys. Invt. Order Line") QtyExp: Decimal
    var
        WhseEntry: Record "Warehouse Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        Header: Record "Phys. Invt. Order Header";
        AsOfDate: Date;
    begin
        InvtSetup.Get();
        if Not InvtSetup."Ignore Package No. for Exp.Qty" then
            exit;

        if Header.Get(Line."Document No.") then;

        // Gunakan Posting Date dari header bila relevan sebagai batas tanggal (as-of)
        AsOfDate := Header."Posting Date";
        if AsOfDate = 0D then
            AsOfDate := WorkDate;


        if Line."Bin Code" <> '' then begin
            // === Dengan Bin: SUM dari Warehouse Entry; ABAIKAN Package No. ===
            WhseEntry.Reset();
            WhseEntry.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Bin Code"); // bantu performa
            WhseEntry.SetRange("Item No.", Line."Item No.");
            WhseEntry.SetRange("Variant Code", Line."Variant Code");
            WhseEntry.SetRange("Location Code", Line."Location Code");
            WhseEntry.SetRange("Bin Code", Line."Bin Code");
            WhseEntry.SetFilter("Registering Date", '..%1', AsOfDate);
            // Jangan SetRange("Package No.") -> otomatis ignore package
            if WhseEntry.FindSet() then
                repeat
                    QtyExp += WhseEntry."Qty. (Base)";
                until WhseEntry.Next() = 0;

            exit(QtyExp);
        end;

        // === Tanpa Bin: SUM dari Item Ledger Entry; ILE memang tidak punya Package No. ===
        ItemLedgEntry.Reset();
        ItemLedgEntry.SetCurrentKey("Item No.", "Variant Code", "Location Code"); // bantu performa
        ItemLedgEntry.SetRange("Item No.", Line."Item No.");
        ItemLedgEntry.SetRange("Variant Code", Line."Variant Code");
        ItemLedgEntry.SetRange("Location Code", Line."Location Code");
        ItemLedgEntry.SetFilter("Posting Date", '..%1', AsOfDate);

        if ItemLedgEntry.FindSet() then
            repeat
                QtyExp += ItemLedgEntry.Quantity;
            until ItemLedgEntry.Next() = 0;

        exit(QtyExp);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Phys. Invt. Order-Finish", OnAfterCalculateQtyToTransfer, '', false, false)]
    local procedure OnAfterCalculateQtyToTransfer(
       var TempInvtOrderTrackingBuffer: Record "Invt. Order Tracking" temporary;
       AllBufferLines: Boolean;
       MaxQtyToTransfer: Decimal;
       var QtyToTransfer: Decimal)
    var
        Agg: Record "Invt. Order Tracking" temporary;
        TotalQtyToTransfer: Decimal;
        KeyHasSNorLot: Boolean;
    begin

        InvtSetup.Get();
        if Not InvtSetup."Ignore Package No. for Exp.Qty" then
            exit;

        if TempInvtOrderTrackingBuffer.IsEmpty() then
            exit;

        Agg.DeleteAll();
        TotalQtyToTransfer := 0;

        // 1) Bangun agregat: group by Serial/Lot; ABAIKAN Package
        if TempInvtOrderTrackingBuffer.FindSet() then
            repeat
                KeyHasSNorLot := (TempInvtOrderTrackingBuffer."Serial No." <> '') or (TempInvtOrderTrackingBuffer."Lot No." <> '');

                if KeyHasSNorLot then begin
                    // Cari Agg untuk kombinasi Serial/Lot (abaikan package)
                    Agg.Reset();
                    Agg.SetRange("Serial No.", TempInvtOrderTrackingBuffer."Serial No.");
                    Agg.SetRange("Lot No.", TempInvtOrderTrackingBuffer."Lot No.");
                    if not Agg.FindFirst() then begin
                        Agg.Init();
                        Agg."Line No." := Agg."Line No." + 1;
                        Agg."Serial No." := TempInvtOrderTrackingBuffer."Serial No.";
                        Agg."Lot No." := TempInvtOrderTrackingBuffer."Lot No.";
                        Agg."Package No." := ''; // hilangkan package
                        Agg."Qty. Expected (Base)" := 0;
                        Agg."Qty. Recorded (Base)" := 0;
                        Agg."Qty. To Transfer" := 0;
                        Agg."Outstanding Quantity" := 0;
                        Agg.Insert();
                    end;
                    Agg."Qty. Expected (Base)" += TempInvtOrderTrackingBuffer."Qty. Expected (Base)";
                    Agg."Qty. Recorded (Base)" += TempInvtOrderTrackingBuffer."Qty. Recorded (Base)";
                    Agg."Qty. To Transfer" += TempInvtOrderTrackingBuffer."Qty. To Transfer";
                    Agg."Outstanding Quantity" += TempInvtOrderTrackingBuffer."Outstanding Quantity";
                    Agg.Modify();
                end else begin
                    // Tidak ada Serial/Lot: gabungkan jadi satu baris umum
                    Agg.Reset();
                    Agg.SetRange("Serial No.", '');
                    Agg.SetRange("Lot No.", '');
                    if not Agg.FindFirst() then begin
                        Agg.Init();
                        Agg."Line No." := 1;
                        Agg."Serial No." := '';
                        Agg."Lot No." := '';
                        Agg."Package No." := '';
                        Agg."Qty. Expected (Base)" := 0;
                        Agg."Qty. Recorded (Base)" := 0;
                        Agg."Qty. To Transfer" := 0;
                        Agg."Outstanding Quantity" := 0;
                        Agg.Insert();
                    end;
                    Agg."Qty. Expected (Base)" += TempInvtOrderTrackingBuffer."Qty. Expected (Base)";
                    Agg."Qty. Recorded (Base)" += TempInvtOrderTrackingBuffer."Qty. Recorded (Base)";
                    Agg."Qty. To Transfer" += TempInvtOrderTrackingBuffer."Qty. To Transfer";
                    Agg."Outstanding Quantity" += TempInvtOrderTrackingBuffer."Outstanding Quantity";
                    Agg.Modify();
                end;
            until TempInvtOrderTrackingBuffer.Next() = 0;

        // 2) Ganti isi buffer dengan hasil agregat (Package dikosongkan)
        TempInvtOrderTrackingBuffer.DeleteAll();

        if Agg.FindSet() then
            repeat
                TempInvtOrderTrackingBuffer.Init();
                TempInvtOrderTrackingBuffer."Line No." := Agg."Line No.";
                TempInvtOrderTrackingBuffer."Serial No." := Agg."Serial No.";
                TempInvtOrderTrackingBuffer."Lot No." := Agg."Lot No.";
                TempInvtOrderTrackingBuffer."Package No." := ''; // penting: tidak split per package
                TempInvtOrderTrackingBuffer."Qty. Expected (Base)" := Agg."Qty. Expected (Base)";
                TempInvtOrderTrackingBuffer."Qty. Recorded (Base)" := Agg."Qty. Recorded (Base)";
                TempInvtOrderTrackingBuffer."Qty. To Transfer" := Agg."Qty. To Transfer";
                TempInvtOrderTrackingBuffer."Outstanding Quantity" := Agg."Outstanding Quantity";
                TempInvtOrderTrackingBuffer.Insert();

                TotalQtyToTransfer += Agg."Qty. To Transfer";
            until Agg.Next() = 0;

        // 3) Pastikan QtyToTransfer mengikuti agregat
        QtyToTransfer := TotalQtyToTransfer;
    end;
}
