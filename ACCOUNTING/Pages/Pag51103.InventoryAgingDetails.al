page 51103 "Inventory Aging Details"
{
    ApplicationArea = All;
    Caption = 'Inventory Aging Details';
    PageType = List;
    SourceTable = "Inventory Aging";
    UsageCategory = History;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(ItemNo_; Rec.ItemNo_)
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(InventoryPostingGroup; Rec.InventoryPostingGroup)
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Posting Group';
                }
                field("Lot No"; Rec."Lot No")
                {
                    ApplicationArea = All;
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Aging1; Rec.Aging1)
                {
                    ApplicationArea = All;
                    Caption = 'Aging (1-90)';
                }
                field(Aging2; Rec.Aging2)
                {
                    ApplicationArea = All;
                    Caption = 'Aging (91-180)';
                }
                field(Aging3; Rec.Aging3)
                {
                    ApplicationArea = All;
                    Caption = 'Aging (181-270)';
                }
                field(Aging4; Rec.Aging4)
                {
                    ApplicationArea = All;
                    Caption = 'Aging (271-360)';
                }
                field(Aging5; Rec.Aging5)
                {
                    ApplicationArea = All;
                    Caption = 'Aging (>360)';
                }
                field("Orig Doc. No"; Rec."Orig Doc. No")
                {
                    ApplicationArea = All;
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Inbound Entry No."; Rec."Inbound Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Document Reff No."; Rec."Document Reff No.")
                {
                    ApplicationArea = All;
                }
                field("Date Doc. Reff"; Rec."Date Doc. Reff")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
