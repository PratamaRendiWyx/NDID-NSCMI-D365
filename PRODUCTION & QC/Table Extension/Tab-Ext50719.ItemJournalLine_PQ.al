tableextension 50719 ItemJournalLine_PQ extends "Item Journal Line"
{
    fields
    {
        field(50700; "CCS Test No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Quality Test No.';
        }
        field(50701; "Inventory"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                "Variant Code" = FIELD("Variant Code"),
                                                                "Entry No." = field("Entry No Filter")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50702; "Item No. Filter"; Code[20])
        {
            Caption = 'Item No. Filter';
            FieldClass = FlowFilter;
        }
        field(50703; "Variant Filter"; Code[10])
        {
            Caption = 'Variant Filter';
            FieldClass = FlowFilter;
        }
        field(50704; "Entry No Filter"; Integer)
        {
            Caption = 'Entry No Filter';
            FieldClass = FlowFilter;
        }
        field(50705; "Order No. 2"; Code[20])
        {
            Caption = 'Order No.';
            TableRelation = if ("Order Type" = const(Production)) "Production Order"."No." where(Status = const(Released));
        }
        field(50715; "IsRemainQty"; Boolean)
        {
            Caption = 'Is Remain Qty.';
        }
        field(50716; "Lot No. (Gen.)"; Code[50])
        {
            DataClassification = CustomerContent;
        }
    }

    procedure PreviewPostItemJnlFromProduction1()
    var
        ProductionOrder: Record "Production Order";
        ItemJnlPost: Codeunit "Item Jnl.-Post";
    begin
        if ("Order Type" = "Order Type"::Production) and ("Order No." <> '') then
            ProductionOrder.Get(ProductionOrder.Status::Released, "Order No.");

        ItemJnlPost.Preview(Rec);
    end;
}