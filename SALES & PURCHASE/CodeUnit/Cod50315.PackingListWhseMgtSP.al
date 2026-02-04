codeunit 50315 "Packing List Whse. Mgt SP"
{
    procedure generatePackingList(var iwarehoushipmendHeader: Record "Warehouse Shipment Header")
    var
        warehouseShipmentLine: Record "Warehouse Shipment Line";
        warehouseShipmentLine2: Record "Warehouse Shipment Line";
        reservationEntry: Record "Reservation Entry";
        reservationEntry1: Record "Reservation Entry";
        checkProcess: Boolean;
        CurrShippingMarkNo: Code[100];
        TempShippingMarkNo: Code[100];
        PackHeader: Record "Pack. Header";
        PackHeader1: Record "Pack. Header";
        PackingNo: Code[20];
        NoSeriesMgt: Codeunit "No. Series";
        WareshouseSetup: Record "Warehouse Setup";
        PackLines: Record "Pack. Lines";
        Items: Record Item;
    begin
        WareshouseSetup.Get();
        Clear(checkProcess);
        repeat
            Clear(warehouseShipmentLine);
            warehouseShipmentLine.SetRange("No.", iwarehoushipmendHeader."No.");
            warehouseShipmentLine.SetRange("Completely Packing", false);
            warehouseShipmentLine.SetRange("Completely Shipping Mark", true);
            warehouseShipmentLine.SetAutoCalcFields("Customer PO No.");
            if warehouseShipmentLine.FindSet() then begin
                checkProcess := true;
                repeat
                    Clear(reservationEntry);
                    reservationEntry.SetRange("Source ID", warehouseShipmentLine."Source No.");
                    reservationEntry.SetRange("Source Ref. No.", warehouseShipmentLine."Source Line No.");
                    reservationEntry.SetRange("Item No.", warehouseShipmentLine."Item No.");
                    reservationEntry.SetRange("Location Code", warehouseShipmentLine."Location Code");
                    reservationEntry.SetCurrentKey("Source ID", "Item No.", "Shipping Mark No.");
                    if reservationEntry.FindSet() then begin
                        Clear(CurrShippingMarkNo);
                        Clear(TempShippingMarkNo);
                        repeat
                            CurrShippingMarkNo := reservationEntry."Source ID" + '#' + reservationEntry."Shipping Mark No.";
                            if CurrShippingMarkNo <> TempShippingMarkNo then begin
                                Clear(PackHeader);
                                PackHeader.SetRange("Shipping Mark No.", reservationEntry."Shipping Mark No.");
                                PackHeader.SetRange(IsCancel, false);
                                if not PackHeader.Find('-') then begin
                                    PackingNo := NoSeriesMgt.GetNextNo(WareshouseSetup."Packing Nos.");
                                    //if not found do insert data pack header 
                                    Clear(PackHeader1);
                                    PackHeader1.Reset();
                                    PackHeader1.Init();
                                    PackHeader1."No." := PackingNo;
                                    PackHeader1."Wrshe. Shipment No." := iwarehoushipmendHeader."No.";
                                    PackHeader1."Posting Date" := iwarehoushipmendHeader."Posting Date";
                                    PackHeader1."Shipment Date" := iwarehoushipmendHeader."Shipment Date";
                                    PackHeader1."Sorting Method" := iwarehoushipmendHeader."Sorting Method";
                                    PackHeader1."Location Code" := iwarehoushipmendHeader."Location Code";
                                    PackHeader1.Status := iwarehoushipmendHeader.Status;
                                    PackHeader1."Shipping Mark No." := reservationEntry."Shipping Mark No.";
                                    PackHeader1.Insert();

                                    //do insert line 
                                    Clear(reservationEntry1);
                                    reservationEntry1.Reset();
                                    reservationEntry1.SetRange("Source ID", warehouseShipmentLine."Source No.");
                                    reservationEntry1.SetRange("Source Ref. No.", warehouseShipmentLine."Source Line No.");
                                    reservationEntry1.SetRange("Item No.", warehouseShipmentLine."Item No.");
                                    reservationEntry1.SetRange("Location Code", warehouseShipmentLine."Location Code");
                                    reservationEntry1.SetRange("Shipping Mark No.", reservationEntry."Shipping Mark No.");
                                    if reservationEntry1.FindSet() then begin
                                        repeat
                                            //get info item 
                                            Clear(Items);
                                            Items.Reset();
                                            Items.Get(warehouseShipmentLine."Item No.");
                                            //-
                                            PackLines."No." := PackingNo;
                                            PackLines.SetRange("No.", PackLines."No.");
                                            if PackLines.FindLast() then;
                                            PackLines."Line No." := PackLines."Line No." + 1;
                                            PackLines.Reset();
                                            PackLines.Init();
                                            PackLines."Source Document" := warehouseShipmentLine."Source Document";
                                            PackLines."Source Type" := warehouseShipmentLine."Source Type";
                                            PackLines."Source Subtype" := warehouseShipmentLine."Source Subtype";
                                            PackLines."Source No." := warehouseShipmentLine."Source No.";
                                            PackLines."Source Line No." := warehouseShipmentLine."Source Line No.";
                                            PackLines."Item No." := warehouseShipmentLine."Item No.";
                                            PackLines.Description := warehouseShipmentLine.Description;
                                            PackLines.Quantity := warehouseShipmentLine.Quantity;
                                            PackLines."Qty. (Base)" := warehouseShipmentLine."Qty. (Base)";
                                            PackLines."Qty. to Ship" := warehouseShipmentLine."Qty. to Ship";
                                            PackLines."Qty. to Ship (Base)" := warehouseShipmentLine."Qty. to Ship (Base)";
                                            PackLines."Due Date" := warehouseShipmentLine."Due Date";
                                            PackLines."Unit of Measure Code" := warehouseShipmentLine."Unit of Measure Code";
                                            PackLines."Qty. per Unit of Measure" := warehouseShipmentLine."Qty. per Unit of Measure";
                                            PackLines."Warehouse Shpt Line No." := warehouseShipmentLine."Line No.";
                                            PackLines."Warehouse Shpt No." := iwarehoushipmendHeader."No.";
                                            PackLines."Shipping Mark" := warehouseShipmentLine."Shipping Mark";
                                            PackLines."Nett Weight" := Items."Net Weight";
                                            PackLines."Gross Weight" := Items."Gross Weight";
                                            PackLines."Qty to Handle" := Abs(reservationEntry1.Quantity);
                                            PackLines."Box Qty." := reservationEntry1."Box Qty.";
                                            PackLines."Shipping Mark" := reservationEntry1."Shipping Mark No.";
                                            PackLines."Lot No." := reservationEntry1."Lot No.";
                                            PackLines."Customer PO No." := warehouseShipmentLine."Customer PO No.";
                                            PackLines."Package No." := reservationEntry1."Package No.";
                                            PackLines.Insert();

                                            //update warehouse shipment line
                                            Clear(WarehouseShipmentLine2);
                                            WarehouseShipmentLine2.Reset();
                                            WarehouseShipmentLine2.SetRange("No.", warehouseShipmentLine."No.");
                                            WarehouseShipmentLine2.SetRange("Line No.", warehouseShipmentLine."Line No.");
                                            if WarehouseShipmentLine2.FindSet() then begin
                                                WarehouseShipmentLine2."Completely Packing" := true;
                                                WarehouseShipmentLine2.Modify();
                                            end;
                                        until reservationEntry1.Next() = 0;
                                    end;
                                    //-
                                end else begin
                                    Clear(PackingNo);
                                    PackingNo := PackHeader."No.";
                                    //do insert line 
                                    Clear(reservationEntry1);
                                    reservationEntry1.Reset();
                                    reservationEntry1.SetRange("Source ID", warehouseShipmentLine."Source No.");
                                    reservationEntry1.SetRange("Source Ref. No.", warehouseShipmentLine."Source Line No.");
                                    reservationEntry1.SetRange("Item No.", warehouseShipmentLine."Item No.");
                                    reservationEntry1.SetRange("Location Code", warehouseShipmentLine."Location Code");
                                    reservationEntry1.SetRange("Shipping Mark No.", reservationEntry."Shipping Mark No.");
                                    if reservationEntry1.FindSet() then begin
                                        repeat
                                            //get info item 
                                            Clear(Items);
                                            Items.Reset();
                                            Items.Get(warehouseShipmentLine."Item No.");
                                            //-
                                            PackLines."No." := PackingNo;
                                            PackLines.SetRange("No.", PackLines."No.");
                                            if PackLines.FindLast() then;
                                            PackLines."Line No." := PackLines."Line No." + 1;
                                            PackLines.Reset();
                                            PackLines.Init();
                                            PackLines."Source Document" := warehouseShipmentLine."Source Document";
                                            PackLines."Source Type" := warehouseShipmentLine."Source Type";
                                            PackLines."Source Subtype" := warehouseShipmentLine."Source Subtype";
                                            PackLines."Source No." := warehouseShipmentLine."Source No.";
                                            PackLines."Source Line No." := warehouseShipmentLine."Source Line No.";
                                            PackLines."Item No." := warehouseShipmentLine."Item No.";
                                            PackLines.Description := warehouseShipmentLine.Description;
                                            PackLines.Quantity := warehouseShipmentLine.Quantity;
                                            PackLines."Qty. (Base)" := warehouseShipmentLine."Qty. (Base)";
                                            PackLines."Qty. to Ship" := warehouseShipmentLine."Qty. to Ship";
                                            PackLines."Qty. to Ship (Base)" := warehouseShipmentLine."Qty. to Ship (Base)";
                                            PackLines."Due Date" := warehouseShipmentLine."Due Date";
                                            PackLines."Unit of Measure Code" := warehouseShipmentLine."Unit of Measure Code";
                                            PackLines."Qty. per Unit of Measure" := warehouseShipmentLine."Qty. per Unit of Measure";
                                            PackLines."Warehouse Shpt Line No." := warehouseShipmentLine."Line No.";
                                            PackLines."Warehouse Shpt No." := iwarehoushipmendHeader."No.";
                                            PackLines."Shipping Mark" := warehouseShipmentLine."Shipping Mark";
                                            PackLines."Nett Weight" := Items."Net Weight";
                                            PackLines."Gross Weight" := Items."Gross Weight";
                                            PackLines."Qty to Handle" := Abs(reservationEntry1.Quantity);
                                            PackLines."Box Qty." := reservationEntry1."Box Qty.";
                                            PackLines."Shipping Mark" := reservationEntry1."Shipping Mark No.";
                                            PackLines."Lot No." := reservationEntry1."Lot No.";
                                            PackLines."Customer PO No." := warehouseShipmentLine."Customer PO No.";
                                            PackLines."Package No." := reservationEntry1."Package No.";
                                            PackLines.Insert();

                                            //update warehouse shipment line
                                            Clear(WarehouseShipmentLine2);
                                            WarehouseShipmentLine2.Reset();
                                            WarehouseShipmentLine2.SetRange("No.", warehouseShipmentLine."No.");
                                            WarehouseShipmentLine2.SetRange("Line No.", warehouseShipmentLine."Line No.");
                                            if WarehouseShipmentLine2.FindSet() then begin
                                                WarehouseShipmentLine2."Completely Packing" := true;
                                                WarehouseShipmentLine2.Modify();
                                            end;
                                        until reservationEntry1.Next() = 0;
                                    end;
                                    //-
                                end;
                            end;
                            TempShippingMarkNo := CurrShippingMarkNo;
                        until reservationEntry.Next() = 0;
                    end;
                until warehouseShipmentLine.Next() = 0;
            end;
        until iwarehoushipmendHeader.Next() = 0;
        if not checkProcess then
            Message('Nothing to handle, make sure your document already completely shipping mark.');
    end;

    local procedure NextEntryNo(iNo: Code[20]): Integer
    var
        PackingShippmentLine: Record "Pack. Lines";
    begin
        Clear(PackingShippmentLine);
        PackingShippmentLine.SetRange("Shipping Mark", iNo);
        if PackingShippmentLine.FindLast() then
            exit(PackingShippmentLine."Line No." + 1);
        exit(1);
    end;

    //"Whse.-Post Shipment"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", OnBeforePostUpdateWhseShptLineModify, '', false, false)]
    local procedure OnBeforePostUpdateWhseShptLineModify(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; var WhseShptLineBuf: Record "Warehouse Shipment Line" temporary)
    begin
        //update after post- partial
        WarehouseShipmentLine."Completely Packing" := false;
    end;
}
