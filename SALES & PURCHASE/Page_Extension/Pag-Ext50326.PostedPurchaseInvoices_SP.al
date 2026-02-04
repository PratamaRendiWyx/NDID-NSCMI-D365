pageextension 50326 PostedPurchaseInvoices_SP extends "Posted Purchase Invoices"
{
    actions
    {
        modify(CancelInvoice)
        {
            Visible = true;
        }
        modify(CorrectInvoice)
        {
            Visible = false;
        }
        modify(CreateCreditMemo)
        {
            Visible = false;
        }
    }
}
