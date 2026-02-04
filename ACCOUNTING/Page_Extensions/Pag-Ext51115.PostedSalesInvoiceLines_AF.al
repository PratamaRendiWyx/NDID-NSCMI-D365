namespace ACCOUNTING.ACCOUNTING;

using Microsoft.Sales.History;

pageextension 51115 PostedSalesInvoiceLines_AF extends "Posted Sales Invoice Lines"
{
    layout
    {
        addafter("Unit of Measure")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
            field("Shipment No."; Rec."Shipment No.")
            {
                ApplicationArea = All;
            }
            // field("Order No."; Rec."Order No.")
            // {
            //     ApplicationArea = All;
            //     Editable = false;
            // }
            field("Order Line No."; Rec."Order Line No.")
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
            field("Is Exists Cr. Memo"; Rec."Is Exists Cr. Memo")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
