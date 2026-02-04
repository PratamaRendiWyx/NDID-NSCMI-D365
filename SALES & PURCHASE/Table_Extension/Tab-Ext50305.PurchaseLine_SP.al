tableextension 50305 PurchaseLine_SP extends "Purchase Line"
{
    fields
    {
        field(50300; "Planning Status"; Enum PlanningStates_SP)
        {
            DataClassification = CustomerContent;
            Caption = 'Planning Status';
            trigger OnValidate()
            begin
                Finish();
            end;
        }
        field(60101; "Original Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Original Quantity';
        }

        field(60102; IsClose; Boolean)
        {
            Caption = 'Closed (?)';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".IsClose where("No." = field("Document No."), "Document Type" = const(Order)));
        }
        field(60103; Remarks; Text[250])
        {
            Caption = 'Remarks';
        }
        field(60104; "Qty. to Ship"; Decimal)
        {
            Caption = 'Qty. to Ship';
        }
        field(60105; "Quantity Shipped"; Decimal)
        {
            Caption = 'Quantity Shipped';
            FieldClass = FlowField;
            CalcFormula = sum("Posted DO Line".Quantity
                            where("Order No." = field("Document No."),
                                "No." = field("No."),
                                "Order Line No." = field("Line No."), Iscancel = const(false)));
        }
        field(60106; "Price Unit Before"; Decimal)
        {
            Caption = 'Price Unit Before';
        }
        field(60107; "Vendor Name"; Text[150])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Buy-from Vendor No.")));
            Editable = false;
        }
        field(60108; "Order Date (Header)"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."Order Date" where("No." = field("Document No."), "Document Type" = const(Order)));
            Editable = false;
        }
    }

    /// Ends the purchase order line.
    procedure Finish()
    begin
        Finish(false);
    end;

    /// Ends the purchase order line.
    /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>
    procedure Finish(HideDialog: Boolean)
    var
        FinishPurchaseLine: Codeunit FinishPurchaseLine_SP;
    begin
        FinishPurchaseLine.FinishPurchaseOrderLine(Rec, HideDialog);
    end;
}