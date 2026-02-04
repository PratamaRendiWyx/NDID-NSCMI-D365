page 50754 ItemDemandFactbox_PQ
{
    // version MP13.0.00

    // FP7.0.07
    //         - Added "Qty. On Job Order", and adjusted Net Demand Formulas accordingly
    // 
    // FP8.0.08
    //   - Added Field "Qty. on Asm. Component" from Page 30, and Added to Calculations in OnAfterGetRecord Trigger
    //   - Added Field "Qty. on Assembly Order" to NetSupply Calculation

    Caption = 'Demand';
    Editable = false;
    PageType = CardPart;
    SourceTable = Item;
    SourceTableView = SORTING("No.");

    layout
    {
        area(content)
        {
            field("Qty. on Component Lines"; Rec."Qty. on Component Lines")
            {
                ApplicationArea = All;
            }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = All;
            }
            field("Qty. on Service Order"; Rec."Qty. on Service Order")
            {
                ApplicationArea = All;
            }
            field("Qty. on Job Order"; Rec."Qty. on Job Order")
            {
                ApplicationArea = All;
            }
            field("Qty. on Asm. Component"; Rec."Qty. on Asm. Component")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field(NetDemand; NetDemand)
            {
                ApplicationArea = All;
                Caption = 'Net Demand';
                DecimalPlaces = 0 : 0;
            }
            field(NetAvailable; NetAvailable)
            {
                ApplicationArea = All;
                Caption = 'Net Available';
                DecimalPlaces = 0 : 0;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin

        CalculateFactBox;
    end;

    var
        NetSupply: Decimal;
        NetDemand: Decimal;
        NetAvailable: Decimal;

    local procedure CalculateFactBox()
    begin
        NetSupply := 0;
        NetDemand := 0;
        NetAvailable := 0;

        if Rec."No." <> '' then begin
            Rec.CalcFields(Rec.Inventory, Rec."Qty. on Purch. Order", Rec."Qty. on Prod. Order", Rec."Qty. in Transit",
                       Rec."Purch. Req. Receipt (Qty.)",
                       Rec."Qty. on Sales Order", Rec."Qty. on Service Order", Rec."Qty. on Component Lines", Rec."Qty. on Asm. Component"); //FP0.0.08 - "Qty. on Asm. Component" Added

            NetSupply := Rec.Inventory + Rec."Purch. Req. Receipt (Qty.)" + Rec."Qty. on Purch. Order" +
                            Rec."Qty. on Prod. Order" + Rec."Qty. in Transit" + Rec."Qty. on Assembly Order"; //FP0.0.08 - "Qty. on Assembly Order" Added

            NetDemand := Rec."Qty. on Sales Order" + Rec."Qty. on Service Order" + Rec."Qty. on Component Lines" + Rec."Qty. on Job Order" + Rec."Qty. on Asm. Component"; //FP0.0.08 - "Qty. on Asm. Component" Added

            NetAvailable := NetSupply - NetDemand;
        end;
    end;
}

