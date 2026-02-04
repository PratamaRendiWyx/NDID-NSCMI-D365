page 50729 ItemLotandSerialLookup_PQ
{
    // version QC10.2

    Caption = 'Item Lot and Serial Lookup';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "Item Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No.";Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Tracking";Rec."Item Tracking")
                {
                    ApplicationArea = All;
                }
                field("Lot No.";Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Serial No.";Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

