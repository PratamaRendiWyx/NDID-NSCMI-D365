table 50731 "Additional Item Output"
{
    Caption = 'Additional Item Output';
    DrillDownPageID = "Additional Item Outputs";
    LookupPageID = "Additional Item Outputs";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = Item where(Type = filter(Inventory | "Non-Inventory"));
            trigger OnValidate()
            var
                myInt: Integer;
                Item: Record Item;
            begin
                if Code <> '' then begin
                    Item.Get(Code);
                    Description := Item.Description;
                end;
            end;
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; "Quantity (Base) Per"; Decimal)
        {
            Caption = 'Quantity (Base) Per';
        }
        field(5; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.';
            TableRelation = "Production BOM Header"."No." where(Status = const(Certified));
        }
        field(6; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header";
        }
        field(7; Type; Enum "Type Additional Output")
        {
            Caption = 'Type';
        }
        // field(8; "Percentage Add. Output"; Decimal)
        // {
        //     Caption = 'Percentage Add. Output (%)';
        // }
    }
    keys
    {
        key(PK; "Item No.", Code)
        {
            Clustered = true;
        }
    }

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateProductionBOMNo(var Item: Record "Additional Item Output"; xItem: Record "Additional Item Output"; var IsHandled: Boolean)
    begin
    end;
}
