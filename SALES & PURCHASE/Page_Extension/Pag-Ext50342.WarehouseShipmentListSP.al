pageextension 50342 "Warehouse Shipment List SP" extends "Warehouse Shipment List"
{
    layout
    {
        addbefore(Status)
        {
            field("Completely Shipping Mark"; Rec."Completely Shipping Mark")
            {
                ApplicationArea = All;
            }
            field("Completely Packing"; Rec."Completely Packing")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("&Shipment")
        {
            action("Gen.PackingList1")
            {
                ApplicationArea = Warehouse;
                Caption = 'Generate Packing List';
                Image = PhysicalInventoryLedger;
                Enabled = (Rec.Status = Rec.Status::Released) and (Rec."Completely Shipping Mark");
                trigger OnAction()
                var
                    PackingMgnt: Codeunit "Packing List Whse. Mgt SP";
                    WarehouseShipmentHeader: Record "Warehouse Shipment Header";
                begin
                    Clear(PackingMgnt);
                    //generate packing
                    CurrPage.SetSelectionFilter(WarehouseShipmentHeader);
                    PackingMgnt.generatePackingList(WarehouseShipmentHeader);
                    //-
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
