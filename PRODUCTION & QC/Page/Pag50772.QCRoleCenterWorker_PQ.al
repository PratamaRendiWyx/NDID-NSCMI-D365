page 50772 QCWorkerRoleCenter_PQ
{
    ApplicationArea = All;
    Caption = 'Quality Control (Worker)';
    PageType = RoleCenter;
    // version QC11.01

    // //QC6  Added QC Activities Menu
    // 
    // QC7.2
    //   - Added "Tracked Items" and "Purchase Orders" Activity Buttons
    //   - Hooked up P 14004614 to Serial No. List Activity Button
    // 
    // QC7.3 
    //   - Added Action to "Quality Control" to launch "Quality Test Lines" Page
    // 
    // QC80.1
    //   - Added "QC Requirements" HomeItems Action
    // 
    // QC10.2
    //   - Changed Promoted Action Category4 to "Setup", and placed "QC Setup" Action in it
    //   - Created "System Indicators" for Queue Stacks
    //   - Created "New QC Test" (Lot/SN Test) in Activities Pane
    //
    // QC13.0
    //   - REMed-Out the "Connect" Page Part because of Compile Error
    // QC.ALS FC 01/04/20 Customize Role Center
    // PromotedActionCategories = 'New,Process,Report,Setup';

    layout
    {
        area(rolecenter)
        {

            part(Control139; "Headline RC Prod. Planner")
            {
                ApplicationArea = Basic, Suite;
            }
            part(QCActivities; QualityControlActivities_PQ)
            {
                ApplicationArea = Basic, Suite;
            }
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
            part(Control4; QualityPerStatus_PQ)
            {
                ApplicationArea = All;
            }
            part(Control1905989608; "My Items")
            {
                ApplicationArea = All;
            }
            part(Control1; "My Job Queue")
            {
                Visible = false;
                ApplicationArea = All;
            }
            part(Control3; "Report Inbox Part")
            {
                ApplicationArea = All;
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(reporting)
        {

            group(Report)
            {
                Caption = 'Reports';
            }
        }
        area(embedding)
        {

            action("Quality Specifications")
            {
                Caption = 'Quality Specifications';
                RunObject = Page QCSpecificationList_PQ;
                ToolTip = 'Open Quality Specification List';
                ApplicationArea = All;
            }
            action("Lot/Serial No. Testing")
            {
                Caption = 'Quality Tests';
                RunObject = Page QCTestList_PQ;
                ToolTip = 'Open Quality Testing List';
                ApplicationArea = All;
            }
            action("Lot information")
            {
                Caption = 'Lot No. Information';
                RunObject = Page "Lot No. Information List";
                ToolTip = 'Open Lot Number List';
                ApplicationArea = All;
            }

            action(Items)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                ToolTip = 'Open Item List';
                ApplicationArea = All;
            }
            action(PR)
            {
                Caption = 'Purchase Requests';
                RunObject = Page "Purchase Quotes";
                ToolTip = 'Open Purchase Requests List';
                ApplicationArea = All;
            }
        }
        area(sections)
        {
            group(Orders)
            {
                Caption = 'Incoming & Production Output';
                Image = Sales;
                action(PO)
                {
                    Caption = 'Incoming Material';
                    RunObject = Page "Purchase Order List";
                    RunPageView = WHERE("Location Code" = filter('WH-RM'));
                    ApplicationArea = All;
                }
                action(RPO)
                {
                    Caption = 'Production Output';
                    RunObject = Page "Released Production Orders";
                    ApplicationArea = All;
                }
            }
            group(QC)
            {
                Caption = 'Quality Control';

                action(QS)
                {
                    Caption = 'Quality Specifications';
                    RunObject = Page QCSpecificationList_PQ;
                    ToolTip = 'Open Quality Specification List';
                    ApplicationArea = All;
                }
                action(MS)
                {
                    Caption = 'Quality Measures';
                    RunObject = Page QCControlMeasures_PQ;
                    ToolTip = 'Edit Quality Measures';
                    //Visible = false;
                    ApplicationArea = All;
                }
                action(MD)
                {
                    Caption = 'Quality Methods';
                    RunObject = Page QCControlMethods_PQ;
                    ToolTip = 'Edit Quality Methods';
                    //Visible = false;
                    ApplicationArea = All;
                }
                action(QR)
                {
                    Caption = 'Quality Requirements';
                    RunObject = Page QCRequirements_PQ;
                    ToolTip = 'Edit Quality Requirements';
                    //Visible = false;
                    ApplicationArea = All;
                }
                action(RL)
                {
                    Caption = 'Routing List';
                    RunObject = Page "Routing List";
                    ToolTip = 'Add Quality Specification to Routing Process';
                    ApplicationArea = All;
                }
            }

            group(Inventory)
            {
                Caption = 'Inventory';
                Image = ProductDesign;

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

            group(History)
            {
                Caption = 'History';
                action("Closed QC Tests")
                {
                    Caption = 'Closed Quality Tests';
                    RunObject = Page QCTestList_PQ;
                    RunPageView = WHERE("Test Status" = CONST(Closed));
                    ApplicationArea = All;
                }
                action("Rejected QC Tests")
                {
                    Caption = 'Rejected Quality Tests';
                    RunObject = Page QCTestList_PQ;
                    RunPageView = WHERE("Test Status" = CONST(Rejected));
                    ApplicationArea = All;
                }
            }
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            separator(Separator1240070014)
            {
            }
            separator(Separator89)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Item &Tracing")
            {
                Caption = 'Item &Tracing';
                Image = ItemTracing;
                RunObject = Page "Item Tracing";
                ToolTip = 'Open Item Tracing';
                ApplicationArea = All;
            }
            action("Navi&gate")
            {
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
                ToolTip = 'Open Navigate';
                ApplicationArea = All;
            }
        }
    }
}

