pageextension 50738 ReqWorksheet_PQ extends "Req. Worksheet"
{

    layout
    {
        addafter("Blanket Purch. Order Exists")
        {
            field("Cost Amount"; Rec."Cost Amount")
            {
                Caption = 'Cost Amount';
                ApplicationArea = All;
            }
        }
        addfirst(FactBoxes)
        {
            part("Item Supply Factbox"; ItemSupplyFactbox_PQ)
            {
                ApplicationArea = All;
                Caption = 'Item Supply Factbox';
                SubPageLink = "No." = FIELD("No.");
                SubPageView = SORTING("No.");
            }
            part("Item Demand Factbox"; ItemDemandFactbox_PQ)
            {
                ApplicationArea = All;
                Caption = 'Item Demand Factbox';
                SubPageLink = "No." = FIELD("No.");
                SubPageView = SORTING("No.");
            }
            part("Req. Worksheet Totals"; ReqWkshtFactbox_PQ)
            {
                ApplicationArea = All;
                Caption = 'Worksheet Totals';
                SubPageLink = "Worksheet Template Name" = FIELD("Worksheet Template Name"),
                              "Journal Batch Name" = FIELD("Journal Batch Name"),
                              "Line No." = FIELD("Line No.");
            }
        }
    }
}

