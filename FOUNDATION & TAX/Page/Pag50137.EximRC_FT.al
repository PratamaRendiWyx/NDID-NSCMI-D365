page 50137 EximRC_FT
{
    Caption = 'Exim NSCMI';
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
            action("WS-WH")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Shipment';
                Image = "Order";
                RunObject = Page "Warehouse Shipment List";
                //ToolTip = '';
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
            }

            group(MO)
            {
                Caption = 'Monitoring Order';
                Image = Statistics;


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

