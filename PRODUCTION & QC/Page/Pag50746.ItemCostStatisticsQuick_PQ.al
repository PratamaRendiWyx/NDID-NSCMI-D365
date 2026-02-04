page 50746 ItemCostStatisticsQuick_PQ
{
    // version MP13.0.00

    Caption = 'Item Cost Statistics Quick Edit';
    PageType = List;
    SourceTable = ItemCostStatistics_PQ;

    layout
    {
        area(content)
        {
            repeater(Control14004557)
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
                field("New Cost Factor"; Rec."New Cost Factor")
                {
                    ApplicationArea = All;
                    ToolTip = 'New Cost Factor beign applied to cost calculation.';
                }
                field("Lot Size"; Rec."Lot Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Current Lot Size';
                }
                field("New Lot Size"; Rec."New Lot Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'What do you want to change the Lot Size to';
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Percent increase in cost for indirect cost';
                }
                field("New Indirect Cost %"; Rec."New Indirect Cost %")
                {
                    ApplicationArea = All;
                    ToolTip = 'What is the new indirect cost % of the Item';
                }
                field("Scrap %"; Rec."Scrap %")
                {
                    ApplicationArea = All;
                    ToolTip = 'how much scrap is associated with the Item';
                }
                field("New Scrap %"; Rec."New Scrap %")
                {
                    ApplicationArea = All;
                    ToolTip = 'How much scrap do you produce';
                }
                field("Overhead Rate"; Rec."Overhead Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'How much overhead is applied to the Item cost';
                }
                field("New Overhead Rate"; Rec."New Overhead Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'How much overhead should be applied to the item cost';
                }
                field("New Calculation Date"; Rec."New Calculation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'What date will be used in cost calculations.';
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Productin BOM used to build the Item';
                }
                field("Last CurrCost Calc BOM Rev."; Rec."Last CurrCost Calc BOM Rev.")
                {
                    ApplicationArea = All;
                    Caption = 'Last BOM Rev.';
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

