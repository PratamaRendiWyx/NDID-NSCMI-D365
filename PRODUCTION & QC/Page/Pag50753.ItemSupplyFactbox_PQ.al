page 50753 ItemSupplyFactbox_PQ
{

    // FP7.0.12
    //   - Changed Captions on "Purch. Req. Receipt (Qty.)" and "Qty. in Transit" fields for a "consistent look"
    // 
    // FP8.0.08
    //   - Moved Field "Qty. on Assembly Order" here from Page 30. Added to CALCFIELDS and NetSupply Calculation

    Caption = 'Supply';
    Editable = false;
    PageType = CardPart;
    SourceTable = Item;
    SourceTableView = SORTING("No.");

    layout
    {
        area(content)
        {
            field(Inventory; Rec.Inventory)
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    ItemLedgEntry: Record "Item Ledger Entry";
                    ValueEntryT: Record "Value Entry";
                begin
                    //FP
                    //add two local variables
                    ValueEntryT.SetRange("Item No.", Rec."No.");
                    Rec.CopyFilter(Rec."Global Dimension 1 Filter", ValueEntryT."Global Dimension 1 Code");
                    Rec.CopyFilter(Rec."Global Dimension 2 Filter", ValueEntryT."Global Dimension 2 Code");
                    Rec.CopyFilter(Rec."Location Filter", ValueEntryT."Location Code");
                    Rec.CopyFilter(Rec."Variant Filter", ValueEntryT."Variant Code");
                    //ItemLedgEntry.DrillDownOnEntries(ValueEntryT);

                    //code from the item Ledger entry table
                    ItemLedgEntry.Reset;
                    ValueEntryT.CopyFilter("Item No.", ItemLedgEntry."Item No.");
                    //ValueEntryT.COPYFILTER("Location Code",ItemLedgEntry."Location Code");
                    //ValueEntryT.COPYFILTER("Variant Code",ItemLedgEntry."Variant Code");
                    //ValueEntryT.COPYFILTER("Global Dimension 1 Code",ItemLedgEntry."Global Dimension 1 Code");
                    //ItemLedgEntry.SETCURRENTKEY("Item No.","Posting Date");
                    ItemLedgEntry.SetFilter("Remaining Quantity", '<>%1', 0);
                    PAGE.Run(0, ItemLedgEntry, ItemLedgEntry."Remaining Quantity");
                end;
            }
            field("Purch. Req. Receipt (Qty.)"; Rec."Purch. Req. Receipt (Qty.)")
            {
                ApplicationArea = All;
                Caption = 'Qty. on Req. Worksheet';
            }
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = All;
            }
            field("Qty. on Prod. Order"; Rec."Qty. on Prod. Order")
            {
                ApplicationArea = All;
            }
            field("Qty. in Transit"; Rec."Qty. in Transit")
            {
                ApplicationArea = All;
                Caption = 'Qty on Transit Order';
            }
            field("Qty. on Assembly Order"; Rec."Qty. on Assembly Order")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field(NetSupply; NetSupply)
            {
                ApplicationArea = All;
                Caption = 'Net Supply';
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

    local procedure CalculateFactBox()
    begin
        NetSupply := 0;

        if Rec."No." <> '' then begin
            Rec.CalcFields(Rec.Inventory, Rec."Qty. on Purch. Order", Rec."Qty. on Prod. Order", Rec."Qty. in Transit",
                       Rec."Purch. Req. Receipt (Qty.)", Rec."Qty. on Assembly Order"); //FP8.0.08 "Qty. on Assembly Order" added

            NetSupply := Rec.Inventory + Rec."Purch. Req. Receipt (Qty.)" + Rec."Qty. on Purch. Order" +
                            Rec."Qty. on Prod. Order" + Rec."Qty. in Transit" + Rec."Qty. on Assembly Order"; //FP8.0.08 "Qty. on Assembly Order" added
        end;
    end;
}

