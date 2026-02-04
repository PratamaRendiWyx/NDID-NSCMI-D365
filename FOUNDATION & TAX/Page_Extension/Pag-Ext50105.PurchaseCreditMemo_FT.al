pageextension 50105 PurchaseCreditMemo_FT extends "Purchase Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        addafter("Vendor Cr. Memo No.")
        {
            field("Return Tax Number";Rec.ReturnTaxNo_FT)
            {
                ApplicationArea = All;
                Caption = 'Return Tax Number';
            }
            field("Return Doc Number";Rec.ReturnDocNo_FT)
            {
                ApplicationArea = All;
                Caption = 'Return Doc Number';
            }
            field("Return Date";Rec.ReturnDate_FT)
            {
                ApplicationArea = All;
                Caption = 'Return Date';
            }
        }
    }

}
