namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Sales.History;

pageextension 51114 PostedSalesShipmentLines_AF extends "Posted Sales Shipment Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Customer Name"; Rec."Customer Name")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
    }
}
