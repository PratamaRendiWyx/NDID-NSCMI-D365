codeunit 51109 "Inventory Aging PMB"
{
    trigger OnRun()
    var
        myInt: Integer;
        item: Record Item;
        lastdate: Date;
        Ok: Boolean;
        SessionId: Integer;
        ItemText: Text;
    begin
        // LastDate := CALCDATE('CM', Today());
        begin
            Clear(InventoryAgingMgt);
            Clear(item);
            LastDate := InventoryAgingMgt.getAsOfDate();
            InventoryAgingMgt.insertLog(LastDate, 4, 'Start Process Invt. Aging - PMB');
            item.Reset();
            item.SetFilter("No.", 'PMB*');
            if item.FindSet() then begin
                repeat
                    InventoryAgingMgt.CollectInvtAgingData(lastdate, item."No.");
                until item.Next() = 0;
            end;
            InventoryAgingMgt.insertLog(LastDate, 4, 'End Process Invt. Aging - PMB');
            //Continue run RMB-2
            Clear(SessionId);
            Ok := StartSession(SessionId, Codeunit::"Inventory Aging RMB-2");
            //-
        end;
    end;

    var
        InventoryAgingMgt: Codeunit "Inventory Aging Mgt.";
}
