pageextension 50723 PlannedProdOrderLines_PQ extends "Planned Prod. Order Lines"
{
    layout
    {
        modify("Due Date")
        {
            Visible = false;
        }
        modify("Starting Date-Time")
        {
            Visible = false;
        }
        modify("Ending Date-Time")
        {
            Visible = false;
        }
        modify("Production BOM No.")
        {
            Visible = true;
        }

        modify("Routing No.")
        {
            Visible = true;
        }
        addafter("ShortcutDimCode[8]")
        {
            field("Est Material Cost"; Rec."Est Material Cost")
            {
                Caption = 'Est Material Cost';
                ApplicationArea = All;
                ToolTip = 'Displays Estimated Cost from the BOM Lines';
            }
            field("Act Material Cost"; Rec."Act Material Cost")
            {
                Caption = 'Act Material Cost';
                ApplicationArea = All;
                ToolTip = 'Shows the Actual cost posted to the Prod. Order Line';
            }
            field("Est Capacity Cost"; Rec."Est Capacity Cost")
            {
                ApplicationArea = All;
                Caption = 'Est. Capacity Cost';
                ToolTip = 'Displays Estimated Capacity based on the Router';
            }
            field("Act Capacity Cost"; Rec."Act Capacity Cost")
            {
                Caption = 'Act Capacity Cost';
                ApplicationArea = All;
                ToolTip = 'Displays Posted Capacity Costs';
            }
        }
    }

}