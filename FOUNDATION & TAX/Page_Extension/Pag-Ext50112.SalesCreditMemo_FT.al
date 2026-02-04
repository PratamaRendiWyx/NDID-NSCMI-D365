pageextension 50112 SalesCreditMemo_FT extends "Sales Credit Memo"
{
    layout
    {
        addafter("Due Date")
        {
            field("Return Tax Number";Rec.ReturnTaxNo_FT)
            {
                ApplicationArea = All;
                Caption = 'Return Tax Number';
            }
            field("Return Doc Number"; Rec.ReturnDocNo_FT)
            {
                ApplicationArea = All;
                Caption = 'Return Doc Number';
            }
            field("Return Date"; Rec.ReturnDate_FT)
            {
                ApplicationArea = All;
                Caption = 'Return Date';
            }
        }
    }

}