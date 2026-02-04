pageextension 50118 SalesOrder_FT extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here


        modify("External Document No.")
        {
            Caption = 'Customer PO No.';
        }

        modify("Work Description")
        {
            Caption = 'Remarks';
        }

        modify("Invoice Details")
        {
            Visible = false;
        }
        modify(Control1900201301)
        {
            Visible = false;
        }

        modify("Foreign Trade")
        {
            Visible = false;
        }

        modify("Shipment Date")
        {
            visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here

        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("External Document No.");
            end;
        }
        
    }

}