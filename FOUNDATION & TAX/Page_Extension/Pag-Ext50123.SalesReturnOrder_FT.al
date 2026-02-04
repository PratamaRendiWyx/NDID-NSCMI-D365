pageextension 50123 SalesReturnOrder_FT extends "Sales Return Order"
{
    layout
    {
        // Add changes to page layout here

        
        modify ("Invoice Details")
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

        modify("External Document No.")
        {
            Caption = 'Cust. Return No.';
        }
    }
    
    actions
    {
        // Add changes to page actions here
    }
    
    var
        //myInt: Integer;
}