tableextension 50722 ProdOrderComponent_PQ extends "Prod. Order Component"
{

    fields
    {
        field(52100; "BOM No"; Code[20])
        {
            CalcFormula = Lookup("Production BOM Header"."No." WHERE("No." = FIELD("Item No.")));
            Caption = 'BOM No.';
            Description = 'MP7.0.05 FLOWFIELD Added';
            FieldClass = FlowField;
        }
        field(52110; "Earliest Available Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Earilest Available Date';
            Description = 'MP8.0.1';
        }
        field(52120; "Qty TO."; Decimal)
        {
            Caption = 'Qty. Transfer Orders';
            FieldClass = FlowField;
            CalcFormula = Sum("Transfer Line".Quantity where("Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Prod. Order Line No."),
                             "Prod. Comp. Line No." = field("Line No.")));
        }
        field(52121; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Inventory Posting Group" where("No." = field("Item No.")));
            Editable = false;
        }
        field(52122; "Item Prod. Line"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line"."Item No." where("Prod. Order No." = field("Prod. Order No."), "Line No." = field("Prod. Order Line No.")));
            Editable = false;
        }
        field(52123; "Item Prod. Line Desc"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line".Description where("Prod. Order No." = field("Prod. Order No."), "Line No." = field("Prod. Order Line No.")));
            Editable = false;
        }
        field(52124; "Start Date Time Prod. Line"; DateTime)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Production Order"."Start Date-Time (Production)" where("No." = field("Prod. Order No.")));
            Editable = false;
        }
        field(52125; "End Date Time Prod. Line"; DateTime)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Production Order"."End Date-Time (Production)" where("No." = field("Prod. Order No.")));
            Editable = false;
        }
        field(52126; "Production Line"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Production Order"."Production Line" where("No." = field("Prod. Order No.")));
            Editable = false;
        }
        field(52127; "Finished Qty."; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line"."Finished Quantity" where("Prod. Order No." = field("Prod. Order No."), "Line No." = field("Prod. Order Line No.")));
            Editable = false;
        }
        field(52128; "Production BOM No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line"."Production BOM No." where("Prod. Order No." = field("Prod. Order No."), "Line No." = field("Prod. Order Line No.")));
            Editable = false;
        }
        // field(52127; "Is Substitute"; Boolean)
        // {
        //     Caption = 'Is Substitute (?)';
        // }
    }
}