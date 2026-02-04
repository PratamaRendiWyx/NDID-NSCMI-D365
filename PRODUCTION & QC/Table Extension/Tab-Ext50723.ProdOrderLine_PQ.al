tableextension 50723 ProdOrderLine_PQ extends "Prod. Order Line"
{

    fields
    {
        field(52100; "Act Material Cost"; Decimal)
        {
            CalcFormula = - Sum("Value Entry"."Cost Amount (Actual)" WHERE("Order Type" = CONST(Production),
                                                                           "Order No." = FIELD("Prod. Order No."),
                                                                           "Order Line No." = FIELD("Line No."),
                                                                           "Item Ledger Entry Type" = CONST(Consumption)));
            Caption = 'Act Material Cost';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52110; "Act Capacity Cost"; Decimal)
        {
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Order Type" = CONST(Production),
                                                                          "Order No." = FIELD("Prod. Order No."),
                                                                          "Order Line No." = FIELD("Line No."),
                                                                          "Capacity Ledger Entry No." = FILTER(<> 0)));
            Caption = 'Act Capacity Cost';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52120; "Est Material Cost"; Decimal)
        {
            CalcFormula = Sum("Prod. Order Component"."Cost Amount" WHERE(Status = FIELD(Status),
                                                                           "Prod. Order No." = FIELD("Prod. Order No."),
                                                                           "Prod. Order Line No." = FIELD("Line No.")));
            Caption = 'Est. Material Cost';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52130; "Est Capacity Cost"; Decimal)
        {
            CalcFormula = Sum("Prod. Order Routing Line"."Expected Operation Cost Amt." WHERE(Status = FIELD(Status),
                                                                                               "Prod. Order No." = FIELD("Prod. Order No."),
                                                                                               "Routing No." = FIELD("Routing No."),
                                                                                               "Routing Reference No." = FIELD("Routing Reference No.")));
            Caption = 'Est. Capacity Cost';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52131; "Qty. NG"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = SUm("New Detail NG QT V1 PQ".Quantity where("Order No." = field("Prod. Order No."), "Order Line No." = field("Line No.")));
            Editable = false;
        }
    }
}

