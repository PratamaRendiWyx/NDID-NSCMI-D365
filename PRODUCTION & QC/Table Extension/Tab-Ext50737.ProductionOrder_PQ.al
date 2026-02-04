tableextension 50737 "Production Order PQ" extends "Production Order"
{
    fields
    {
        field(50700; IsSplitProcess; Boolean)
        {
            Caption = 'Is Split Process (?)';
            DataClassification = ToBeClassified;
        }
        field(50701; "Shift"; Code[20])
        {
            Caption = 'Shift';
            TableRelation = "Work Shift".Code;
        }
        field(50702; "Production Line"; Code[20])
        {
            Caption = 'Production Line';
            TableRelation = "Production Line".Code where("Item No." = field("Source No."));
            trigger OnValidate()
            var
                myInt: Integer;
                ProductionLine: Record "Production Line";
            begin
                Clear(ProductionLine);
                ProductionLine.SetRange("Item No.", "Source No.");
                ProductionLine.SetRange(Code, "Production Line");
                if ProductionLine.Find('-') then
                    "Capacity Line" := ProductionLine."Capacity Line";
            end;
        }
        field(50703; "Capacity Line"; Decimal)
        {
            Caption = 'Capacity Line';
            Editable = false;
        }
        field(50704; "Index"; Integer)
        {
            Caption = 'Index';
        }
        field(50705; "Ref. Order No."; Code[20])
        {
            Caption = 'Ref. Order No.';
        }
        field(50706; "Work Sheet Template Name"; Code[10])
        {
            Caption = 'Work Sheet Template Name';
        }
        field(50707; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(50708; "Requition Line No."; Integer)
        {
            Caption = 'Requition Line No.';
        }
        field(50709; "Start Date-Time (Production)"; DateTime)
        {
            Caption = 'Starting Date-Time (Production)';
        }
        field(50710; "End Date-Time (Production)"; DateTime)
        {
            Caption = 'Ending Date-Time (Production)';
        }
        field(50711; "Preparing Status"; Enum "Preparing Status")
        {
            Caption = 'Preparing Status';
        }
        field(50712; "Production Status"; Enum "Production Status")
        {
            Caption = 'Production Status';
        }
        field(50713; "Vacum Cycle"; Code[20])
        {
            Caption = 'Cycle';
        }
        field(50714; "Capacity Mix"; Decimal)
        {
            Caption = 'Capacity Mix';
            Editable = false;
        }
        field(50715; "Product Type"; Enum "Product Type")
        {
            Caption = 'Product Type';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Product Type" where("No." = field("Source No.")));
        }
        field(50716; "Is Subcon (?)"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Is Subcon (?)" where("No." = field("Source No.")));
            Editable = false;
        }

        field(50717; "Remarks"; Text[250])
        {
            Caption = 'Remarks';
        }
        field(50718; "Is Substitute (?)"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Prod. Order Component" where("Prod. Order No." = field("No."), "Original Item No." = filter('<>''''')));
        }

    }
}
