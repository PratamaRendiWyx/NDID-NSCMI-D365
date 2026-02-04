page 50105 PajakKeluaranPostedSub_FT
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
            repeater(GroupName)
            {
                field(LineNo;Rec.LineNo)
                {
                    ApplicationArea = All;
                    Caption = 'Line Id';
                    Visible = false;
                }
                field(InvoiceNo;Rec.InvoiceNo)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice No.';
                }
                field(Type;Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Visible = false;
                }
                field(ItemID;Rec.ItemID)
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field(VatBusPostGroup;Rec.VatBusPostGroup)
                {
                    ApplicationArea = All;
                    Numeric = true;
                    CharAllowed = '19'; // // char that allowed 1 to 9
                    Visible = false;
                }
                field(VatProdPostGroup;Rec.VatProdPostGroup)
                {
                    ApplicationArea = All;
                    Visible = false;
                    CharAllowed = '19'; // char that allowed 1 to 9
                }
                field(VatIdentifier;Rec.VatIdentifier)
                {
                    ApplicationArea = All;
                    CharAllowed = '19'; // char that allowed 1 to 9
                    Caption = 'VAT %';
             
                }
                field(Price;Rec.Price)
                {
                    ApplicationArea = All;
                }
                field(Qty;Rec.QtyDecimal)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';

                }
                field(TotAmt;Rec.TotAmt)
                {
                    ApplicationArea = All;
                    Caption = 'Line Amount';
                }
                field(DiscAmt;Rec.DiscAmt)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(DPPAmt;Rec.DPPAmt)
                {
                    ApplicationArea = All;
                    Caption = 'DPP Amount';
                }
                field(VatAmt;Rec.VatAmt)
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                }
            }
        }
    }
}
