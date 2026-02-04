namespace PRODUCTIONQC.PRODUCTIONQC;
using Microsoft.Inventory.Ledger;

pageextension 50763 ItemLedgerEntries_PQ extends "Item Ledger Entries"
{
    layout
    {
        addbefore(Quantity)
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
