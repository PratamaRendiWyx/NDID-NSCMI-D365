pageextension 50306 WarehouseRC_SP extends WarehouseRC_FT
{
    actions
    {
        modify(PO)
        {
            Visible = false;
        }
        addafter(PO)
        {
            action(PO1)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
                RunPageView = WHERE(IsClose = CONST(false));
                ToolTip = 'Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.';
            }
        }
    }
}