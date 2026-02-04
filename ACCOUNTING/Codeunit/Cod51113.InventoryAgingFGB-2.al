codeunit 51113 "Inventory Aging FGB-2"
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
            InventoryAgingMgt.insertLog(LastDate, 2, 'Start Process Invt. Aging - FGB-2');
            item.Reset();
            item.SetFilter("No.", 'FGB*');
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
            InventoryAgingMgt.insertLog(LastDate, 2, 'End Process Invt. Aging - FGB-2');
        end;
    end;

    var
        InventoryAgingMgt: Codeunit "Inventory Aging Mgt.";
}
