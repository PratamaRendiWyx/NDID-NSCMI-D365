table 50741 "Item Jnl. Update Lot"
{
    Caption = 'Item Jnl. Update Lot QC';
    DrillDownPageID = UpdateItemLot_PQ;
    LookupPageID = UpdateItemLot_PQ;

    fields
    {
        field(2; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(3; "New Lot No."; Code[50])
        {
            Caption = 'New Lot No.';
        }
        field(4; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
        }
        field(5; "Location Code"; Code[20])
        {
            TableRelation = Location.Code;
            Caption = 'Location';
        }
        field(6; "Item No."; Code[20])
        {
            TableRelation = Item."No.";
            Caption = 'Item No.';
        }
        field(7; "Source Qty."; Decimal)
        {
            Caption = 'Source Qty';
        }
        field(57; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(58; "GUID ID"; Guid)
        {
            Caption = 'GUID ID';
        }
        field(8; Remark; Text[250])
        {
            Caption = 'GUID ID';
        }
    }
    keys
    {
        key(PK; "Item No.", "Lot No.", "New Lot No.", "Location Code")
        {
            Clustered = true;
        }
    }
}
