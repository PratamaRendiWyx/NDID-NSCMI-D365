codeunit 50303 FinishSalesOrder_SP
{

    /// Pattern that manages the complete execution of the action of completing a sales order.
    /// <param name="SalesHeader">Sales order that must be completed.</param>
    /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>
    internal procedure FinishSalesOrder(var SalesHeader: Record "Sales Header"; HideDialog: Boolean);
    var
        Handled: Boolean;
    begin
        if not ConfirmFinishSalesOrder(SalesHeader, HideDialog) then exit;
        OnBeforeFinishSalesOrder(SalesHeader, Handled);
        FromFinishSalesOrder(SalesHeader, Handled);
        OnAfterFinishSalesOrder(SalesHeader);
        AcknowledgeFinishSalesOrder(SalesHeader, HideDialog)
    end;

    /// Performs the process of completing a sales order.
    /// <param name="SalesHeader">Sales order that must be completed.</param>
    /// <param name="Handled">Double indicator if the complete action was performed.</param>
    local procedure FromFinishSalesOrder(var SalesHeader: Record "Sales Header"; Handled: Boolean);
    var
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        ReleaseQuantity: Boolean;
    begin
        // If the complete action was performed, we abandon the process.
        if Handled then
            exit;

        // We check that the document is an order.
        SalesHeader.TestField("Document Type", SalesHeader."Document Type"::Order);

        // If the order was released, we reopen it.
        if (SalesHeader.Status = SalesHeader.Status::Released) then
            SalesHeader.SetStatus(SalesHeader.Status::Open.AsInteger());

        // We initialize the Release Quantity variable.
        ReleaseQuantity := false;

        //Add New by RND, 26 Jun 24
        if Not SalesHeader.IsClose then
            SalesHeader.SetClosed(true);
        //-

        // Finish the order lines.
        FinishLinesOrder(SalesHeader, ReleaseQuantity);

        // We launch the order.
        if ReleaseQuantity then
            ReleaseSalesDocument.Run(SalesHeader)
        else
            SalesHeader.SetStatus(SalesHeader.Status::Released.AsInteger());
    end;

    /// Ends the lines of a sales order.
    /// <param name="SalesHeader">Sales order lines must be terminated.</param>
    /// <param name="ReleaseQuantity">Output indicator on whether to release the quantity.</param>
    local procedure FinishLinesOrder(var SalesHeader: Record "Sales Header"; var ReleaseQuantity: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        //We look for the sales order lines
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        SalesLine.SetFilter("No.", '<>%1', '');
        SalesLine.SetFilter(Quantity, '<>%1', 0);

        // If there are lines, we mark them as finished
        if SalesLine.FindSet() then
            repeat
                SalesLine."Planning Status" := SalesLine."Planning Status"::Finished;
                SalesLine.Finish(true);
                if (SalesLine.Quantity <> 0) and (not ReleaseQuantity) then
                    ReleaseQuantity := true;
                SalesLine.Modify();
            until SalesLine.Next() = 0;
    end;

    /// Manages the user's confirmation of the action of completing a sales order.
    /// <param name="SalesHeader">Sales order that must be completed.</param>
    /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>
    /// <returns>Indication as to whether the action should be executed.</returns>
    local procedure ConfirmFinishSalesOrder(var SalesHeader: Record "Sales Header"; HideDialog: Boolean): Boolean
    var
        ConfirmQst: Label 'Do you want to finish the %1 %2?';
    begin
        if Not GuiAllowed or HideDialog then exit(true);
        exit(Confirm(StrSubstNo(ConfirmQst, LowerCase(Format(SalesHeader."Document Type")), SalesHeader."No.")));
    end;

    /// Manages the completion confirmation message for the action of completing a sales order.
    /// <param name="SalesHeader">Sales order completed.</param>
    /// <param name="HideDialog">Indicator whether the dialog should be avoided.</param>
    local procedure AcknowledgeFinishSalesOrder(var SalesHeader: Record "Sales Header"; HideDialog: Boolean)
    var
        AcknowledgeMsg: Label 'The %1 %2 was successfully finished.';
    begin
        if Not GuiAllowed or HideDialog then exit;
        Message(AcknowledgeMsg, LowerCase(Format(SalesHeader."Document Type")), SalesHeader."No.");
    end;

    /// Event publisher prior to the action of completing a sales order.
    /// <param name="SalesHeader">Sales order that must be completed.</param>
    /// <param name="Handled">Double indicator if the complete action was performed.</param>
    [IntegrationEvent(false, false)]
    local procedure OnBeforeFinishSalesOrder(var SalesHeader: Record "Sales Header"; var Handled: Boolean);
    begin
    end;

    /// Finisher event publisher after the action of finishing a sales order.
    /// <param name="SalesHeader">Sales order completed.</param>
    [IntegrationEvent(false, false)]
    local procedure OnAfterFinishSalesOrder(var SalesHeader: Record "Sales Header");
    begin
    end;

    //Add New by RND 26 June, Handling Restric During Finish Order
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforePrePostApprovalCheckSales, '', false, false)]
    local procedure OnBeforePrePostApprovalCheckSales(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; var Result: Boolean)
    begin
        if SalesHeader.IsClose then
            IsHandled := true;
    end;
    //-
}