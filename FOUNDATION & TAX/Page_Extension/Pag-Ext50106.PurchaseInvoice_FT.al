pageextension 50106 PurchaseInvoice_FT extends "Purchase Invoice"
{
    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("Tax Number"; Rec."Tax Number_FT")
            {
                ApplicationArea = All;
                Caption = 'Tax No.';
            }
            field("Tax Date"; Rec."Tax Date_FT")
            {
                ApplicationArea = All;
                Caption = 'Tax Date';
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
            Visible = false;
        }
    }

    var
        Item: Record item;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        CurrPage.PurchLines.Page.setParameterforWHT(Rec);
    end;
}