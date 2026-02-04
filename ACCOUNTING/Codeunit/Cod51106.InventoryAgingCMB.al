codeunit 51106 "Inventory Aging CMB"
{
    trigger OnRun()
    var
        myInt: Integer;
        item: Record Item;
        lastdate: Date;
        Ok: Boolean;
        SessionId: Integer;
    begin
        begin
            Clear(InventoryAgingMgt);
            Clear(item);
            LastDate := InventoryAgingMgt.getAsOfDate();
            InventoryAgingMgt.insertLog(LastDate, 1, 'Start Process Invt. Aging - CMB');
            item.Reset();
            item.SetFilter("No.", 'CMB*');
            if item.FindSet() then begin
                repeat
                    InventoryAgingMgt.CollectInvtAgingData(lastdate, item."No.");
                until item.Next() = 0;
            end;
            InventoryAgingMgt.insertLog(LastDate, 1, 'End Process Invt. Aging - CMB');
            //Continue run FGB|SCB-2&3
            Clear(SessionId);
            Ok := StartSession(SessionId, Codeunit::"Inventory Aging FGB-2");
            Clear(SessionId);
            Ok := StartSession(SessionId, Codeunit::"Inventory Aging SCB-2");
            //-
        end;
    end;

    var
        InventoryAgingMgt: Codeunit "Inventory Aging Mgt.";
}
