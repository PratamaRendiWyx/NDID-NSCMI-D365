page 50760 ProductionOrderStatus_PQ
{
    Caption = 'Production Order Status';
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Order';
    SourceTable = "Prod. Order Routing Line";
    SourceTableTemporary = true;
    ApplicationArea = All;
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Lines';
                IndentationColumn = Rec."Indentation";
                TreeInitialState = CollapseAll;
                //IndentationControls = Type, Description;
                ShowAsTree = true;
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the number of the related production order.';
                    Style = Strong;
                    StyleExpr = IsParentExpr;
                    //Visible = ProdOrderNoVisible;

                    trigger OnDrillDown()
                    var
                        ProductionOrder: Record "Production Order";
                    begin
                        ProductionOrder.Reset();
                        ProductionOrder.SetRange(Status, Rec.Status);
                        ProductionOrder.SetRange("No.", Rec."Prod. Order No.");
                        if ProductionOrder.FindFirst() then
                            Page.RunModal(Page::"Released Production Order", ProductionOrder);
                    end;
                }
                field("AM Parent Item No."; Rec."Parent Item No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the item no.';
                    Style = Strong;
                    StyleExpr = IsParentExpr;
                }
                field("Parent Description"; Rec."Parent Description")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the description.';
                    Style = Strong;
                    StyleExpr = IsParentExpr;
                }
                field("Parent Quantity"; Rec."Parent Quantity")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the quantity.';
                }
                field("Parent Starting Date"; Rec."Parent Starting Date-Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the starting date time.';
                }
                field("Parent Ending Date-Time"; Rec."Parent Ending Date-Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the ending date time.';
                }

                field("Schedule Manually"; Rec."Schedule Manually")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies that the underlying capacity need is recalculated each time a change is made in the schedule of the routing.';
                    Visible = false;

                }
                field("Operation No."; Rec."Operation No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the operation number.';
                }
                field("Previous Operation No."; Rec."Previous Operation No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the previous operation number.';
                    Visible = false;
                }
                field("Next Operation No."; Rec."Next Operation No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the next operation number.';
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the type of operation.';
                    HideValue = IsParentExpr;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the description of the operation.';
                }
                field("Routing Status"; Rec."Routing Status")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the status of the routing line.';
                    StyleExpr = ColorVar;
                }
                field("Flushing Method"; Rec."Flushing Method")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.';
                    Visible = false;
                }
                field("Starting Date-Time"; Rec."Starting Date-Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the starting date and the starting time, which are combined in a format called "starting date-time".';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }


                field("Ending Date-Time"; Rec."Ending Date-Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the ending date and the ending time, which are combined in a format called "ending date-time".';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field("Input Quantity"; Rec."Input Quantity")
                {
                    Caption = 'Input Quantity';
                    ApplicationArea = All;
                    HideValue = IsParentExpr;
                }
                field("Actual Output Qty"; Rec."Actual Output Qty")
                {
                    Caption = 'Actual Output Qty';
                    ApplicationArea = All;
                    HideValue = IsParentExpr;
                }
                field(RemainingQty; Rec."Input Quantity" - Rec."Actual Output Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Remaining Quantity';
                    HideValue = IsParentExpr;
                }
                field("Setup Time"; Rec."Setup Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the setup time of the operation.';
                    HideValue = IsParentExpr;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field("Run Time"; Rec."Run Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the run time of the operation.';
                    HideValue = IsParentExpr;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field("Wait Time"; Rec."Wait Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the wait time after processing.';
                    HideValue = IsParentExpr;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field("Move Time"; Rec."Move Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the move time.';
                    HideValue = IsParentExpr;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field("Fixed Scrap Quantity"; Rec."Fixed Scrap Quantity")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the fixed scrap quantity.';
                    Visible = false;
                }
                field("Routing Link Code"; Rec."Routing Link Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies a routing link code.';
                    Visible = false;
                }
                field("Scrap Factor %"; Rec."Scrap Factor %")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the scrap factor in percent.';
                    Visible = false;
                }
                field("Send-Ahead Quantity"; Rec."Send-Ahead Quantity")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the send-ahead quantity of the operation.';
                    Visible = false;
                }
                field("Concurrent Capacities"; Rec."Concurrent Capacities")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the con capacity of the operation.';
                    Visible = false;
                }
                field("Unit Cost per"; Rec."Unit Cost per")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the unit cost for this operation if it is different than the unit cost on the work center or machine center card.';
                    Visible = false;
                }
                field("Actual Time Qty"; Rec."Actual Time Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Time Qty';
                    HideValue = IsParentExpr;
                }
                field("Expected Operation Cost Amt."; Rec."Expected Operation Cost Amt.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the total cost of operations. It is automatically calculated from the capacity need, when a production order is refreshed or replanned.';
                    Visible = false;
                }
                field("Expected Capacity Ovhd. Cost"; Rec."Expected Capacity Ovhd. Cost")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the capacity overhead. It is automatically calculated from the capacity need, when a production order is refreshed or replanned.';
                    Visible = false;
                }
                field("Unit Cost Calculation"; Rec."Unit Cost Calculation")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Cost Calculation';
                    HideValue = IsParentExpr;
                    Visible = false;
                }


                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the location where the machine or work center on the production order routing line operates.';
                    Visible = false;
                }
                field("Open Shop Floor Bin Code"; Rec."Open Shop Floor Bin Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the corresponding bin at the machine or work center, if the location code matches the setup of that machine or work center.';
                    Visible = false;
                }
                field("To-Production Bin Code"; Rec."To-Production Bin Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the bin that holds components with a flushing method, that involves a warehouse activity to bring the items to the bin.';
                    Visible = false;
                }
                field("From-Production Bin Code"; Rec."From-Production Bin Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the corresponding bin at the machine or work center if the location code matches the setup of that machine or work center.';
                    Visible = false;
                }

            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Show Document")
            {
                ApplicationArea = All;
                Caption = 'Show Document';
                Promoted = true;
                PromotedCategory = Process;
                Image = ViewDocumentLine;
                Visible = false;

                trigger OnAction()
                var
                    ProductionOrder: Record "Production Order";
                begin
                    ProductionOrder.Reset();
                    ProductionOrder.SetRange(Status, Rec.Status);
                    ProductionOrder.SetRange("No.", Rec."Prod. Order No.");
                    if ProductionOrder.FindFirst() then
                        Page.RunModal(Page::"Released Production Order", ProductionOrder);
                end;
            }
            group("Order")
            {
                Caption = 'Order';
                Image = Order;
                action(Routing)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Ro&uting';
                    Image = Route;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View or edit the operations list of the parent item on the line.';

                    trigger OnAction()
                    begin
                        ShowRouting;
                    end;
                }
                action(Components)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Components';
                    Image = Components;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View or edit the production order components of the parent item on the line.';

                    trigger OnAction()
                    begin
                        ShowComponents;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Indentation" = 0 then
            IsParentExpr := true
        else
            IsParentExpr := false;

        ColorVar := 'Strong';
        if Rec."Routing Status" = Rec."Routing Status"::Finished then
            ColorVar := 'Favorable'
        else begin
            if (Rec."Ending Date" < Today) and (Rec."Routing Status" = Rec."Routing Status"::"In Progress") then
                ColorVar := 'Unfavorable';
        end;

    end;

    trigger OnOpenPage()
    begin
        RefreshPage;
    end;

    var
        IsParentExpr: Boolean;
        ColorVar: Text;

    procedure RefreshPage()
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ProductionOrder: Record "Production Order";
    begin
        ProdOrderLine.Reset();
        ProdOrderLine.SetCurrentKey("Prod. Order No.");
        ProdOrderLine.SetRange(Status, ProdOrderLine.Status::Released);
        if ProdOrderLine.FindSet() then
            repeat

                ProdOrderRoutingLine.Reset();
                ProdOrderRoutingLine.SetRange(Status, ProdOrderLine.Status);
                ProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                ProdOrderRoutingLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
                ProdOrderRoutingLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
                ProdOrderRoutingLine.SetFilter("Routing Status", '<>%1', ProdOrderRoutingLine."Routing Status"::" ");
                if ProdOrderRoutingLine.FindFirst() then begin

                    ProductionOrder.Reset();
                    ProductionOrder.SetRange(Status, ProdOrderLine.Status);
                    ProductionOrder.SetRange("No.", ProdOrderLine."Prod. Order No.");
                    if ProductionOrder.FindFirst() then;

                    Rec.Init();
                    Rec.Status := ProdOrderLine.Status;
                    Rec."Prod. Order No." := ProdOrderLine."Prod. Order No.";
                    Rec."Routing Reference No." := ProdOrderLine."Line No.";
                    Rec."Routing No." := '';
                    Rec."Operation No." := '';
                    Rec."PQ Operation No." := '';
                    Rec."Parent Item No." := ProdOrderLine."Item No.";
                    Rec."Parent Description" := ProdOrderLine.Description;
                    Rec."Parent Quantity" := ProdOrderLine.Quantity;
                    Rec."Parent Starting Date-Time" := ProductionOrder."Starting Date-Time";
                    Rec."Parent Ending Date-Time" := ProductionOrder."Ending Date-Time";
                    Rec."Indentation" := 0;
                    Rec.Insert();
                end;

                ProdOrderRoutingLine.Reset();
                ProdOrderRoutingLine.SetRange(Status, ProdOrderLine.Status);
                ProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                ProdOrderRoutingLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
                ProdOrderRoutingLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
                ProdOrderRoutingLine.SetFilter("Routing Status", '<>%1', ProdOrderRoutingLine."Routing Status"::" ");
                if ProdOrderRoutingLine.FindSet() then
                    repeat
                        Rec.Init();
                        Rec.TransferFields(ProdOrderRoutingLine);
                        Rec."PQ Operation No." := Rec."Operation No.";
                        Rec."Parent Item No." := ProdOrderLine."Item No.";
                        Rec."Parent Description" := ProdOrderLine.Description;
                        Rec."Parent Quantity" := ProdOrderLine.Quantity;
                        Rec."Parent Starting Date-Time" := Rec."Starting Date-Time";
                        Rec."Parent Ending Date-Time" := Rec."Ending Date-Time";
                        Rec."Indentation" := 1;
                        Rec.Insert();
                    until ProdOrderRoutingLine.Next() = 0;
            until ProdOrderLine.Next() = 0;

        CurrPage.Update(false);
    end;

    procedure ShowRouting()
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        ProdOrderLine.Reset();
        ProdOrderLine.SetRange(Status, Rec.Status);
        ProdOrderLine.SetRange("Prod. Order No.", Rec."Prod. Order No.");
        ProdOrderLine.SetRange("Line No.", Rec."Routing Reference No.");
        if ProdOrderLine.FindFirst() then begin

            ProdOrderRoutingLine.SetRange(Status, ProdOrderLine.Status);
            ProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
            ProdOrderRoutingLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
            ProdOrderRoutingLine.SetRange("Routing No.", ProdOrderLine."Routing No.");

            PAGE.RunModal(PAGE::"Prod. Order Routing", ProdOrderRoutingLine);
        end;
    end;

    local procedure ShowComponents()
    var
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        ProdOrderLine.Reset();
        ProdOrderLine.SetRange(Status, Rec.Status);
        ProdOrderLine.SetRange("Prod. Order No.", Rec."Prod. Order No.");
        ProdOrderLine.SetRange("Line No.", Rec."Routing Reference No.");
        if ProdOrderLine.FindFirst() then begin

            ProdOrderComp.SetRange(Status, ProdOrderLine.Status);
            ProdOrderComp.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
            ProdOrderComp.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");

            PAGE.Run(PAGE::"Prod. Order Components", ProdOrderComp);
        end;
    end;
}
