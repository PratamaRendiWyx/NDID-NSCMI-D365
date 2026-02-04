namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Inventory.Ledger;

tableextension 51114 ItemApplicationEntry_AF extends "Item Application Entry"
{
    fields
    {
        field(51100; "Lot No"; Text[100])
        {
            Caption = 'Lot No. (ILE)';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."Lot No." where("Entry No." = field("Item Ledger Entry No.")));
        }
        // field(51101; "Item No."; Text[100])
        // {
        //     Caption = 'Item No. (ILE)';
        //     FieldClass = FlowField;
        //     CalcFormula = lookup("Item Ledger Entry"."Item No." where("Entry No." = field("Item Ledger Entry No.")));
        // }
    }
}
