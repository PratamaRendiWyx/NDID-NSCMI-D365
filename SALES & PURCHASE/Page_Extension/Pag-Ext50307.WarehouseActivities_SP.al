pageextension 50307 WarehouseActivities_SP extends WarehouseActivities_FT
{
    layout
    {
        modify("Exp. Purch. Orders Until Today")
        {
            Visible = false;
        }
        addafter("Exp. Purch. Orders Until Today")
        {
            field("Rel. Purch. Orders Until Today";Rec."Rel. Purch. Orders Until Today")
            {
                ApplicationArea = Warehouse;
                Caption = 'PO Release Until Today';
                DrillDownPageID = "Purchase Order List";
                ToolTip = 'Specifies the number of expected purchase orders that are displayed in the Basic Warehouse Cue on the Role Center. The documents are filtered by today''s date.';
            }
        }
    }
}