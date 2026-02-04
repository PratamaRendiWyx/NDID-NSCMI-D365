pageextension 50319 PurchasingRoleCenter_SP extends PurchasingRoleCenter_FT
{
    layout
    {
        addafter(Control44)
        {
            part(Control45; PurchaseActivities_SP)
            {
                ApplicationArea = Basic, Suite;
                Visible = true;
            }
        }

    }
    actions
    {
        addafter("Purchase Return Order")
        {
            action("Outstanding Purchase Return")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Outstanding Purchase Return';
                RunObject = Page "Purchase Lines";
                RunPageView = WHERE("Document Type" = CONST("Return Order"), "Outstanding Quantity" = filter(<> 0));
            }
        }
    }
}