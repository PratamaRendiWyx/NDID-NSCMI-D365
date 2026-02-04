codeunit 51112 "Inventory Aging SMB"
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
            InventoryAgingMgt.insertLog(LastDate, 7, 'Start Process Invt. Aging - SMB');
            item.Reset();
            item.SetFilter("No.", 'SMB*');
            if item.FindSet() then begin
                repeat
                    InventoryAgingMgt.CollectInvtAgingData(lastdate, item."No.");
                until item.Next() = 0;
            end;
            InventoryAgingMgt.insertLog(LastDate, 7, 'End Process Invt. Aging - SMB');
            //Continue run FSB-2
            Clear(SessionId);
            Ok := StartSession(SessionId, Codeunit::"Inventory Aging FSB-2");
            //-
        end;
    end;

    var
        InventoryAgingMgt: Codeunit "Inventory Aging Mgt.";
}
