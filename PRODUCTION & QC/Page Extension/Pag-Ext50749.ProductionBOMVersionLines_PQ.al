pageextension 50749 ProductionBOMVersionLines_PQ extends "Production BOM Version Lines"
{

    layout
    {
        addafter(Description)
        {
            field(AMComment; Rec.Comment)
            {
                Caption = 'Comment';
                ApplicationArea = All;
            }
        }
        addafter("Ending Date")
        {
            field("BOM Number"; Rec."BOM Number")
            {
                ApplicationArea = All;
                Caption = 'BOM Number';
                DrillDownPageID = "Production BOM";
                ToolTip = 'Displays the Prod. BOM No.';
            }
            field("Item Flushing Method"; Rec."Item Flushing Method")
            {
                ApplicationArea = All;
                Caption = 'Item Flushing Method';
                ToolTip = 'Displays how the item is set to flush through the system.';
            }
            field("Routing Number"; Rec."Routing Number")
            {
                ApplicationArea = All;
                Caption = 'Routing Number';
                DrillDownPageID = Routing;
            }
        }
    }
    actions
    {
        addafter("&Component")
        {
            group(ActionGroup1907989304)
            {
                Caption = '&Component';
                Image = Components;
            }
        }
        addafter("&Component")
        {
            action(ViewBOM)
            {
                ApplicationArea = All;
                Caption = 'View &BOM';
                Image = ViewDetails;
            }
            action(ViewRouter)
            {
                ApplicationArea = All;
                Caption = 'View &Routing';
                Image = ViewDetails;
            }
        }
    }
}

