codeunit 50500 "Packing List Mgmnt."
{
    procedure cancelPackingListOrder(iNo: Text)
    var
        packingListOrder: Record "Pack. Header";
        packingListOrderLines: Record "Pack. Lines";
        Label: Label 'Are you sure want to cancel the packing list order [';
        warehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        if not Confirm(Label + iNo + '] ?') then
            exit;
        Clear(packingListOrder);
        packingListOrder.Reset();
        packingListOrder.SetRange("No.", iNo);
        packingListOrder.SetRange(IsCancel, false);
        if packingListOrder.FindSet() then begin
            //check line process
            Clear(packingListOrderLines);
            packingListOrderLines.Reset();
            packingListOrderLines.SetRange("No.", packingListOrder."No.");
            if packingListOrderLines.FindSet() then begin
                repeat
                    Clear(warehouseShipmentLine);
                    warehouseShipmentLine.SetRange("No.", packingListOrderLines."Warehouse Shpt No.");
                    warehouseShipmentLine.SetRange("Line No.", packingListOrderLines."Warehouse Shpt Line No.");
                    if warehouseShipmentLine.FindSet() then begin
                        warehouseShipmentLine."Completely Packing" := false;
                        warehouseShipmentLine.Modify();
                    end else begin
                        Error('Error, Warehouse document [%1] line [%2] doest not exists', packingListOrderLines."Warehouse Shpt No.", packingListOrderLines."Warehouse Shpt Line No.");
                    end;
                until packingListOrderLines.Next() = 0;
            end;
            // do cancel header
            packingListOrder.IsCancel := true;
            packingListOrder.Modify();
        end else begin
            Message('Nothing to handle.');
        end;
    end;
}
