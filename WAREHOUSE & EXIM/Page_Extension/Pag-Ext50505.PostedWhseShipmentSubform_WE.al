pageextension 50505 PostedWhseShipmentSubform_WE extends "Posted Whse. Shipment Subform"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
        }
    }

    actions
    {
        addafter("Whse. Document Line")
        {
            action("Sales. Document Line")
            {
                ApplicationArea = Warehouse;
                Caption = 'Sales Shipment Lines';
                Image = AllLines;
                ToolTip = 'View the line on sales shipment.';
                trigger OnAction()
                begin
                    ShowsaleLine();
                end;
            }
        }
    }

    local procedure ShowsaleLine()
    begin
        ShowPostedWhseShptLine(Rec."Posted Source No.");
    end;

    procedure ShowPostedWhseShptLine(SalesShipDocNo: Code[20])
    var
        PostedSalesShipmentLine: Record "Sales Shipment Line";
    begin
        PostedSalesShipmentLine.Reset();
        PostedSalesShipmentLine.SetCurrentKey("Document No.", "Line No.");
        PostedSalesShipmentLine.SetRange("Document No.", SalesShipDocNo);
        PAGE.RunModal(PAGE::"Posted Sales Shipment Lines", PostedSalesShipmentLine);
    end;
}
