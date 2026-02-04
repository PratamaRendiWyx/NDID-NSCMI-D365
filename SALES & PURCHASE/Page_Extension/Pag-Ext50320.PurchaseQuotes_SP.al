pageextension 50320 PurchaseQuotes_SP extends "Purchase Quotes"
{
    Caption = 'Purchase Request';
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field("PO No."; Rec."PO No.")
            {
                ApplicationArea = All;
            }
        }
        modify("Shortcut Dimension 1 Code")
        {
            ShowMandatory = true;
        }
    }

    actions
    {
        modify(MakeOrder)
        {
            Enabled = not (Rec."PO No." <> '');
        }
        modify(Reopen)
        {
            Enabled = (Rec."PO No." = '');
        }
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TestField("Shortcut Dimension 1 Code");
            end;
        }
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TestField("Shortcut Dimension 1 Code");
            end;
        }
    }
}
