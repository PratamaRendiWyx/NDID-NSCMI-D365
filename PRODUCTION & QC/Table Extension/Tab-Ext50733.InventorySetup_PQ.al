tableextension 50733 InventorySetup_PQ extends "Inventory Setup"
{
    fields
    {
        field(50700; "QC Auto Reclass Template Name"; Code[150])
        {
            Caption = 'QC Auto Reclass Template Name';
            DataClassification = CustomerContent;
            TableRelation = "Item Journal Template".Name;
        }
        field(50701; "QC Auto Reclass Batch Name"; Code[150])
        {
            Caption = 'QC Auto Reclass Batch Name';
            DataClassification = CustomerContent;
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("QC Auto Reclass Template Name"));
        }
        field(50702; "Default Location QC"; Code[30])
        {
            TableRelation = Location.Code;
        }
    }
}
