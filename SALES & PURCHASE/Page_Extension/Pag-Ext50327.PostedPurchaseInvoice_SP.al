pageextension 50327 PostedPurchaseInvoice_SP extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("Invoice Received Date"; Rec."Invoice Received Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
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
