pageextension 50736 StandardCostWorksheet_PQ extends "Standard Cost Worksheet"
{
    layout
    {
        addafter(Description)
        {
            field("Qty. On Hand"; Rec."Qty. On Hand")
            {
                Caption = 'Qty. On Hand';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Displays the current Qty on hand for item.';
            }
            field("Current Unit Cost"; Rec."Current Unit Cost")
            {
                Caption = 'Current Unit Cost';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Displays the current Unit Cost of the Item.';
            }
        }
    }
}

