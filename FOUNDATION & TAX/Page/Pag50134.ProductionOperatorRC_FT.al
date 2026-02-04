page 50134 ProductionOperatorRC_FT
{
    Caption = 'Production Shop Floor NSCMJ';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
                part(SFA; ShopFloorActivities_FT)
                {
                    ApplicationArea = Manufacturing;
                }
            }

        }
    }

    actions
    {
        area(reporting)
        {
            action("&Capacity Task List")
            {
                ApplicationArea = Manufacturing;
                Caption = '&Capacity Task List';
                Image = "Report";
                RunObject = Report "Capacity Task List";
                ToolTip = 'View the production orders that are waiting to be processed at the work centers and machine centers. Printouts are made for the capacity of the work center or machine center). The report includes information such as starting and ending time, date per production order and input quantity.';
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
        area(embedding)
        {
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
            action(TO)
            {
                ApplicationArea = Manufacturing;
                Caption = 'Transfer Order';
                RunObject = Page "Transfer Order";
                //ToolTip = '';
            }

            action(Item)
            {
                ApplicationArea = Manufacturing;
                Caption = 'Items';
                RunObject = Page "Item List";
                //RunPageView = where("Replenishment System" = const("Prod. Order"));
                //ToolTip = 'View the list of production items.';
            }

/*             action(IBL)
            {
                ApplicationArea = Manufacturing;
                Caption = 'Item by Location';
                RunObject = Page "Items by Location";
                //ToolTip = '';
            } */
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
        area(sections)
        {
        }
        area(creation)
        {
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
        }
    }
}

