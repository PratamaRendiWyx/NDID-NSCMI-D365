codeunit 51114 "Inventory Aging FSB-2"
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
            InventoryAgingMgt.insertLog(LastDate, 3, 'Start Process Invt. Aging - FSB-2');
            item.Reset();
            item.SetFilter("No.", 'FSB*');
            if item.FindSet() then begin
                repeat
                    Clear(myInt);
                    ItemText := CopyStr(item."No.", 4);
                    Evaluate(myInt, ItemText);
                    myInt := (myInt Mod Const) + 1;
                    if myInt = 2 then
                        InventoryAgingMgt.CollectInvtAgingData(lastdate, item."No.");
                until item.Next() = 0;
            end;
            InventoryAgingMgt.insertLog(LastDate, 3, 'End Process Invt. Aging - FSB-2');
        end;
    end;

    var
        InventoryAgingMgt: Codeunit "Inventory Aging Mgt.";
}
