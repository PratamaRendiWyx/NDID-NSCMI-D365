tableextension 50725 ProductionBOMLine_PQ extends "Production BOM Line"
{

    fields
    {
        field(50700; "BOM Number"; Code[20])
        {
            CalcFormula = Lookup("Production BOM Header"."No." WHERE("No." = FIELD("No. Filter")));
            Caption = 'BOM Number';
            Description = 'Lookup Flow field';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50701; "Item Flushing Method"; Enum "Flushing Method")
        {
            CalcFormula = Lookup(Item."Flushing Method" WHERE("No." = FIELD("No.")));
            Caption = 'Item Flushing Method';
            Description = 'Lookup Flow field';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50702; "Routing Number"; Code[20])
        {
            CalcFormula = Lookup("Routing Header"."No." WHERE("No." = FIELD("No. Filter Router")));
            Caption = 'Routing Number';
            Description = 'Lookup flow field';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50703; "Replenishment System"; Option)
        {
            CalcFormula = Lookup(Item."Replenishment System" WHERE("No." = FIELD("No.")));
            Caption = 'Replenishment System';
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = Purchase,"Prod. Order",,Assembly,,,,Job;
        }
        field(50704; "Manufacturing Policy"; Enum "Manufacturing Policy")
        {
            CalcFormula = Lookup(Item."Manufacturing Policy" WHERE("No." = FIELD("No.")));
            Caption = 'Manufacturing Policy';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50705; "No. Filter"; Code[20])
        {
            Caption = 'No. Filter';
            FieldClass = FlowFilter;
        } 

        field(50706; "No. Filter Router"; Code[20])
        {
            Caption = 'No. Filter Router';
            FieldClass = FlowFilter;
        }
    }
}



