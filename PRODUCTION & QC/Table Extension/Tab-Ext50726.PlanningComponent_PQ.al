tableextension 50726 PlanningComponent_PQ extends "Planning Component"
{

    fields
    {
        field(50700; "BOM No"; Code[20])
        {
            CalcFormula = Lookup("Production BOM Header"."No." WHERE("No." = FIELD("Item No.")));
            Caption = 'BOM No.';
            Description = 'MP7.0.05 FLOWFIELD Added';
            FieldClass = FlowField;
        }
    }
    trigger OnBeforeInsert()
    var
        myInt: Integer;
        ManufacturingSetup: Record "Manufacturing Setup";
        TempQty: Decimal;
    begin
        ManufacturingSetup.Get();
        if ManufacturingSetup."Buffer Qty. Planning Worksheet" > 0 then begin
            Clear(TempQTY);
            TempQTY := Rec."Expected Quantity";
            TempQTY := TempQTY * ManufacturingSetup."Buffer Qty. Transfer" / 100;
            TempQTY := Round(TempQTY, 1, '>');
            Rec.Validate(Quantity, TempQTY);
        end;
    end;
}
