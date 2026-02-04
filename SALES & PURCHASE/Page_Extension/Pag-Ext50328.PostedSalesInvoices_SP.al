pageextension 50328 PostedSalesInvoices_SP extends "Posted Sales Invoices"
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
