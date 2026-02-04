page 50133 ProductionManagerRC_FT
{
    Caption = 'Production Manager NSCMJ';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control1905113808; ProductionActivities_FT)
            {
                ApplicationArea = Manufacturing;
            } 
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
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
                
                
                action("Routing Sheet")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Routing Sheet';
                    Image = "Report";
                    RunObject = Report "Routing Sheet";
                    ToolTip = 'View basic information for routings, such as send-ahead quantity, setup time, run time and time unit. This report shows you the operations to be performed in this routing, the work or machine centers to be used, the personnel, the tools, and the description of each operation.';
                }
                action("Inventory - &Availability Plan")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Inventory - &Availability Plan';
                    Image = ItemAvailability;
                    RunObject = Report "Inventory - Availability Plan";
                    ToolTip = 'View a list of the quantity of each item in customer, purchase, and transfer orders and the quantity available in inventory. The list is divided into columns that cover six periods with starting and ending dates as well as the periods before and after those periods. The list is useful when you are planning your inventory purchases.';
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
                action("Inventory &Valuation WIP")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Inventory &Valuation WIP';
                    Image = "Report";
                    RunObject = Report "Inventory Valuation - WIP";
                    ToolTip = 'View inventory valuation for selected production orders in your WIP inventory. The report also shows information about the value of consumption, capacity usage and output in WIP.';
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
            

            action(FPO)
            {
                ApplicationArea = Manufacturing;
                Caption = 'Firm Daily Production Orders';
                RunObject = Page "Firm Planned Prod. Orders";
                ToolTip = 'View the list of firm plan weekly production order that are ready for production activities.';
            }
            action(RPO)
            {
                ApplicationArea = Manufacturing;
                Caption = 'Released Production Orders';
                RunObject = Page "Released Production Orders";
                ToolTip = 'View the list of released production order that are ready for warehouse activities.';
            }
            
            action("Transfer Orders")
            {
                ApplicationArea = All;
                Caption = 'Transfer Orders';
                Image = Document;
                RunObject = Page "Transfer Orders";
                ToolTip = 'Move inventory items between company locations. With transfer orders, you ship the outbound transfer from one location and receive the inbound transfer at the other location. This allows you to manage the involved warehouse activities and provides more certainty that inventory quantities are updated correctly.';
            }

            action(LOT)
            {
                ApplicationArea = All;
                Caption = 'Lot No. Informations';
                Image = Calculate;
                RunObject = Page "Lot No. Information List";
                //ToolTip = '';
            }
/*             action(STO)
            {
                ApplicationArea = All;
                Caption = 'Stock Opname Counting';
                Image = Calculate;
                RunObject = Page "Phys. Inventory Recording List";
                //ToolTip = '';
            } */
        }
        area(sections)
        {
            group(PRD)
            {
                Caption = 'Production Orders';
                
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
            }
            group(Inventory)
            {
                Caption = 'Inventory Movement';
                Image = Journals;

                action(TO)
                {
                    ApplicationArea = Location;
                    Caption = 'Transfer Orders';
                    Image = Document;
                    RunObject = Page "Transfer Orders";
                    ToolTip = 'Move inventory items between company locations. With transfer orders, you ship the outbound transfer from one location and receive the inbound transfer at the other location. This allows you to manage the involved warehouse activities and provides more certainty that inventory quantities are updated correctly.';
                }
                action(IC)
                {
                    ApplicationArea = All;
                    Caption = 'Scrapping Process';
                    Image = "Order";
                    RunObject = Page "Invt. Shipments";
                    //ToolTip = '';
                }
            } 
            group("Product Design")
            {
                Caption = 'Workcenter & Routing';
                Image = ProductDesign;
                
                action(ProdDesign_Items)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Items';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Item List";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                
                action(Routings)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Routings';
                    Image = Route;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Routing List";
                    ToolTip = 'View or edit operation sequences and process times for produced items.';
                }

                action("Work Center Groups")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Work Center Groups';
                    RunObject = Page "Work Center Groups";
                    ToolTip = 'View or edit the list of work center groups.';
                }

                action(WorkCenters)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Work Centers';
                    Image = WorkCenter;
                    RunObject = Page "Work Center List";
                    ToolTip = 'View or edit the list of work centers.';
                }
            }
        }
        area(processing)
        {
            group(Tasks)
            {
                Caption = 'Tasks';
                
                action("Change Pro&duction Order Status")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Change Pro&duction Order Status';
                    Image = ChangeStatus;
                    RunObject = Page "Change Production Order Status";
                    ToolTip = 'Change the production order to another status, such as Released.';
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

