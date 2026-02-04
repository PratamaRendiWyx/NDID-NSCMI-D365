pageextension 51133 "General Ledger Setup_AF" extends "General Ledger Setup"
{
    layout
    {
        addafter("Prepayment Unrealized VAT")
        {
            field("Exact Amount Jnl."; Rec."Exact Amount Jnl.")
            {
                ApplicationArea = All;
            }
        }
    }
}
