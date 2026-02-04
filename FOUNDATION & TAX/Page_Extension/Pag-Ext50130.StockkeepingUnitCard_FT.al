pageextension 50130 StockkeepingUnitCard_FT extends "Stockkeeping Unit Card"
{
    layout
    {
        // Add changes to page layout here

        modify(Control1907509201)
        {
            Visible = false;
        }

        modify("Maximum Inventory")
        {
            Visible = false;
        }

        modify("Order Multiple")
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