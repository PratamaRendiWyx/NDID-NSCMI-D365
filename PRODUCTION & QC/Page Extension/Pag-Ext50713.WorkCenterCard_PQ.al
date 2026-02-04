pageextension 50713 WorkCenterCard_PQ extends "Work Center Card"
{
    layout
    {
        addbefore(Blocked)
        {
          field("Quality";Rec."CCS Quality")
          {
              ApplicationArea = All;
          }
          field("Spec. Type ID";Rec."CCS Spec. Type ID")
          {
              ApplicationArea = All;
              Editable = Rec."CCS Quality";
          }
        }

        addafter("Last Date Modified")
        {
            field("Current Capacity Need"; Rec."Current Capacity Need")
            {
                ApplicationArea = All;
                Caption = 'Current Capacity Need';
                ToolTip = 'Sum Flow Field to Prod. Order Capacity Need Table.';
            }
            field("Allocated Time"; Rec."Allocated Time")
            {
                ApplicationArea = All;
                Caption = 'Allocated TIme';
                ToolTip = 'The amount of Time allocated to this Work Center';
            }
            field("Machine Center Count"; Rec."Machine Center Count")
            {
                ApplicationArea = All;
                Caption = 'Machine Center Count';
                ToolTip = 'Count of the number of Machine Centers assoicated to this work center';
            }
        }

        modify(Warehouse)
        {
            Visible = false;
        }
        addfirst(FactBoxes)
        {
            part(Control1240070005; WorkCenterStatsFactbox_PQ)
            {
                Caption = 'Work Center Statistics';
                ApplicationArea = All;
                SubPageLink = "No." = FIELD(FILTER("No."));
                Visible = false;
            }
        }
    }

    actions
    {
        modify("Capacity Ledger E&ntries")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category4;
        }
        modify("Co&mments")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category4;
        }
        modify("Ta&sk List")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category5;
        }
        modify("Subcontractor - Dispatch List")
        {
            Promoted = true;
            PromotedIsBig = true;
        }
    }
}