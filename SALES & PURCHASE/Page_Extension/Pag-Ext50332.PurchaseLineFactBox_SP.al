pageextension 50332 "Purchase Line FactBox_SP" extends "Purchase Line FactBox"
{
    layout
    {
        addafter(Availability)
        {
            field("Quantity Available"; CalcAvailableInventory(Rec))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Quantity Available';
                DecimalPlaces = 0 : 5;
                ToolTip = 'Specifies the quantity of the item that is currently in inventory and not reserved for other demand.';
            }
        }
    }

    procedure CalcAvailableInventory(var PurchLine: Record "Purchase Line"): Decimal
    begin
        if GetItem(PurchLine) then begin
            SetItemFilter(Item, PurchLine);
            exit(
              ConvertQty(
                AvailableToPromise.CalcAvailableInventory(Item),
                PurchLine."Qty. per Unit of Measure"));
        end;
    end;

    local procedure ConvertQty(Qty: Decimal; PerUoMQty: Decimal) Result: Decimal
    begin
        if PerUoMQty = 0 then
            PerUoMQty := 1;
        Result := Round(Qty / PerUoMQty, UOMMgt.QtyRndPrecision());
    end;

    local procedure GetItem(var PurchLine: Record "Purchase Line") Result: Boolean
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit(Result);

        if (PurchLine.Type <> PurchLine.Type::Item) or (PurchLine."No." = '') then
            exit(false);

        if PurchLine."No." <> Item."No." then
            Item.Get(PurchLine."No.");

        exit(true);
    end;

    local procedure SetItemFilter(var Item: Record Item; var PurchLine: Record "Purchase Line")
    begin
        Item.Reset();
        Item.SetRange("Date Filter", 0D, CalcAvailabilityDate(PurchLine));
        Item.SetRange("Variant Filter", PurchLine."Variant Code");
        Item.SetRange("Location Filter", PurchLine."Location Code");
        Item.SetRange("Drop Shipment Filter", PurchLine."Drop Shipment");
    end;

    procedure CalcAvailabilityDate(var PurchLine: Record "Purchase Line") AvailabilityDate: Date
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit(AvailabilityDate);

        if PurchLine."Planned Receipt Date" <> 0D then
            exit(PurchLine."Planned Receipt Date");

        exit(WorkDate());
    end;

    var
        Item: Record Item;
        AvailableToPromise: Codeunit "Available to Promise";
        UOMMgt: Codeunit "Unit of Measure Management";

}

