page 50126 PurchasingRoleCenter_FT
{
    Caption = 'Purchasing NSCMJ';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control1907662708; "Purchase Agent Activities")
            {
                ApplicationArea = Basic, Suite;
            }
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }

            part(Control37; "Purchase Performance")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part(Control44; "Inventory Performance")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            systempart(Control43; MyNotes)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group(Reports)
            {

                group("Purchase Reports")
                {
                }


            }

        }
        area(embedding)
        {

            action(Vendors)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = Page "Vendor List";
                ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.';
            }
            action(Items)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
            }

            action(PR)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Released Purchase Request';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Purchase Quotes";
                RunPageView = WHERE(Status = FILTER(Released));
                ToolTip = 'View Released purchase Request to represent your request for quotes from vendors. Quotes can be converted to purchase orders.';
            }

            action(PurchaseOrders)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
                ToolTip = 'Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.';
            }

            action(PP)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Price';
                RunObject = Page "Purchase Price Lists";
                //ToolTip = '';
            }

        }
        area(sections)
        {
            group(Action63)
            {
                Caption = 'Order Processing';
                Image = Purchasing;
                //ToolTip = '';

                action("Purchase Quotes")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Request';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Quotes";
                    RunPageView = WHERE(Status = FILTER(Released));
                    ToolTip = 'Create purchase Request to represent your request for quotes from vendors. Quotes can be converted to purchase orders.';
                }
                action("Purchase Orders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Orders';
                    RunObject = Page "Purchase Order List";
                    ToolTip = 'Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.';
                }
                action("Purchase Return Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Return Order';
                    RunObject = Page "Purchase Return Order List";
                    //ToolTip = '';
                }

                action(Price)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Price';
                    RunObject = Page "Purchase Price Lists";
                    //ToolTip = '';
                }

            }

            group(MO)
            {
                Caption = 'Monitoring Order';
                //ToolTip = '';


                action(RPO)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'PO Ready to Receive';
                    RunObject = Page "Purchase Order List";
                    RunPageView = WHERE(Status = FILTER(Released),
                                    "Completely Received" = FILTER(false));
                    ToolTip = 'View the list of purchases that are Ready to Receive';
                }

                action(PL)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Outstanding Purchase Orders';
                    Image = Purchase;
                    RunObject = Page "Purchase Lines";
                    RunPageView = WHERE("Document Type" = CONST(Order));
                }

            }

            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                    ToolTip = 'Open the list of posted purchase receipts.';
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'Open the list of posted purchase invoices.';
                }
                action("Posted Return Shipments")
                {
                    ApplicationArea = PurchReturnOrder;
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
                    ToolTip = 'Open the list of posted return shipments.';
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                    ToolTip = 'Open the list of posted purchase credit memos.';
                }
            }
        }
        area(creation)
        {
            action("Purchase &Quote")
            {
                ApplicationArea = Suite;
                Caption = 'Purchase Request';
                Image = Quote;
                RunObject = Page "Purchase Quote";
                RunPageMode = Create;
                ToolTip = 'Create a new purchase quote, for example to reflect a request for quote.';
            }
            action("Purchase &Order")
            {
                ApplicationArea = Suite;
                Caption = 'Purchase &Order';
                Image = Document;
                RunObject = Page "Purchase Order";
                RunPageMode = Create;
                ToolTip = 'Create a new purchase order.';
            }
            action("Purchase &Return Order")
            {
                ApplicationArea = PurchReturnOrder;
                Caption = 'Purchase &Return Order';
                Image = ReturnOrder;
                RunObject = Page "Purchase Return Order";
                RunPageMode = Create;
                ToolTip = 'Create a new purchase return order to return received items.';
            }
        }
        area(processing)
        {
            separator(History)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Find entries...';
                Image = Navigate;
                RunObject = Page Navigate;
                ShortCutKey = 'Ctrl+Alt+Q';
                ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';
            }
        }
    }
}

