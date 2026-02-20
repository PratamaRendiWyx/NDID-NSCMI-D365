table 50308 "BOPManualTracking_SP"
{
    Caption = 'Manual BOP Item Tracking';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "BOPManualHeader_SP"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Tracking Line No."; Integer)
        {
            Caption = 'Tracking Line No.';
        }
        field(4; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Item No."));
        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.", "Tracking Line No.")
        {
            Clustered = true;
        }
    }
}