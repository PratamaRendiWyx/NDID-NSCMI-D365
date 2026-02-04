namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Inventory.Document;

pageextension 51120 InvtReceipt_AF extends "Invt. Receipt"
{
    actions
    {
        // Add changes to page actions here

        modify("P&ost")
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TestField("Gen. Bus. Posting Group");
            end;
        }
    }
}
