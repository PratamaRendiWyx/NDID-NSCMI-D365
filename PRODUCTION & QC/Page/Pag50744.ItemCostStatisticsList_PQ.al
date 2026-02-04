page 50744 ItemCostStatisticsList_PQ
{

    ApplicationArea = All;
    Caption = 'Item Cost Statistics List';
    Editable = false;
    PageType = List;
    SourceTable = ItemCostStatistics_PQ;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control14004550)
            {
                ShowCaption = false;
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Item Description';
                }
                field("Lot Size"; Rec."Lot Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Current Lot Size';
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Percent increase in cost for indirect cost';
                }
                field("Overhead Rate"; Rec."Overhead Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'How much overhead is applied to the Item cost';
                }
                field("Scrap %"; Rec."Scrap %")
                {
                    ApplicationArea = All;
                    ToolTip = 'how much scrap is associated with the Item';
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Productin BOM used to build the Item';
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Routing used to build the Item';
                }
                field("Current Cost"; Rec."Current Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Current cost associated with making the item.';
                }
                field("Standard Cost"; Rec."Standard Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'The standard cost of the Item.';
                }
            }
        }
    }

    actions
    {
    }
}

