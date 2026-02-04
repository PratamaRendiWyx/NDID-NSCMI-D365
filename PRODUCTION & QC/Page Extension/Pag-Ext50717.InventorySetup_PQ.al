pageextension 50717 InventorySetup_PQ extends "Inventory Setup"
{
    layout
    {
        addafter("Allow Inventory Adjustment")
        {
            field("QC Auto Reclass Template Name"; Rec."QC Auto Reclass Template Name")
            {
                ApplicationArea = All;
            }
            field("QC Auto Reclass Batch Name"; Rec."QC Auto Reclass Batch Name")
            {
                ApplicationArea = All;
            }
            field("Default Location QC"; Rec."Default Location QC")
            {
                Caption = 'Default Location Reclass QC';
                ApplicationArea = All;
            }
        }
    }
}
