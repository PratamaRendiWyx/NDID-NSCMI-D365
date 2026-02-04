pageextension 50729 FinishedProdOrderLines_PQ extends "Finished Prod. Order Lines"
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
        addafter("Shortcut Dimension 2 Code")
        {
            field("Est Material Cost"; Rec."Est Material Cost")
            {
                Caption = 'Est Material Cost';
                ApplicationArea = All;
                ToolTip = 'Displays the Estimated cost from the Component Lines';
            }
            field("AM Act Material Cost"; Rec."Act Material Cost")
            {
                Caption = 'Act Material Cost';
                ApplicationArea = All;
                ToolTip = 'Displays actual material cost posted against the line';
            }
            field("Est Capacity Cost"; Rec."Est Capacity Cost")
            {
                ApplicationArea = All;
                Caption = 'Est. Capacity Cost';
                ToolTip = 'Displays Est. cost from the Routing lines';
            }
            field("Act Capacity Cost"; Rec."Act Capacity Cost")
            {
                Caption = 'Act Capacity Cost';
                ApplicationArea = All;
                ToolTip = 'Displays actual capacity cost posted against the line';
            }
        }
    }
}