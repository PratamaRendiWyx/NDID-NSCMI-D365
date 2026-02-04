namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Sales.History;

pageextension 51119 PostedSalCreditMeLines_AF extends "Posted Sales Credit Memo Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addbefore(Type)
        {
            field("Shipment Method"; Rec."Shipment Method")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Currency Code"; Rec."Currency Code")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Amount Including VAT")
        {
            field("Cost Amount (VE)"; Rec."Cost Amount (VE)")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Sales Amount (VE)"; Rec."Sales Amount (VE)")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
