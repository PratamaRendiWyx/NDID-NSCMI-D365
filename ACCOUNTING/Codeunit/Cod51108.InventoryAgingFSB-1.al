codeunit 51108 "Inventory Aging FSB-1"
{
    trigger OnRun()
    var
        myInt: Integer;
        item: Record Item;
        lastdate: Date;
        ItemText: Text;
        Const: Integer;
    begin
        // LastDate := CALCDATE('CM', Today());
        begin
            Const := 2;
            Clear(InventoryAgingMgt);
            Clear(item);
            LastDate := InventoryAgingMgt.getAsOfDate();
            InventoryAgingMgt.insertLog(LastDate, 3, 'Start Process Invt. Aging - FSB-1');
            item.Reset();
            item.SetFilter("No.", 'FSB*');
            if item.FindSet() then begin
                repeat
                    Clear(myInt);
                    ItemText := CopyStr(item."No.", 4);
                    Evaluate(myInt, ItemText);
                    myInt := (myInt Mod Const) + 1;
                    if myInt = 1 then
                        InventoryAgingMgt.CollectInvtAgingData(lastdate, item."No.");
                until item.Next() = 0;
            end;
            InventoryAgingMgt.insertLog(LastDate, 3, 'End Process Invt. Aging - FSB-1');
        end;
    end;

    var
        InventoryAgingMgt: Codeunit "Inventory Aging Mgt.";
}
