page 50111 PajakMasukanSubPage_FT
{
    PageType = ListPart;
    SourceTable = PPNDetail_FT;
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    Caption = 'Lines';

    layout
    {
        area(Content)
        {
            repeater("")
            {
                field(LineNo;Rec.LineNo)
                {
                    ApplicationArea = All;
                    Caption = 'LINE NO';
                }
                field(InvoiceNo;Rec.InvoiceNo)
                {
                    ApplicationArea = All;
                    Caption = 'INVOICE NO';
                }
                field(Type;Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'TYPE';
                }
                field(ItemID;Rec.ItemID)
                {
                    ApplicationArea = All;
                    Caption = 'ITEM ID';
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'DESCRIPTION';
                }
                field(VatBusPostGroup;Rec.VatBusPostGroup)
                {
                    ApplicationArea = All;
                    Caption = 'VAT BUS POSTING GROUP';
                }
                field(VatProdPostGroup;Rec.VatProdPostGroup)
                {
                    ApplicationArea = All;
                    Caption = 'VAT PROD POSTING GROUP';
                }
                field(VatIdentifier;Rec.VatIdentifier)
                {
                    ApplicationArea = All;
                    Caption = 'VAT IDENTIFIER';
                }
                field(Price;Rec.Price)
                {
                    ApplicationArea = All;
                    Caption = 'PRICE';
                }
                field(Qty;Rec.QtyDecimal)
                {
                    ApplicationArea = All;
                    Caption = 'QUANTITY';
                }
                field(TotAmt;Rec.TotAmt)
                {
                    ApplicationArea = All;
                    Caption = 'TOTAL AMOUNT';
                }
                field(DiscAmt;Rec.DiscAmt)
                {
                    ApplicationArea = All;
                    Caption = 'DISCOUNT AMOUNT';
                }
                field(DPPAmt;Rec.DPPAmt)
                {
                    ApplicationArea = All;
                    Caption = 'DPP AMOUNT';
                }
                field(VatAmt;Rec.VatAmt)
                {
                    ApplicationArea = All;
                    Caption = 'VAT AMOUNT';
                }
            }
        }
    }
}
