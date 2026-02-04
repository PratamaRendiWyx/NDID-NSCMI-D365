codeunit 50304 EnableOrderCompletion_SP
{
   /// Checks if the order completion action is enabled in the sales and receivable setup.
   /// <returns>Indication of whether the order completion action is enabled.</returns>
    internal procedure FinishOrdersSalesEnabled(): Boolean
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        if SalesReceivablesSetup.Get() then
            exit(SalesReceivablesSetup."Enable Finish Orders");
        exit(false);
    end;

 /// Checks if the order completion action is enabled in the purchases and payable setup.
 /// <returns>Indication of whether the order completion action is enabled.</returns>
    internal procedure FinishOrdersPurchaseEnabled(): Boolean
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        if PurchasesPayablesSetup.Get() then
            exit(PurchasesPayablesSetup."Enable Finish Orders");
        exit(false);
    end;
}