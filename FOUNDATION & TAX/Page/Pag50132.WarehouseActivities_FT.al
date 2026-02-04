page 50132 WarehouseActivities_FT
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Warehouse Basic Cue";

    layout
    {
        area(content)
        {
            cuegroup("Outbound - Today")
            {
                Caption = 'Outbound - Today';
                field("Rlsd. Sales Orders Until Today"; Rec."Rlsd. Sales Orders Until Today")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'SO Release Until Today';
                    DrillDown = true;
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of released sales orders that are displayed in the Warehouse Basic Cue on the Role Center. The documents are filtered by today''s date.';
                }

                field("Shipments - Today"; Rec."Shipments - Today")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Delivery';
                    DrillDownPageID = "Warehouse Shipment List";
                    ToolTip = 'Specifies the number of shipments that are displayed in the Warehouse WMS Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Posted Sales Shipments - Today"; Rec."Posted Sales Shipments - Today")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Shipment-Today';
                    DrillDownPageID = "Posted Sales Shipments";
                    ToolTip = 'Specifies the number of posted sales shipments that are displayed in the Basic Warehouse Cue on the Role Center. The documents are filtered by today''s date.';
                }
            }
            cuegroup("Inbound - Today")
            {
                Caption = 'Inbound - Today';
                field("Exp. Purch. Orders Until Today";Rec."Exp. Purch. Orders Until Today")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'PO Release Until Today';
                    DrillDownPageID = "Purchase Order List";
                    ToolTip = 'Specifies the number of expected purchase orders that are displayed in the Basic Warehouse Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Posted Purch. Receipts - Today"; Rec."Posted Purch. Receipts - Today")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Receipt-Today';
                    DrillDownPageID = "Posted Purchase Receipts";
                    ToolTip = 'Specifies the number of posted purchase receipts that are displayed in the Warehouse Basic Cue on the Role Center. The documents are filtered by today''s date.';
                }

            }
            cuegroup(Internal)
            {
                Caption = 'Internal';

                field("TO-Today"; Rec."TO-Today")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Transfer Order';
                    DrillDownPageID = "Transfer Orders";
                    ToolTip = 'Specifies the number of Transfer Orders.';
                }
                field("Open Phys. Invt. Orders"; Rec."Open Phys. Invt. Orders")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Stock Opname';
                    DrillDownPageID = "Physical Inventory Orders";
                    ToolTip = 'Specifies the number of open physical inventory orders.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        Rec.SetRange("Date Filter", 0D, WorkDate());
        Rec.SetRange("Date Filter2", WorkDate(), WorkDate());
        Rec.SetRange("User ID Filter", UserId());

        LocationCode := WhseWMSCue.GetEmployeeLocation(UserId());
        //Rec.SetFilter("Location Filter", LocationCode);
    end;

    var
        WhseWMSCue: Record "Warehouse WMS Cue";
        LocationCode: Text[1024];
}

