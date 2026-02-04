page 50307 ShipmentLineCOAQCActivities_SP
{
    Caption = 'BOP QC - (Review)';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = SaleShipmentLineCOAQC_SP;
    Permissions = tabledata SaleShipmentLineCOAQC_SP = rm;

    layout
    {
        area(Content)
        {
            cuegroup(Control54)
            {
                Caption = 'Shipment Lines - QC';
                field("Open - Qty"; Rec."Open - Qty")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Sales Shipment Lines";
                }

                field("In-Process - Qty"; Rec."In-Process - Qty")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Sales Shipment Lines";
                }

                field("Ready for Review - Qty"; Rec."Ready for Review - Qty")
                {
                    ApplicationArea = Basic, Suite;
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
