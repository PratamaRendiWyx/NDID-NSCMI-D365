page 50306 ShipmentLineCOAActivities_SP
{
    Caption = 'BOP (Approvals)';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = SaleShipmentLineCOA_SP;
    Permissions = tabledata SaleShipmentLineCOA_SP = RMID;

    layout
    {
        area(Content)
        {
            cuegroup(Control54)
            {
                Caption = 'Shipment Lines - Approval';
                field("Need to Approve - Qty"; Rec."Need to Approve - Qty")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Posted Sales Shipment Lines";
                }

                field("Approved - Qty"; Rec."Approved - Qty")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Posted Sales Shipment Lines";
                }

                field("Rejected - Qty"; Rec."Rejected - Qty")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Posted Sales Shipment Lines";
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
    end;
}
