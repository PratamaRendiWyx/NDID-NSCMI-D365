table 50307 "BOPManualLines_SP"
{
    Caption = 'Manual BOP Document Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "BOPManualHeader_SP"."No.";
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }

        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if Item.Get("Item No.") then begin
                    "Item Desc" := Item.Description;
                    "Description" := Item.Description;
                    "UOM" := Item."Base Unit of Measure";
                end else begin
                    "Item Desc" := '';
                    "Description" := '';
                    "UOM" := '';
                end;
            end;
        }
        field(4; "Item Desc"; Text[100])
        {
            Caption = 'Item Desc';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "Item Reference No."; Code[50])
        {
            Caption = 'Item Reference No.';
            TableRelation = "Item Reference"."Reference No." where("Item No." = field("Item No."));
            DataClassification = CustomerContent;
        }
        field(6; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(7; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(8; "UOM"; Code[10])
        {
            Caption = 'UOM';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}