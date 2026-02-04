pageextension 50524 PurchaseReturnOrder_WE extends "Purchase Return Order"
{
    layout
    {
        addafter(Status)
        {
            field("Additional Notes"; Rec."Additional Notes")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
        }
    }
}
