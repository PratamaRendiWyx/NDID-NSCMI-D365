tableextension 50712 ProdOrderRoutingLine_PQ extends "Prod. Order Routing Line"
{
    fields
    {
        // Add changes to table fields here
        field(50700; "CCS Spec. Type ID"; Code[20])
        {
            Caption = 'Specification No.';
            Description = 'QC 200.02';
            DataClassification = CustomerContent;
            TableRelation = QCSpecificationHeader_PQ.Type;
            Editable = false;
        }
        field(50701; "CCS Quality Test No."; Code[20])
        {
            Caption = 'Quality Test No.';
            Description = 'QC 200.02';
            DataClassification = CustomerContent;
            TableRelation = QualityTestHeader_PQ where("Item No." = field("Routing No."));
            //Editable = false;
        }
        field(50702; "CCS QC Updated"; Boolean)
        {
            Caption = 'Quality Test Updated';
            Description = 'QC 200.02';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50710; "Needed Time"; Decimal)
        {
            CalcFormula = Sum("Prod. Order Capacity Need"."Needed Time" WHERE("Prod. Order No." = FIELD("Prod. Order No."),
                                                                               "Operation No." = FIELD("Operation No.")));
            Caption = 'Needed Time';
            Description = 'MP7.0.05 Flowfield Added';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50711; "Allocated Time"; Decimal)
        {
            CalcFormula = Sum("Prod. Order Capacity Need"."Allocated Time" WHERE("Prod. Order No." = FIELD("Prod. Order No."),
                                                                                  "Operation No." = FIELD("Operation No.")));
            Caption = 'Allocated Time';
            Description = 'MP7.0.05 Flowfield Added';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50712; "Actual Time Qty"; Decimal)
        {
            CalcFormula = Sum("Capacity Ledger Entry".Quantity WHERE("Document No." = FIELD("Prod. Order No."),
                                                                      "Work Center No." = FIELD("Work Center No."),
                                                                      "No." = FIELD("No.")));
            Caption = 'Actual Time Qty';
            DecimalPlaces = 0 : 5;
            Description = 'MP9.0.4';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50713; "Actual Output Qty"; Decimal)
        {
            CalcFormula = Sum("Capacity Ledger Entry"."Output Quantity" WHERE("Order No." = FIELD("Prod. Order No."),
                                                                               "Order Type" = CONST(Production),
                                                                               "Operation No." = FIELD("Operation No."),
                                                                               "Order Line No." = field("Routing Reference No.")
                                                                               ));
            Caption = 'Actual Output Qty';
            Description = 'MP10.0.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50714; "Indentation"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Indentation';
        }
        field(50715; "Parent Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
        }
        field(50716; "Parent Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50717; "Parent Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
        }
        field(50718; "Parent Starting Date-Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Starting Date-Time';
        }
        field(50719; "Parent Ending Date-Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Ending Date-Time';
        }

        field(50720; "PQ Operation No."; Code[10])
        {
            Caption = 'Operation No.';
            DataClassification = CustomerContent;
        }
        field(50721; "Fixed Run Time"; Boolean)
        {
            Caption = 'Fixed Run Time';
        }
        field(50722; "Item Output"; Code[20])
        {
            //
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line"."Item No." where("Prod. Order No." = field("Prod. Order No."), "Line No." = field("Routing Reference No."), Status = field(Status)));
            Editable = false;
        }
        field(50723; "Finished Qty."; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line"."Finished Quantity" where("Prod. Order No." = field("Prod. Order No."), "Line No." = field("Routing Reference No."), Status = field(Status)));
            Editable = false;
        }

        modify("Routing Status")
        {
            trigger OnBeforeValidate()
            begin
                if ("CCS Quality Test No." <> '') and not "CCS QC Updated" then
                    error(Txt001, "CCS Quality Test No.");
            end;
        }
    }

    var
        Txt001: Label 'Status can only be updated through the Quality Test %1.';
}