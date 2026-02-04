pageextension 50120 SalesQuote_FT extends "Sales Quote"
{
    layout
    {
        // Add changes to page layout here

        modify("Invoice Details")
        {
            Visible = false;
        }
        modify("Shipping and Billing")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }

    }
}