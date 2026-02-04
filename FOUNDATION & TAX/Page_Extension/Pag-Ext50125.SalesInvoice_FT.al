pageextension 50125 SalesInvoice_FT extends "Sales Invoice"
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

    actions
    {
        // Add changes to page actions here
    }


    var
        //myInt: Integer;
}