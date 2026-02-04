page 50131 WarehouseRC_FT
{
    Caption = 'Warehouse NSCMJ';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control51; "Headline RC Whse. Basic")
            {
                ApplicationArea = Warehouse;
            }
            part("Warehouse Activities"; WarehouseActivities_FT)
            {
                ApplicationArea = Warehouse;
            }
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = Warehouse;
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group(Reports)
            {

            }

        }
        area(embedding)
        {

            action(Items)
            {
                ApplicationArea = Warehouse;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
            }
            action(IBL)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item by Location';
                Image = "Order";
                RunObject = Page "Items by Location";
                //ToolTip = '';
            }

            action(LNI)
            {
                ApplicationArea = Warehouse;
                Caption = 'Lot No. Information';
                Image = BinContent;
                RunObject = Page "Lot No. Information List";
                ToolTip = '';
            }
            action(PO)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
                ToolTip = 'Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.';
            }

            action("WS-WH")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Shipment';
                Image = "Order";
                RunObject = Page "Warehouse Shipment List";
                //ToolTip = '';
            }
            action(PRO)
            {
                ApplicationArea = Warehouse;
                Caption = 'Purchase Return Orders';
                Image = Document;
                RunObject = Page "Purchase Return Order List";
                //ToolTip = '';
            }

            action(SOC)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Stock Opname Counting';
                Image = "Order";
                RunObject = Page "Phys. Inventory Recording List";
                //ToolTip = '';
            }
            action(PR)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Request';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Purchase Quotes";
                RunPageView = WHERE("Shortcut Dimension 1 Code"=FILTER('WAREHOUSE'|''));
                ToolTip = 'Create purchase Request to represent your Section request. Quotes can be converted to purchase orders.';
            }

        }
        area(sections)
        {

            group(WH)
            {
                Caption = 'Warehouse';
                Image = Sales;

                action(SalesOrders)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'SO-Ready to Ship';
                    Image = "Order";
                    RunObject = Page "Sales Order List";
                    RunPageView = WHERE(Status = FILTER(Released),
                                        //"Closed Document"= filter(''),
                                        "Completely Shipped" = CONST(false));
                    //ToolTip = '';
                }


                action(WS)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Warehouse Shipment';
                    RunObject = Page "Warehouse Shipment List";
                    //ToolTip = '';
                }

                action(ST)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Stock Opname';
                    RunObject = Page "Physical Inventory Orders";
                    //ToolTip = '';
                }
            }

            group(Inventory)
            {
                Caption = 'Inventory Movement';
                Image = Sales;

                action(IS)
                {
                    ApplicationArea = All;
                    Caption = 'Production/Subcon Consumption';
                    Image = "Order";
                    RunObject = Page "Invt. Shipments";
                    //ToolTip = '';
                }


                action(IR)
                {
                    ApplicationArea = All;
                    Caption = 'Production/Subcon Output';
                    RunObject = Page "Invt. Receipts";
                    //ToolTip = '';
                }

                action(TO)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Transfer Orders';
                    Image = Document;
                    RunObject = Page "Transfer Orders";
                    ToolTip = 'Move inventory items between company locations. With transfer orders, you ship the outbound transfer from one location and receive the inbound transfer at the other location. This allows you to manage the involved warehouse activities and provides more certainty that inventory quantities are updated correctly.';
                }


            }

            group(MO)
            {
                Caption = 'Monitoring Order';
                Image = Statistics;

                action(MPO)
                {
                    ApplicationArea = All;
                    Caption = 'Monitoring Outstanding Qty. PO';
                    Image = "Order";
                    RunObject = Page "Purchase Lines";
                    RunPageView = WHERE("Document Type" = FILTER(Order));
                    //ToolTip = '';
                }

                action(MPR)
                {
                    ApplicationArea = All;
                    Caption = 'Monitoring PO Receipt';
                    RunObject = Page "Posted Purchase Receipt Lines";
                    RunPageView = WHere(Correction = const(false));
                    //ToolTip = '';
                }

                action(MSO)
                {
                    ApplicationArea = All;
                    Caption = 'Monitoring Outstanding Qty. SO';
                    Image = "Order";
                    RunObject = Page "Sales Lines";
                    RunPageView = WHERE("Document Type" = FILTER(Order));
                    //ToolTip = '';
                }

                action(MSJ)
                {
                    ApplicationArea = All;
                    Caption = 'Monitoring Sales Shipment';
                    RunObject = Page "Posted Sales Shipment Lines";
                    //ToolTip = '';
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;

                action("Posted Sales Shipment")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Posted Sales Shipment';
                    RunObject = Page "Posted Sales Shipments";
                    ToolTip = 'Open the list of posted sales shipments.';
                }
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                    ToolTip = 'Open the list of posted purchase receipts.';
                }

                action("Posted Return Shipments")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
                    ToolTip = 'Open the list of posted return shipments.';
                }
                action("Posted Transfer Shipments")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Posted Transfer Shipments';
                    RunObject = Page "Posted Transfer Shipments";
                    ToolTip = 'Open the list of posted transfer shipments.';
                }

                action("Posted Transfer Receipts")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Posted Transfer Receipts';
                    RunObject = Page "Posted Transfer Receipts";
                    ToolTip = 'Open the list of posted transfer receipts.';
                }
            }

        }
        area(creation)
        {
        }
        area(processing)
        {
            group(History)
            {
                Caption = 'History';
                action("Item &Tracing")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Item &Tracing';
                    Image = ItemTracing;
                    RunObject = Page "Item Tracing";
                    ToolTip = 'Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.';
                }
                action("Navi&gate")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Find entries...';
                    Image = Navigate;
                    RunObject = Page Navigate;
                    ShortCutKey = 'Ctrl+Alt+Q';
                    ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';
                }
            }
        }
    }
}

