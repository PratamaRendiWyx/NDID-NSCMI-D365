page 50106 PajakKeluaranSubPage_FT
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
                    Caption = 'Line Id';
                }
                field(InvoiceNo;Rec.InvoiceNo)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice No';
                }
                field(Type;Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                }
                field(ItemID;Rec.ItemID)
                {
                    ApplicationArea = All;
                    Caption = 'Item ID';
                //TableRelation = Item.Id;
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
                }
                field(VatProdPostGroup;Rec.VatProdPostGroup)
                {
                    ApplicationArea = All;
                    CharAllowed = '19'; // char that allowed 1 to 9
                }
                field(VatIdentifier;Rec.VatIdentifier)
                {
                    ApplicationArea = All;
                    CharAllowed = '19'; // char that allowed 1 to 9
                }
                field(Price;Rec.Price)
                {
                    ApplicationArea = All;
                }
                field(QtyDecimal;Rec.QtyDecimal)
                {
                    ApplicationArea = All;
                }
                field(TotAmt;Rec.TotAmt)
                {
                    ApplicationArea = All;
                }
                field(DiscAmt;Rec.DiscAmt)
                {
                    ApplicationArea = All;
                }
                field(DPPAmt;Rec.DPPAmt)
                {
                    ApplicationArea = All;
                }
                field(VatAmt;Rec.VatAmt)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
