pageextension 50119 SalesOrderList_FT extends "Sales Order List"
{
    layout
    {
        // Add changes to page layout here

        modify("External Document No.")
        {
            Caption = 'Cust. PO No.';
        }

    }

    actions
    {
        // Add changes to page actions here

        modify(SendApprovalRequest)
        {
            trigger OnAfterAction()
            begin
                Rec.TestField("External Document No.");
            end;
        }

    }

    var
    //myInt: Integer;
}