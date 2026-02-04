namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Inventory.Document;

pageextension 51121 InvtShipment_AF extends "Invt. Shipment"
{
    actions
    {
        modify("P&ost")
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("Gen. Bus. Posting Group");
            end;

        }
    }
}
