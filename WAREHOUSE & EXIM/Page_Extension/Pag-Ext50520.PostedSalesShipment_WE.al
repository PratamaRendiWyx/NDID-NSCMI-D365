pageextension 50520 PostedSalesShipment_WE extends "Posted Sales Shipment"
{
    layout
    {
        addafter("External Document No.")
        {
            //Additional information 
            //-
        }
    }

    var
        warehouseMgnt: Codeunit "Warehouse Management";
}
