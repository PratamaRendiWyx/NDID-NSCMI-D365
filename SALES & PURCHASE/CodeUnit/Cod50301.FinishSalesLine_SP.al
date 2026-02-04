codeunit 50301 FinishSalesLine_SP
{

     /// Pattern that manages the complete execution of the action of terminating a sales order line.
     /// <param name="SalesLine">Sales order line to be completed.</param>
     /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>

    internal procedure FinishSalesOrderLine(var SalesLine: Record "Sales Line"; HideDialog: Boolean);
    var
        Handled: Boolean;
    begin
        if not ConfirmFinishSalesOrderLine(SalesLine, HideDialog) then exit;
        OnBeforeFinishSalesOrderLine(SalesLine, Handled);
        FromFinishSalesOrderLine(SalesLine, Handled);
        OnAfterFinishSalesOrderLine(SalesLine);
        AcknowledgeFinishSalesOrderLine(SalesLine, HideDialog)
    end;

     /// Performs the process of completing a sales order.
     /// <param name="SalesLine">Sales order line to be completed.</param>
     /// <param name="Handled">Double indicator if the complete action was performed.</param>
    local procedure FromFinishSalesOrderLine(var SalesLine: Record "Sales Line"; Handled: Boolean);
    begin
        // If the complete action was performed, we abandon the process.
        if Handled then
            exit;

        // We check that the document is an order.
        SalesLine.TestField("Document Type", SalesLine."Document Type"::Order);

        // We check that the line is of type product.
        SalesLine.TestField("Type", SalesLine."Type"::Item);

        // We carry out the relevant action.
        if SalesLine."Planning Status" = SalesLine."Planning Status"::Finished then begin
            if Abs(SalesLine."Quantity Shipped") < Abs(SalesLine.Quantity) then begin
                // If the line is finished, we save the original quantity and set the order quantity to the shipped quantity.
                SalesLine.Validate("Original Quantity", SalesLine.Quantity);
                SalesLine.Validate(SalesLine.Quantity, SalesLine."Quantity Shipped");
                SalesLine.Modify();
            end;
        end else
            if (SalesLine."Original Quantity" <> 0) AND (Abs(SalesLine.Quantity) <> Abs(SalesLine."Original Quantity")) then begin
                // If the finished state has been discarded, we recover the original amount.
                SalesLine.Validate(SalesLine.Quantity, SalesLine."Original Quantity");
                SalesLine.Validate("Original Quantity", 0);
                SalesLine.Modify();
            end;
    end;

/// Manages the user's confirmation of the action of finishing a sales order line.
 /// <param name="SalesLine">Sales order line to be completed.</param>
 /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>
 /// <returns>Indication as to whether the action should be executed.</returns>
    local procedure ConfirmFinishSalesOrderLine(var SalesLine: Record "Sales Line"; HideDialog: Boolean): Boolean
    var
        ConfirmQst: Label 'Do you want to finish the selected line from the %1 %2?';
    begin
        if Not GuiAllowed or HideDialog then exit(true);
        exit(Confirm(StrSubstNo(ConfirmQst, LowerCase(Format(SalesLine."Document Type")), SalesLine."Document No.")));
    end;

 /// Manages the completion confirmation message for the action of finishing a sales order line.
 /// <param name="SalesLine">Completed sales order line.</param>
 /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>
    local procedure AcknowledgeFinishSalesOrderLine(var SalesLine: Record "Sales Line"; HideDialog: Boolean)
    var
        AcknowledgeMsg: Label 'The selected line from the %1 %2 was successfully finished.';
    begin
        if Not GuiAllowed or HideDialog then exit;
        Message(AcknowledgeMsg, LowerCase(Format(SalesLine."Document Type")), SalesLine."Document No.");
    end;


 /// Event publisher prior to the action of finishing a sales order line.
 /// <param name="SalesLine">Sales order line to be completed.</param>
 /// <param name="Handled">Double indicator if the complete action was performed.</param>
    [IntegrationEvent(false, false)]
    local procedure OnBeforeFinishSalesOrderLine(var SalesLine: Record "Sales Line"; var Handled: Boolean);
    begin
    end;

 /// Finisher event poster for the action of finishing a sales order line.
 /// <param name="SalesLine">Completed sales order line.</param>
    [IntegrationEvent(false, false)]
    local procedure OnAfterFinishSalesOrderLine(var SalesLine: Record "Sales Line");
    begin
    end;
}