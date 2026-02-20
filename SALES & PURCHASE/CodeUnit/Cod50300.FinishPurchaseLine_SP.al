codeunit 50300 FinishPurchaseLine_SP
{
    /// Pattern that manages the complete execution of the action of terminating a purchase order line.
    /// <param name="PurchaseLine">Purchase order line to be completed.</param>
    /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>

    internal procedure FinishPurchaseOrderLine(var PurchaseLine: Record "Purchase Line"; HideDialog: Boolean);
    var
        Handled: Boolean;
    begin
        if not ConfirmFinishPurchaseOrderLine(PurchaseLine, HideDialog) then exit;
        OnBeforeFinishPurchaseOrderLine(PurchaseLine, Handled);
        FromFinishPurchaseOrderLine(PurchaseLine, Handled);
        OnAfterFinishPurchaseOrderLine(PurchaseLine);
        AcknowledgeFinishPurchaseOrderLine(PurchaseLine, HideDialog)
    end;

    /// Performs the process of completing a purchase order.
    /// <param name="PurchaseLine">Purchase order line to be completed.</param>
    /// <param name="Handled">Double indicator if the complete action was performed.</param>

    local procedure FromFinishPurchaseOrderLine(var PurchaseLine: Record "Purchase Line"; Handled: Boolean);
    begin
        // If the complete action was performed, we abandon the process.
        if Handled then
            exit;

        // We check that the document is an order.
        PurchaseLine.TestField("Document Type", PurchaseLine."Document Type"::Order);

        // We check that the line is of type product.
        // PurchaseLine.TestField("Type", PurchaseLine."Type"::Item);

        // We carry out the relevant action.
        if PurchaseLine."Planning Status" = PurchaseLine."Planning Status"::Finished then begin
            if Abs(PurchaseLine."Quantity Received") < Abs(PurchaseLine.Quantity) then begin
                // If the line is finished, we save the original quantity and set the order quantity to the quantity received.
                PurchaseLine.Validate("Original Quantity", PurchaseLine.Quantity);
                PurchaseLine.Validate(PurchaseLine.Quantity, PurchaseLine."Quantity Received");
                PurchaseLine.Modify();
            end;
        end else
            if Abs(PurchaseLine.Quantity) <> Abs(PurchaseLine."Original Quantity") then begin
                // If the finished state has been discarded, we recover the original amount.
                PurchaseLine.Validate(PurchaseLine.Quantity, PurchaseLine."Original Quantity");
                PurchaseLine.Validate("Original Quantity", 0);
                PurchaseLine.Modify();
            end;
    end;

    /// Manages the user's confirmation of the action of completing a purchase order line.
    /// <param name="PurchaseLine">Purchase order line to be completed.</param>
    /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>
    /// <returns>Indication as to whether the action should be executed.</returns>

    local procedure ConfirmFinishPurchaseOrderLine(var PurchaseLine: Record "Purchase Line"; HideDialog: Boolean): Boolean
    var
        ConfirmQst: Label 'Do you want to finish the selected line from the %1 %2?';
    begin
        if Not GuiAllowed or HideDialog then exit(true);
        exit(Confirm(StrSubstNo(ConfirmQst, LowerCase(Format(PurchaseLine."Document Type")), PurchaseLine."Document No.")));
    end;

    /// Manages the completion confirmation message for the action of finishing a purchase order line.
    /// <param name="PurchaseLine">Finished purchase order line.</param>
    /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>
    local procedure AcknowledgeFinishPurchaseOrderLine(var PurchaseLine: Record "Purchase Line"; HideDialog: Boolean)
    var
        AcknowledgeMsg: Label 'The selected line from the %1 %2 was successfully finished.';
    begin
        if Not GuiAllowed or HideDialog then exit;
        Message(AcknowledgeMsg, LowerCase(Format(PurchaseLine."Document Type")), PurchaseLine."Document No.");
    end;

    /// Event publisher prior to the action of finishing a purchase order line.
    /// <param name="PurchaseLine">Purchase order line to be completed.</param>
    /// <param name="Handled">Double indicator if the complete action was performed.</param>
    [IntegrationEvent(false, false)]
    local procedure OnBeforeFinishPurchaseOrderLine(var PurchaseLine: Record "Purchase Line"; var Handled: Boolean);
    begin
    end;


    /// Finisher event publisher after the action of finishing a purchase order line.
    /// <param name="PurchaseLine">Finished purchase order line.</param>
    [IntegrationEvent(false, false)]
    local procedure OnAfterFinishPurchaseOrderLine(var PurchaseLine: Record "Purchase Line");
    begin
    end;
}