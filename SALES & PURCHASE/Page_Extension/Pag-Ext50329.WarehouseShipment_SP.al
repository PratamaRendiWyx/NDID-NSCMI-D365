
pageextension 50329 WarehouseShipment_SP extends "Warehouse Shipment"
{
    actions
    {
        // /Add changes to page actions here
        modify("P&ost Shipment")
        {
            Enabled = (Rec."Completely Packing") or (Rec."Whse. Sales Type" = Rec."Whse. Sales Type"::Domestic);
        }
        addafter("Get Source Documents")
        {
            action("Gen.PackingList1")
            {
                ApplicationArea = Warehouse;
                Caption = 'Generate Packing List.';
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
                    CurrPage.WhseShptLines.Page.Update(false);
                    CurrPage.Update(false);
                end;
            }
        }

    }
}