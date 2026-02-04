page 50305 "Link Shipping Mark Information"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Link Shipping Mark Information';
    PageType = List;
    SourceTable = "Link Shipping Mark Information";
    SourceTableView = SORTING("Entry No", "Source ID", "Source Ref. No.", "Lot No.")
                      ORDER(ascending) where(IsPosted = const(false));
    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                }
                field("Source Subtype"; Rec."Source Subtype")
                {
                    ApplicationArea = All;
                }
                field("Source ID"; Rec."Source ID")
                {
                    ApplicationArea = All;
                }
                field("Source Ref. No."; Rec."Source Ref. No.")
                {
                    ApplicationArea = All;
                }
                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Shipping Mark No."; Rec."Shipping Mark No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
