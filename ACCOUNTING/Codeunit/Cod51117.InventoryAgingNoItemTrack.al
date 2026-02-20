codeunit 51117 "Inventory Aging No Item Track."
{
    trigger OnRun()
    var
        myInt: Integer;
        item: Record Item;
        lastdate: Date;
        Const: Integer;
        ItemText: Text;
    begin
        Const := 2;
        // LastDate := CALCDATE('CM', Today());
        begin
            Clear(InventoryAgingMgt);
            Clear(item);
            LastDate := InventoryAgingMgt.getAsOfDate();
            InventoryAgingMgt.insertLog(LastDate, 6, 'Start Process Invt. Aging - No Item Track.');
            item.Reset();
            item.SetRange("Item Tracking Code", '');
            item.SetRange(Type, item.Type::Inventory);
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
            InventoryAgingMgt.insertLog(LastDate, 6, 'End Process Invt. Aging - No Item Track.');
        end;
    end;

    var
        InventoryAgingMgt: Codeunit "Inventory Aging Mgt.";
}
