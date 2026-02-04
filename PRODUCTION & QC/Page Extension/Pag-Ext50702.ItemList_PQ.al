pageextension 50702 ItemList_PQ extends "Item List"
{
    layout
    {
        addafter(InventoryField)
        {
            field("Qty. on Hand Unrestricted"; Rec."Inventory Available")
            {
                ApplicationArea = All;
                Editable = false;
                DecimalPlaces = 0 : 5;
                Importance = Promoted;
                HideValue = IsNonInventoriable;
                ToolTip = 'Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.';
            }
        }
    }
    actions
    {
        addafter(Action126)
        {
            group("Quality")
            {
                Caption = 'Quality';
                Image = InventoryPick;
                action("AM Quality Requirements")
                {
                    ApplicationArea = All;
                    Caption = 'Quality Requirements';
                    Image = InventoryPick;
                    RunObject = Page ItemQualityRequirement_PQ;
                    RunPageLink = "Item No." = FIELD("No.");
                    ToolTip = 'Specifies quality requirements lists for the item.';
                }
            }
        }
        addafter(Action24)
        {
            action("Cost Change &Log")
            {
                ApplicationArea = All;
                Caption = 'Cost Change &Log';
                Image = Log;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page CostChangeLog_PQ;
                RunPageLink = "Item No." = FIELD("No.");
            }
        }

        
        modify(Action29)
        {
            Visible = false;
        }

        addafter(Action29)
        {
            action("PQ Where-Used")
            {
                AccessByPermission = TableData "BOM Component" = R;
                ApplicationArea = Manufacturing;
                Caption = 'Where-Used';
                Image = "Where-Used";
                ToolTip = 'View a list of BOMs in which the item is used.';

                trigger OnAction()
                var
                    ProdBOMWhereUsed: Page ProdBOMWhereUsed_PQ;
                begin
                    ProdBOMWhereUsed.SetItem(Rec, WorkDate);
                    ProdBOMWhereUsed.RunModal;
                end;
            }
        }
    }
}
