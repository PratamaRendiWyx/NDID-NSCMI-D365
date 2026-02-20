codeunit 51118 "Inventory Aging SPB"
{
    trigger OnRun()
    var
        myInt: Integer;
        item: Record Item;
        lastdate: Date;
        Ok: Boolean;
        SessionId: Integer;
    begin
        // LastDate := CALCDATE('CM', Today());
        begin
            Clear(InventoryAgingMgt);
            Clear(item);
            LastDate := InventoryAgingMgt.getAsOfDate();
            InventoryAgingMgt.insertLog(LastDate, 7, 'Start Process Invt. Aging - SPB');
            item.Reset();
            item.SetFilter("No.", 'SPB*');
            if item.FindSet() then begin
                repeat
                    InventoryAgingMgt.CollectInvtAgingData(lastdate, item."No.");
                until item.Next() = 0;
            end;
            InventoryAgingMgt.insertLog(LastDate, 7, 'End Process Invt. Aging - SPB');
        end;
    end;

    var
        InventoryAgingMgt: Codeunit "Inventory Aging Mgt.";
}
