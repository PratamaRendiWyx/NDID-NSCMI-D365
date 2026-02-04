page 50140 MTCRC_FT
{
    Caption = 'Maintenance NSCMJ';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control11; "Headline RC Team Member")
            {
                ApplicationArea = Suite;
            }
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
        }
    }

    actions
    {
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
                ApplicationArea = All;
                Caption = 'Purchase Requests';
                Image = "Order";
                RunObject = Page "Purchase Quotes";
                RunPageView = WHERE("Shortcut Dimension 1 Code"=FILTER('MAINTENANCE'|''));
                ToolTip = 'Create purchase Request to represent your Section request. Quotes can be converted to purchase orders.';
            }

        }
        area(sections)
        {
            group(MTC)
            {
                Caption = 'Maintenance';
                Image = Journals;
                ToolTip = 'Collect and make payments, prepare statements, and reconcile bank accounts.';

                
                action(IS)
                {
                    ApplicationArea = All;
                    Caption = 'Maintenance Consumption';
                    Image = "Order";
                    RunObject = Page "Invt. Shipments";
                    //ToolTip = '';
                }
            }
            group(Purchasing)
            {
                Caption = 'Purchasing';
                Image = AdministrationSalesPurchases;
                ToolTip = 'Manage purchase request and their history.';

                 action(Purchase_VendorList)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendors';
                    RunObject = Page "Vendor List";
                    ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.';
                } 

                action("Purchase Quotes")
                {
                    ApplicationArea = Suite;
                    Caption = 'Purchase Request';
                    RunObject = Page "Purchase Quotes";
                    ToolTip = 'Opens a list of purchase quotes.';
                } 
            }
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

