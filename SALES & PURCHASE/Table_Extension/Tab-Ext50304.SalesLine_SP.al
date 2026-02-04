tableextension 50304 SalesLine_SP extends "Sales Line"
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
        field(50310; "Original Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Original Quantity';
        }
        field(50311; "Remarks"; Text[100])
        {
        }
        field(50312; "Part Number"; Text[30])
        {
        }
        field(50313; "Part Name"; Text[100])
        {
        }
        field(50314; "Is Closed"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header".IsClose where("No." = field("Document No."), "Document Type" = const(Order)));
            Editable = false;
        }
        field(50315; "Cust. PO No."; Text[35])
        {
        }


    }


    /// Ends the sales order line.
    procedure Finish()
    begin
        Finish(false);
    end;

    /// Ends the sales order line.
    /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>
    procedure Finish(HideDialog: Boolean)
    var
        FinishSalesLine: Codeunit FinishSalesLine_SP;
    begin
        FinishSalesLine.FinishSalesOrderLine(Rec, HideDialog);
    end;
}