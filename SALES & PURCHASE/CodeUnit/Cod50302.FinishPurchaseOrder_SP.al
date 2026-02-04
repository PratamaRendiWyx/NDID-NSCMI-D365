codeunit 50302 FinishPurchaseOrder_SP
{

    /// Pattern that manages the complete execution of the action of completing a purchase order.
    /// <param name="PurchaseHeader">Purchase order that must be completed.</param>
    /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>
    internal procedure FinishPurchaseOrder(var PurchaseHeader: Record "Purchase Header"; HideDialog: Boolean);
    var
        Handled: Boolean;
    begin
        if not ConfirmFinishPurchaseOrder(PurchaseHeader, HideDialog) then exit;
        OnBeforeFinishPurchaseOrder(PurchaseHeader, Handled);
        FromFinishPurchaseOrder(PurchaseHeader, Handled);
        OnAfterFinishPurchaseOrder(PurchaseHeader);
        AcknowledgeFinishPurchaseOrder(PurchaseHeader, HideDialog)
    end;

    /// Performs the process of completing a purchase order.
    /// <param name="PurchaseHeader">Purchase order that must be completed.</param>
    /// <param name="Handled">Double indicator if the complete action was performed.</param>
    local procedure FromFinishPurchaseOrder(var PurchaseHeader: Record "Purchase Header"; Handled: Boolean);
    var
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        ReleaseQuantity: Boolean;
    begin
        // If the complete action was performed, we abandon the process.
        if Handled then
            exit;

        // We check that the document is an order.
        PurchaseHeader.TestField("Document Type", PurchaseHeader."Document Type"::Order);

        // If the order was released, we reopen it.
        if (PurchaseHeader.Status = PurchaseHeader.Status::Released) then
            PurchaseHeader.SetStatus(PurchaseHeader.Status::Open.AsInteger());

        // We initialize the variable ThrowQuantity.
        ReleaseQuantity := false;

        //Add New by RND, 11 Jun 24
        if Not PurchaseHeader.IsClose then
            PurchaseHeader.SetClosed(true);
        //-

        // Finish the order lines.
        FinishLinesOrder(PurchaseHeader, ReleaseQuantity);

        // We launch the order.
        if ReleaseQuantity then
            ReleasePurchaseDocument.Run(PurchaseHeader)
        else
            PurchaseHeader.SetStatus(PurchaseHeader.Status::Released.AsInteger());
    end;

    /// Ends the lines of a purchase order.
    /// <param name="PurchaseHeader">Purchase order lines must be completed.</param>
    /// <param name="LaunchQuantity">Output indicator on whether to release the quantity.</param>
    local procedure FinishLinesOrder(var PurchaseHeader: Record "Purchase Header"; var ReleaseQuantity: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        //We look for the purchase order lines
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetFilter(Type, '<>%1', PurchaseLine.Type::" ");
        PurchaseLine.SetFilter("No.", '<>%1', '');
        PurchaseLine.SetFilter(Quantity, '<>%1', 0);
        // If there are lines, we mark them as finished
        if PurchaseLine.FindSet() then
            repeat
                PurchaseLine."Planning Status" := PurchaseLine."Planning Status"::Finished;
                PurchaseLine.Finish(true);
                if (PurchaseLine.Quantity <> 0) and (not ReleaseQuantity) then
                    ReleaseQuantity := true;
                PurchaseLine.Modify();
            until PurchaseLine.Next() = 0;
    end;

    /// Manages the user's confirmation of the action of completing a purchase order.
    /// <param name="PurchaseHeader">Purchase order that must be completed.</param>
    /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>
    /// <returns>Indication as to whether the action should be executed.</returns>
    local procedure ConfirmFinishPurchaseOrder(var PurchaseHeader: Record "Purchase Header"; HideDialog: Boolean): Boolean
    var
        ConfirmQst: Label 'Do you want to finish the %1 %2?';
    begin
        if Not GuiAllowed or HideDialog then exit(true);
        exit(Confirm(StrSubstNo(ConfirmQst, LowerCase(Format(PurchaseHeader."Document Type")), PurchaseHeader."No.")));
    end;


    /// Manages the completion confirmation message for the action of completing a purchase order
    /// <param name="PurchaseHeader">Purchase order completed.</param>
    /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>
    local procedure AcknowledgeFinishPurchaseOrder(var PurchaseHeader: Record "Purchase Header"; HideDialog: Boolean)
    var
        AcknowledgeMsg: Label 'The %1 %2 was successfully finished.';
    begin
        if Not GuiAllowed or HideDialog then exit;
        Message(AcknowledgeMsg, LowerCase(Format(PurchaseHeader."Document Type")), PurchaseHeader."No.");
    end;

    /// Event publisher prior to the action of completing a purchase order.
    /// <param name="PurchaseHeader">Purchase order that must be completed.</param>
    /// <param name="Handled">Double indicator if the complete action was performed.</param>
    [IntegrationEvent(false, false)]
    local procedure OnBeforeFinishPurchaseOrder(var PurchaseHeader: Record "Purchase Header"; var Handled: Boolean);
    begin
    end;

    /// Finisher event publisher after the action of finishing a purchase order.
    /// <param name="PurchaseHeader">Purchase order completed.</param>
    [IntegrationEvent(false, false)]
    local procedure OnAfterFinishPurchaseOrder(var PurchaseHeader: Record "Purchase Header");
    begin
    end;

    //Add New by RND 11 June, Handling Restric During Finish Order
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforePrePostApprovalCheckPurch, '', false, false)]
    local procedure OnBeforePrePostApprovalCheckPurch(var PurchaseHeader: Record "Purchase Header"; var Result: Boolean; var IsHandled: Boolean)
    begin
        if PurchaseHeader.IsClose then
            IsHandled := true;
    end;
    //-
}