namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Inventory.Counting.Document;

pageextension 51122 PhysicalInventoryOrder_AF extends "Physical Inventory Order"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;

            }
        }
    }

    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("Gen. Bus. Posting Group");
            end;

        }
    }
}
