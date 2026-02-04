pageextension 50107 PurchaseOrder_FT extends "Purchase Order"
{
    layout
    {
        addafter("Vendor Shipment No.")
        {
            field("Tax Number"; Rec."Tax Number_FT")
            {
                ApplicationArea = All;
            }
            field("Tax Date"; Rec."Tax Date_FT")
            {
                ApplicationArea = All;
            }
        }

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
            Caption = 'Import';
            Visible = false;
        }

        modify(Prepayment)
        {
            Visible = false;
        }

    }

    var
    Item: Record item;

    trigger OnOpenPage()
    begin
        CurrPage.PurchLines.Page.setParameterforWHT(Rec);
    end;
}
