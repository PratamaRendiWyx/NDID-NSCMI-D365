pageextension 50309 PurchaseOrderList_SP extends "Purchase Order List"
{
    layout
    {
        addafter(Status)
        {
            field(IsClose; Rec.IsClose)
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        PurchManagement: Codeunit PurchManagement_SP;
    begin
        if not Rec.IsClose then begin
            Clear(PurchManagement);
            PurchManagement.checkCountCompleteInvoicedPO(Rec."No.");
        end;
    end;
}
