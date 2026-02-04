page 50500 "Packing Shipments List"
{
    ApplicationArea = Basic, Suite, Assembly;
    Caption = 'Packing Shipment List';
    CardPageID = "Packing Shipment";
    DataCaptionFields = "No.";
    Editable = false;
    PageType = List;
    QueryCategory = 'Packing Shipment List';
    RefreshOnActivate = true;
    SourceTable = "Pack. Header";
    UsageCategory = History;
    DeleteAllowed = false;



    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.") { ApplicationArea = Warehouse; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = Warehouse; }
                field("Shipment Date"; Rec."Shipment Date") { ApplicationArea = Warehouse; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = Warehouse; }
                field("Shipping Mark No."; Rec."Shipping Mark No.") { ApplicationArea = Warehouse; }
                field(Status; Rec.Status) { ApplicationArea = Warehouse; }
                field(IsCancel; Rec.IsCancel) { ApplicationArea = Warehouse; }
            }
        }
    }
}
