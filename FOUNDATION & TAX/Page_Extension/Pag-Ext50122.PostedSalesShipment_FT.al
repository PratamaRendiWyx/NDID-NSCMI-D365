pageextension 50122 PostedSalesShipment_FT extends "Posted Sales Shipment"
{
    layout
    {
        // Add changes to page layout here

        modify(Billing)
        {
            Visible = false;
        }

        modify("Work Description")
        {
            Caption = 'Remarks';
        }

    }

    actions
    {
        // Add changes to page actions here

    }

}