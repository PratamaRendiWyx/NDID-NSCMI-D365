namespace PRODUCTIONQC.PRODUCTIONQC;

using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.Setup;

pageextension 50727 ReleasedProdOrderLines_PQ extends "Released Prod. Order Lines"
{

    layout
    {

        modify("Starting Date-Time")
        {
            Visible = false;
        }
        modify("Ending Date-Time")
        {
            Visible = false;
        }
        addafter("Remaining Quantity")
        {
            field("Qty. NG"; Rec."Qty. NG")
            {
                ApplicationArea = All;
                Enabled = false;
            }
        }
        
        modify("Due Date")
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
        addlast(Control1)
        {
            field("Est Material Cost"; Rec."Est Material Cost")
            {
                Caption = 'Est Material Cost';
                ApplicationArea = All;
                ToolTip = 'Displays the Estimated cost from the Component Lines';
            }
            field("Act Material Cost"; Rec."Act Material Cost")
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
            field(QtyPerUOM; Rec."Qty. per Unit of Measure")
            {
                ApplicationArea = All;
                Editable = true;
            }
        }
    }
    actions
    {
        modify(Routing)
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify(Components)
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify(ItemTrackingLines)
        {
            Promoted = true;
            PromotedCategory = Process;
        }

        addafter("Order &Tracking")
        {
            action("QT NG Input")
            {
                ApplicationArea = All;
                Caption = 'NG Detail (Production)';
                Image = ItemTracing;
                Scope = Repeater;
                ToolTip = 'Input NG Detaiils for QT (Prod. Order Line)';
                trigger OnAction()
                var
                    myInt: Integer;
                    NGDetailsProduction: Page "Detail NG Prod Order";
                    NGDetail: Record "New Detail NG QT V1 PQ";
                begin
                    NGDetailsProduction.setParameter(Rec."Prod. Order No.", Rec."Line No.");
                    Clear(NGDetail);
                    NGDetail.SetRange("Order No.", Rec."Prod. Order No.");
                    NGDetail.SetRange("Order Line No.", Rec."Line No.");
                    NGDetailsProduction.SetTableView(NGDetail);
                    NGDetailsProduction.RunModal();
                end;
            }
        }
    }
}

