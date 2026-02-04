page 50723 ItemSerialNoInfoList_PQ
{
    // version QC10.1 - OBSOLETE?

    // //QC7.3
    //   - Added "Item Tracing" Action

    Caption = 'Item Serial No. Info. List';
    Editable = false;
    PageType = List;
    SourceTable = "Serial No. Information";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    ToolTip = 'Displays the Item No';
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Editable = false;
                    ToolTip = 'Displays any variant code related to the item';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    Editable = false;
                    ToolTip = 'Displays the Serial Number for the item';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Displays the item description';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Indicates if this item is blocked';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    Editable = false;
                    ToolTip = 'Indicates if there is a comment for this item/serial number';
                    ApplicationArea = All;
                }
                field(Inventory; Rec.Inventory)
                {
                    Editable = false;
                    ToolTip = 'Displays the quantity on hand for this item';
                    ApplicationArea = All;
                }
                // field("Date Filter";"Date Filter")
                // {
                //     ToolTip = 'Allows the user to set a date filter on the list';
                //     ApplicationArea = All;
                // }
                // field("Location Filter";"Location Filter")
                // {
                //     ToolTip = 'Allows the user to set a location filter on the list';
                //     ApplicationArea = All;
                // }
                // field("Bin Filter";"Bin Filter")
                // {
                //     ToolTip = 'Allows the user to set a bin filter on the list';
                //     ApplicationArea = All;
                // }
                field("Expired Inventory"; Rec."Expired Inventory")
                {
                    ToolTip = 'Indicates if this is expired inventory';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Item Tracing")
            {
                Caption = 'Item Tracing';
                Image = ItemTracing;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Tracing";
                ToolTip = 'View Item Tracing Information';
                ApplicationArea = All;
            }
        }
    }
}

