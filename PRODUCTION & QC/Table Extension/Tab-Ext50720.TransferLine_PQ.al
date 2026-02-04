tableextension 50720 TransferLine_PQ extends "Transfer Line"
{
    fields
    {
        field(50700; "CCS Test No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Quality Test No.';
        }

        field(50710; "Transfer UOM"; Code[10])
        {
            Caption = 'Transfer UOM';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            begin
                if "Item No." <> '' then begin
                    GetItemUOM();
                    "Qty. per Transfer UOM" := ItemUOM."Qty. per Unit of Measure";
                    "Qty. Transfer" := ROUND((Quantity DIV "Qty. per Transfer UOM"), 1, '<');
                end;
            end;
        }
        field(50711; "Qty. per Transfer UOM"; Decimal)
        {
            Caption = 'Qty. per Transfer UOM';
            Editable = false;
            InitValue = 1;
        }

        field(50712; "Qty. Transfer"; Decimal)
        {
            Caption = 'Qty. Transfer';
            DecimalPlaces = 0;
        }
        field(50713; "Remaining Qty."; Decimal)
        {
        }
        field(50714; "Prod. Order No."; Code[20])
        {
        }
        field(50715; "Prod. Order Line No."; Integer)
        {
        }
        field(50716; "Prod. Comp. Line No."; Integer)
        {
            Caption = 'Prod. Comp. Line No.';
            TableRelation = "Prod. Order Component"."Line No.";
        }
        field(50717; "Planning Qty."; Decimal)
        {
            Caption = 'Planning Qty.';
        }
        field(50718; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code".Code;
        }
    }


    var
        Item: Record Item;
        ItemUOM: Record "Item Unit of Measure";
        UOMMgt: Codeunit "Unit of Measure Management";

    local procedure GetItemUOM()
    begin
        GetItem();
        Item.TestField("No.");
        if (Item."No." <> ItemUOM."Item No.") or
           ("Unit of Measure Code" <> ItemUOM.Code)
        then
            if not ItemUOM.Get(Item."No.", "Transfer UOM") then
                ItemUOM.Get(Item."No.", Item."Base Unit of Measure");
    end;

    local procedure GetItem()
    begin
        if Item."No." = "Item No." then
            exit;

        Item.Get("Item No.");
    end;
}