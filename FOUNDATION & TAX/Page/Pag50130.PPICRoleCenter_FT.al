page 50130 PPICRoleCenter_FT
{
    Caption = 'PPIC NSCMJ';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control45; "Headline RC Prod. Planner")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control1905113808; "Production Planner Activities")
            {
                ApplicationArea = Manufacturing;
            }
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = Manufacturing;
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group(Capacity)
            {
                Caption = 'Capacity';
                action("Inventory - &Availability Plan")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Inventory - &Availability Plan';
                    Image = ItemAvailability;
                    RunObject = Report "Inventory - Availability Plan";
                    ToolTip = 'View a list of the quantity of each item in customer, purchase, and transfer orders and the quantity available in inventory. The list is divided into columns that cover six periods with starting and ending dates as well as the periods before and after those periods. The list is useful when you are planning your inventory purchases.';
                }
                action("Planning Availability")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Planning Availability';
                    Image = "Report";
                    RunObject = Report "Planning Availability";
                    ToolTip = 'View all known existing requirements and receipts for the items that you select on a specific date. You can use the report to get a quick picture of the current demand-supply situation for an item. The report displays the item number and description plus the actual quantity in inventory.';
                }
                action("Capacity Task List")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Capacity Task List';
                    Image = "Report";
                    RunObject = Report "Capacity Task List";
                    ToolTip = 'View the production orders that are waiting to be processed at the work centers and machine centers. Printouts are made for the capacity of the work center or machine center). The report includes information such as starting and ending time, date per production order and input quantity.';
                }
            }
            group(Production)
            {
                Caption = 'Production';
                action("Production Order - &Shortage List")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Production Order - &Shortage List';
                    Image = "Report";
                    RunObject = Report "Prod. Order - Shortage List";
                    ToolTip = 'View a list of the missing quantity per production order. The report shows how the inventory development is planned from today until the set day - for example whether orders are still open.';
                }
                action("D&etailed Calculation")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'D&etailed Calculation';
                    Image = "Report";
                    RunObject = Report "Detailed Calculation";
                    ToolTip = 'View a cost list per item taking into account the scrap.';
                }
                action("P&roduction Order - Calculation")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'P&roduction Order - Calculation';
                    Image = "Report";
                    RunObject = Report "Prod. Order - Calculation";
                    ToolTip = 'View a list of the production orders and their costs, such as expected operation costs, expected component costs, and total costs.';
                }
                action("Sta&tus")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Sta&tus';
                    Image = "Report";
                    RunObject = Report Status;
                    ToolTip = 'View production orders by status.';
                }
                action("Prod. Order - &Job Card")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Prod. Order - &Job Card';
                    Image = "Report";
                    RunObject = Report "Prod. Order - Job Card";
                    ToolTip = 'View a list of the work in progress of a production order. Output, Scrapped Quantity and Production Lead Time are shown or printed depending on the operation.';
                }
            }
        }
        area(embedding)
        {
            action(Item)
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
            action(PlanningWorksheets)
            {
                ApplicationArea = Planning;
                Caption = 'Planning Worksheets';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Req. Wksh. Names";
                RunPageView = WHERE("Template Type" = CONST(Planning),
                                        Recurring = CONST(false));
                ToolTip = 'Plan supply orders automatically to fulfill new demand.';
            }
            action("Demand Forecast")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Demand Forecast';
                RunObject = Page "Demand Forecast Names";
                ToolTip = 'View or edit a demand forecast for your sales items, components, or both.';
            }
            action("Transfer Orders")
            {
                ApplicationArea = Location;
                Caption = 'Transfer Orders';
                Image = Document;
                RunObject = Page "Transfer Orders";
                ToolTip = 'Move inventory items between company locations. With transfer orders, you ship the outbound transfer from one location and receive the inbound transfer at the other location. This allows you to manage the involved warehouse activities and provides more certainty that inventory quantities are updated correctly.';
            }
            action(PR)
            {
                ApplicationArea = All;
                Caption = 'Purchase Requests';
                Image = "Order";
                RunObject = Page "Purchase Quotes";
                RunPageView = WHERE("Shortcut Dimension 1 Code"=FILTER('PPIC'|'MAINTENANCE'|''));
                ToolTip = 'Create purchase Request to represent your Section request. Quotes can be converted to purchase orders.';
            }

        }
        area(sections)
        {
            group(PPIC)
            {
                Caption = 'Planning & Orders';
                
                action("Planned Production Orders")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Planned Production Orders';
                    RunObject = Page "Planned Production Orders";
                    ToolTip = 'View the list of production orders with status Planned.';
                }
                action("Firm Planned Production Orders")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Firm Planned Production Orders';
                    RunObject = Page "Firm Planned Prod. Orders";
                    ToolTip = 'View completed production orders. ';
                }
                action("Released Production Orders")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Released Production Orders';
                    RunObject = Page "Released Production Orders";
                    ToolTip = 'View the list of released production order that are ready for warehouse activities.';
                }
                action("Finished Production Orders")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Finished Production Orders';
                    RunObject = Page "Finished Production Orders";
                    ToolTip = 'View completed production orders. ';
                }

                action("Sales Orders")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Sales Orders';
                    Image = "Order";
                    RunObject = Page "Sales Order List";
                    ToolTip = 'Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.';
                }

                action("Purchase Orders")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Purchase Orders';
                    RunObject = Page "Purchase Order List";
                    ToolTip = 'Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.';
                }
            }
            group("Worksheets")
            {
                Caption = 'Worksheets';
                Image = Worksheets;

                action(PW)
                {
                    ApplicationArea = Planning;
                    Caption = 'Planning Worksheets';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Req. Wksh. Names";
                    RunPageView = WHERE("Template Type" = CONST(Planning),
                                        Recurring = CONST(false));
                    ToolTip = 'Plan supply orders automatically to fulfill new demand.';
                }

                 action(RW)
                {
                    ApplicationArea = Planning;
                    Caption = 'Requisition Worksheets';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Req. Wksh. Names";
                    RunPageView = WHERE("Template Type" = CONST("Req."),
                                        Recurring = CONST(false));
                    ToolTip = 'Calculate a supply plan to fulfill item demand with purchases or transfers.';
                }
                action(SW)
                {
                    ApplicationArea = Planning;
                    Caption = 'Subcontracting Worksheets';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Req. Wksh. Names";
                    RunPageView = WHERE("Template Type" = CONST("For. Labor"),
                                        Recurring = CONST(false));
                    ToolTip = 'Calculate the needed production supply, find the production orders that have material ready to send to a subcontractor, and automatically create purchase orders for subcontracted operations from production order routings.';
                }
            }

            group("Item&BOM")
            {
                Caption = 'Inventory & BOM';
                Image = ProductDesign;
                action(ProductionBOM)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Production BOM';
                    Image = BOM;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Production BOM List";
                    ToolTip = 'Open the item''s production bill of material to view or edit its components.';
                }

                action(Items)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Items';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Item List";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                action("Stockkeeping Units")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Stockkeeping Units';
                    Image = SKU;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Stockkeeping Unit List";
                    ToolTip = 'Open the list of item SKUs to view or edit instances of item at different locations or with different variants. ';
                }

                action(IS)
                {
                    ApplicationArea = All;
                    Caption = 'Subcon Consumption (Not Planned)';
                    Image = "Order";
                    RunObject = Page "Invt. Shipments";
                    ToolTip = 'Not Planned Subcon Process e.g. Verco & Fastec';
                }

                action(IR)
                {
                    ApplicationArea = All;
                    Caption = 'Subcon Output ((Not Planned))';
                    RunObject = Page "Invt. Receipts";
                    ToolTip = 'Not Planned Subcon Process e.g. Verco & Fastec';
                }

                action(Location)
                {
                    ApplicationArea = All;
                    Caption = 'Location';
                    Image = InventoryCalculation;
                    RunObject = Page "Location List";
                    ToolTip = '';
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
        }
        area(creation)
        {
            action("Production &Order")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Planned Production &Order';
                Image = "Order";
                RunObject = Page "Planned Production Order";
                RunPageMode = Create;
                ToolTip = 'Create a new planned production order to supply a produced item.';
            }
            action("Firm Planned Production Order")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Firm Planned Production Order';
                RunObject = Page "Firm Planned Prod. Order";
                RunPageMode = Create;
                ToolTip = 'Create a new firm planned production order to supply a produced item.';
            }


        }
        area(processing)
        {
            group(Tasks)
            {
                Caption = 'Tasks';
                action("Item &Journal")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Item &Journal';
                    Image = Journals;
                    RunObject = Page "Item Journal";
                    ToolTip = 'Adjust the physical quantity of items on inventory.';
                }
                action("Change Pro&duction Order Status")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Change Pro&duction Order Status';
                    Image = ChangeStatus;
                    RunObject = Page "Change Production Order Status";
                    ToolTip = 'Change the production order to another status, such as Released.';
                }
                action("Order Pla&nning")
                {
                    ApplicationArea = Planning;
                    Caption = 'Order Pla&nning';
                    Image = Planning;
                    RunObject = Page "Order Planning";
                    ToolTip = 'Plan supply orders order by order to fulfill new demand.';
                }
            }
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

