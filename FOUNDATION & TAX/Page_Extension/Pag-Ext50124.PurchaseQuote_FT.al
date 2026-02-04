pageextension 50124 PurchaseQuote_FT extends "Purchase Quote"
{
    Caption = 'Purchase Request';

    layout
    {
        // Add changes to page layout here

        modify("Invoice Details")
        {
            Visible = false;
        }

        modify("Shipping and Payment")
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