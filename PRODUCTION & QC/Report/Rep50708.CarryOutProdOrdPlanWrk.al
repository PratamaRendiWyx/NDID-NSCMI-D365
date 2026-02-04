namespace PRODUCTIONQC.PRODUCTIONQC;
using Microsoft.Inventory.Requisition;
using Microsoft.Manufacturing.Document;
using Microsoft.Foundation.Calendar;
using Microsoft.Foundation.NoSeries;
using Microsoft.Manufacturing.Setup;
using Microsoft.Inventory.Planning;
using Microsoft.Inventory.Item;

report 50708 "Carry Out Prod. Ord. Plan Wrk"
{
    Caption = 'Carry Out Prod. Ord. - Plan.';
    ProcessingOnly = true;
    dataset
    {
        dataitem("Requisition Line"; "Requisition Line")
        {
            DataItemTableView = sorting("Worksheet Template Name", "Journal Batch Name", "Line No.");
            RequestFilterHeading = 'Planning Line';

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                WindowUpdate();
                if not "Accept Action Message" then
                    CurrReport.Skip();

                Commit();
                RunCarryOutActionsByRefOrderType("Requisition Line");
                Commit();
            end;

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                Window.Close();
                ShowResult();
            end;

            trigger OnPreDataItem()
            begin
                LockTable();

                SetReqLineFilters();
                if not Find('-') then
                    Error(Text000);

                if not HideDialog then
                    Window.Open(Text012);
                CheckPreconditions();
                CounterTotal := Count;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Production Order")
                    {
                        Caption = 'Production Order';
                        field(ProductionOrder; ProdOrderChoice::Planned)
                        {
                            ApplicationArea = Manufacturing;
                            Caption = 'Production Order';
                            ToolTip = 'Specifies that you want to create production orders for item with the Prod. Order replenishment system. You can select to create either planned or firm planned production order, and you can have the new order documents printed.';
                        }
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    protected var
        CurrReqWkshTemp: Code[10];
        CurrReqWkshName: Code[10];
        ReqLineFilters: Record "Requisition Line";

    local procedure CheckPreconditions()
    begin
        repeat
            CheckLine();
        until "Requisition Line".Next() = 0;
    end;

    local procedure CheckLine()
    var
        ReqLine2: Record "Requisition Line";
        IsHandled: Boolean;
    begin
        if "Requisition Line"."Planning Line Origin" <> "Requisition Line"."Planning Line Origin"::"Order Planning" then
            exit;

        CheckAssociations("Requisition Line");

        if "Requisition Line"."Planning Level" > 0 then
            exit;

        ReqLine2.ReadIsolation := ReqLine2.ReadIsolation::ReadUncommitted;
        ReqLine2.SetFilter("User ID", '<>%1', UserId);
        ReqLine2.SetRange("Demand Type", "Requisition Line"."Demand Type");
        ReqLine2.SetRange("Demand Subtype", "Requisition Line"."Demand Subtype");
        ReqLine2.SetRange("Demand Order No.", "Requisition Line"."Demand Order No.");
        ReqLine2.SetRange("Demand Line No.", "Requisition Line"."Demand Line No.");
        ReqLine2.SetRange("Demand Ref. No.", "Requisition Line"."Demand Ref. No.");
        if not ReqLine2.IsEmpty then
            ReqLine2.DeleteAll(true);
    end;

    local procedure CheckAssociations(var ReqLine: Record "Requisition Line")
    var
        ReqLine2: Record "Requisition Line";
        ReqLine3: Record "Requisition Line";
    begin
        ReqLine3.Copy(ReqLine);
        ReqLine2 := ReqLine;

        if ReqLine2."Planning Level" > 0 then
            while (ReqLine2.Next(-1) <> 0) and (ReqLine2."Planning Level" > 0) do;

        repeat
            ReqLine3 := ReqLine2;
            if not ReqLine3.Find() then
                Error(Text011, ReqLine."Line No.", ReqLine2."Line No.");
        until (ReqLine2.Next() = 0) or (ReqLine2."Planning Level" = 0)
    end;

    procedure SetReqWkshLine(var CurrentReqLine: Record "Requisition Line")
    begin
        CurrReqWkshTemp := CurrentReqLine."Worksheet Template Name";
        CurrReqWkshName := CurrentReqLine."Journal Batch Name";
        ReqLineFilters.Copy(CurrentReqLine);
    end;

    local procedure SetReqLineFilters()
    begin
        if ReqLineFilters.GetFilters <> '' then
            "Requisition Line".CopyFilters(ReqLineFilters);
        "Requisition Line".SetRange("Worksheet Template Name", CurrReqWkshTemp);
        if CurrReqWkshTemp <> '' then
            "Requisition Line".SetRange("Journal Batch Name", CurrReqWkshName);
        "Requisition Line".SetRange(Type, "Requisition Line".Type::Item);
        "Requisition Line".SetFilter("Action Message", '<>%1', "Requisition Line"."Action Message"::" ");
        "Requisition Line".SetRange("Ref. Order Type", "Requisition Line"."Ref. Order Type"::"Prod. Order");
        "Requisition Line".SetFilter("Production Line", '<>%1', '');
        "Requisition Line".SetFilter("Capacity Line", '>%1', 0);
        "Requisition Line".SetFilter("Qty. to Plan Order", '>%1', 0);
        "Requisition Line".SetFilter("Starting Date (Plan)", '<>%1', 0D);
        OnAfterSetReqLineFilters("Requisition Line");
    end;

    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    local procedure RunCarryOutActionsByRefOrderType(var RequisitionLine: Record "Requisition Line")
    var
        IsHandled: Boolean;
    begin
        ProdOrderChoice := ProdOrderChoice::Planned;
        CarryOutActions(Enum::"Planning Create Source Type"::Production, ProdOrderChoice.AsInteger(), CurrReqWkshTemp, CurrReqWkshName);
    end;

    local procedure doSplitBaseOnReqLine()
    var
        DivQty: Integer;
        WorkShiftCode: Record "Work Shift";
        totalDefaultWorkShift: Integer;
        i: Integer;
        varLoop: Integer;
        StartDate: Date;
        UpdDate: Date;
        RemainQty: Decimal;
        CapacityLine: Decimal;
        productionOrder2: Record "Production Order";
        OrderNo: Code[20];
        dueDate: Date;
        manufacturingsetup: Record "Manufacturing Setup";
        NoSeriesMgt: Codeunit "No. Series";
        WorkShiftCode1: Record "Work Shift";
        CheckFullPlan: Boolean;
        Item: Record Item;
        WorkShiftVacum: Record "Work Shift Vacum Cycle";
    begin
        // Message(Format(Round(7.5, 1, '>')));
        Clear(varLoop);
        Clear(DivQty);
        Clear(totalDefaultWorkShift);
        Clear(StartDate);
        //initiate 
        RemainQty := "Requisition Line"."Qty. to Plan Order";

        if "Requisition Line"."Remain Qty." = 0 then
            "Requisition Line"."Remain Qty." := "Requisition Line".Quantity;

        if RemainQty = "Requisition Line"."Remain Qty." then
            CheckFullPlan := true;

        CapacityLine := "Requisition Line"."Capacity Line";
        if "Requisition Line"."Capacity Mix" <> 0 then
            CapacityLine := "Requisition Line"."Capacity Mix";
        DivQty := Round("Requisition Line"."Qty. to Plan Order" / CapacityLine, 1, '>');

        Clear(Item);
        Item.Reset();
        Item.SetRange("No.", "Requisition Line"."No.");
        if Item.Find('-') then;

        //-
        Clear(WorkShiftCode);
        WorkShiftCode.SetRange("Default Shift", true);
        WorkShiftCode.SetCurrentKey(Code);
        if WorkShiftCode.FindSet() then begin
            totalDefaultWorkShift := WorkShiftCode.Count();
            StartDate := "Requisition Line"."Starting Date (Plan)";
            if totalDefaultWorkShift > 0 then begin
                varLoop := Round(DivQty / totalDefaultWorkShift, 1, '>');
                Clear(UpdDate);
                UpdDate := StartDate;
                for i := 1 to varLoop do begin
                    UpdDate := findCurrWorkDate(UpdDate);
                    Clear(WorkShiftCode1);
                    WorkShiftCode1.Reset();
                    WorkShiftCode1.SetRange("Default Shift", true);
                    WorkShiftCode1.SetCurrentKey(Code);
                    if WorkShiftCode1.FindSet() then begin
                        repeat
                            //do split prod order
                            if RemainQty > 0 then begin
                                if "Requisition Line"."Capacity Mix" <> 0 then begin
                                    Clear(WorkShiftVacum);
                                    WorkShiftVacum.Reset();
                                    WorkShiftVacum.SetRange("Shift Code", WorkShiftCode1.Code);
                                    if WorkShiftVacum.FindSet() then begin
                                        repeat
                                            if RemainQty > 0 then begin
                                                //Insert Prod Order 
                                                Clear(productionOrder2);
                                                productionOrder2.Init();
                                                OrderNo := "Requisition Line"."Ref. Order No.";
                                                Clear(manufacturingsetup);
                                                Clear(NoSeriesMgt);
                                                if manufacturingsetup.Get() then
                                                    OrderNo := NoSeriesMgt.GetNextNo(manufacturingsetup."Planned Order Nos.", WorkDate(), true);
                                                productionOrder2."No." := OrderNo;
                                                productionOrder2.Status := productionOrder2.Status::Planned;
                                                productionOrder2."Location Code" := "Requisition Line"."Location Code";
                                                productionOrder2."Gen. Bus. Posting Group" := "Requisition Line"."Gen. Business Posting Group";
                                                productionOrder2."Gen. Prod. Posting Group" := "Requisition Line"."Gen. Prod. Posting Group";
                                                productionOrder2."Inventory Posting Group" := Item."Inventory Posting Group";
                                                productionOrder2."Source No." := "Requisition Line"."No.";
                                                productionOrder2."Variant Code" := "Requisition Line"."Variant Code";
                                                productionOrder2."Start Date-Time (Production)" := CreateDateTime(UpdDate, WorkShiftVacum."Starting Time");
                                                if WorkShiftVacum."Starting Time" > WorkShiftVacum."Ending Time" then
                                                    productionOrder2."End Date-Time (Production)" := CreateDateTime(findCurrWorkDate(UpdDate + 1), WorkShiftVacum."Ending Time")
                                                else
                                                    productionOrder2."End Date-Time (Production)" := CreateDateTime(UpdDate, WorkShiftVacum."Ending Time");
                                                productionOrder2.Description := "Requisition Line".Description;
                                                productionOrder2."Requition Line No." := "Requisition Line"."Line No.";
                                                productionOrder2."Work Sheet Template Name" := "Requisition Line"."Worksheet Template Name";
                                                productionOrder2."Journal Batch Name" := "Requisition Line"."Journal Batch Name";
                                                productionOrder2."Ref. Order No." := "Requisition Line"."Ref. Order No.";
                                                productionOrder2.Index := i;
                                                productionOrder2."Capacity Line" := "Requisition Line"."Capacity Line";
                                                productionOrder2."Capacity Mix" := CapacityLine;
                                                productionOrder2.Shift := WorkShiftCode1.Code;
                                                productionOrder2."Vacum Cycle" := WorkShiftVacum.Cycle;
                                                productionOrder2."Production Line" := "Requisition Line"."Production Line";
                                                if RemainQty > CapacityLine then
                                                    productionOrder2.Quantity := CapacityLine
                                                else
                                                    productionOrder2.Quantity := RemainQty;
                                                productionOrder2.IsSplitProcess := true;
                                                productionOrder2.UpdateDatetime();
                                                productionOrder2.Insert(true);
                                                //refresh prod order
                                                Clear(CodeProductionOrderMgt);
                                                CodeProductionOrderMgt.refreshProductionOrder(productionOrder2);
                                            end;
                                            RemainQty := RemainQty - CapacityLine;
                                        until WorkShiftVacum.Next() = 0;
                                    end;
                                end else begin
                                    //Insert Prod Order 
                                    Clear(productionOrder2);
                                    productionOrder2.Init();
                                    OrderNo := "Requisition Line"."Ref. Order No.";
                                    Clear(manufacturingsetup);
                                    Clear(NoSeriesMgt);
                                    if manufacturingsetup.Get() then
                                        OrderNo := NoSeriesMgt.GetNextNo(manufacturingsetup."Planned Order Nos.", WorkDate(), true);
                                    productionOrder2."No." := OrderNo;
                                    productionOrder2.Status := productionOrder2.Status::Planned;
                                    productionOrder2."Location Code" := "Requisition Line"."Location Code";
                                    productionOrder2."Gen. Bus. Posting Group" := "Requisition Line"."Gen. Business Posting Group";
                                    productionOrder2."Gen. Prod. Posting Group" := "Requisition Line"."Gen. Prod. Posting Group";
                                    productionOrder2."Inventory Posting Group" := Item."Inventory Posting Group";
                                    productionOrder2."Source No." := "Requisition Line"."No.";
                                    productionOrder2."Variant Code" := "Requisition Line"."Variant Code";
                                    productionOrder2."Start Date-Time (Production)" := CreateDateTime(UpdDate, WorkShiftCode1."Starting Time");
                                    if WorkShiftCode1."Starting Time" > WorkShiftCode1."Ending Time" then
                                        productionOrder2."End Date-Time (Production)" := CreateDateTime(findCurrWorkDate(UpdDate + 1), WorkShiftCode1."Ending Time")
                                    else
                                        productionOrder2."End Date-Time (Production)" := CreateDateTime(UpdDate, WorkShiftCode1."Ending Time");
                                    productionOrder2.Description := "Requisition Line".Description;
                                    productionOrder2."Requition Line No." := "Requisition Line"."Line No.";
                                    productionOrder2."Work Sheet Template Name" := "Requisition Line"."Worksheet Template Name";
                                    productionOrder2."Journal Batch Name" := "Requisition Line"."Journal Batch Name";
                                    productionOrder2."Ref. Order No." := "Requisition Line"."Ref. Order No.";
                                    productionOrder2.Index := i;
                                    productionOrder2."Capacity Line" := CapacityLine;
                                    productionOrder2.Shift := WorkShiftCode1.Code;
                                    productionOrder2."Production Line" := "Requisition Line"."Production Line";
                                    if RemainQty > CapacityLine then
                                        productionOrder2.Quantity := CapacityLine
                                    else
                                        productionOrder2.Quantity := RemainQty;
                                    productionOrder2.IsSplitProcess := true;
                                    productionOrder2.UpdateDatetime();
                                    productionOrder2.Insert(true);
                                    //refresh prod order
                                    Clear(CodeProductionOrderMgt);
                                    CodeProductionOrderMgt.refreshProductionOrder(productionOrder2);
                                end;
                            end else begin
                                //do cleansin req. line
                            end;
                            if "Requisition Line"."Capacity Mix" = 0 then
                                RemainQty := RemainQty - CapacityLine;
                        until WorkShiftCode1.Next() = 0;
                        UpdDate := UpdDate + 1;
                    end;
                end; // end loop
                //delete req. line 
                if CheckFullPlan then
                    DeleteRequisitionLine("Requisition Line")
                else
                    updateRequitionLine("Requisition Line", "Requisition Line"."Qty. to Plan Order")
            end;
        end;
    end;

    local procedure updateDateTimeHeader(var ProductionOrder: Record "Production Order")
    var
        prodOrder1: Record "Production Order";
    begin
        if prodOrder1.Get(ProductionOrder.Status, ProductionOrder."No.") then begin
            prodOrder1."Starting Time" := ProductionOrder."Starting Time";
            prodOrder1."Starting Date" := ProductionOrder."Starting Date";
            prodOrder1."Ending Time" := ProductionOrder."Ending Time";
            prodOrder1."Ending Date" := ProductionOrder."Ending Date";
            prodOrder1."Due Date" := ProductionOrder."Due Date";
            prodOrder1.UpdateDatetime();
            prodOrder1.Modify(true);
        end;
    end;

    local procedure updateRequitionLine(var requitionLine: Record "Requisition Line"; iQtytoPlan: Decimal)
    begin
        requitionLine."Remain Qty." := requitionLine."Remain Qty." - iQtytoPlan;
        requitionLine."Qty. to Plan Order" := 0;
        requitionLine.Modify(true);
    end;

    local procedure DeleteRequisitionLine(var RequisitionLine: Record "Requisition Line")
    begin
        RequisitionLine.Delete(true);
    end;

    local procedure findCurrWorkDate(iStartDate: Date): Date
    var
        Check: Boolean;
        BaseCalendarChange: Record "Base Calendar Change";
        DateUpd: Date;
        Day: Text;
        CheckWeekly: Boolean;
    begin
        //Check Base Calendar
        Check := true;
        Clear(DateUpd);
        DateUpd := iStartDate;
        while Check do begin
            Clear(BaseCalendarChange);
            BaseCalendarChange.SetRange(Date, DateUpd);
            BaseCalendarChange.SetRange(Nonworking, true);
            if BaseCalendarChange.Find('-') then
                DateUpd := DateUpd + 1
            else begin
                //check recurring non working day
                Clear(Day);
                Day := getDayofWeek(DateUpd);
                Clear(BaseCalendarChange);
                BaseCalendarChange.Reset();
                BaseCalendarChange.SetRange("Recurring System", BaseCalendarChange."Recurring System"::"Weekly Recurring");
                BaseCalendarChange.SetRange(Nonworking, true);
                if BaseCalendarChange.FindSet() then begin
                    Clear(CheckWeekly);
                    repeat
                        if Format(BaseCalendarChange.Day) = Day then begin
                            DateUpd := DateUpd + 1;
                            CheckWeekly := true;
                        end;
                    until BaseCalendarChange.Next() = 0;
                    if not CheckWeekly then
                        Check := false;
                end else begin
                    Check := false;
                end;
            end;
        end;
        exit(DateUpd);
    end;

    local procedure getDayofWeek(iDate: Date): Text
    var
        DayOfWeek: Integer;
        Day: Text;
    begin
        DayOfWeek := Date2DWY(iDate, 1);
        case DayOfWeek of
            1:
                begin
                    Day := 'Monday';
                end;
            2:
                begin
                    Day := 'Tuesday';
                end;
            3:
                begin
                    Day := 'Wednesday';
                end;
            4:
                begin
                    Day := 'Thursday';
                end;
            5:
                begin
                    Day := 'Friday';
                end;
            6:
                begin
                    Day := 'Saturday';
                end;
            7:
                begin
                    Day := 'Sunday';
                end;
        end;
        exit(Day);
    end;

    procedure CarryOutActions(SourceType: Enum "Planning Create Source Type"; Choice: Option;
                                              WkshTempl: Code[10];
                                              WkshName: Code[10])
    begin
        // if not CarryOutAction.TryCarryOutAction(SourceType, "Requisition Line", Choice, WkshTempl, WkshName) then begin
        //     CounterFailed := CounterFailed + 1;
        //     OnCarryOutActionsOnAfterUpdateCounterFailed("Requisition Line", WkshTempl, WkshName);
        // end;
        doSplitBaseOnReqLine();
    end;

    local procedure WindowUpdate()
    begin
        Counter := Counter + 1;
        Window.Update(1, "Requisition Line"."No.");
        Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
    end;

    local procedure ShowResult()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if CounterFailed > 0 then
            if GetLastErrorText() = '' then
                Message(Text013, CounterFailed)
            else
                Message(GetLastErrorText);
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeRunCarryOutActionsByRefOrderType(var RequisitionLine: Record "Requisition Line"; PurchOrderChoice: Enum "Planning Create Purchase Order"; ReqWkshTemp: Code[10]; ReqWksh: Code[10]; NoPlanningResiliency: Boolean; var CounterFailed: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetReqLineFilters(var RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCarryOutActionsOnAfterUpdateCounterFailed(var RequisitionLine: Record "Requisition Line"; WkshTempl: Code[10]; WkshName: Code[10])
    begin
    end;



    var
        CodeProductionOrderMgt: Codeunit ProdOrderManagement_PQ;
        ProdOrderChoice: Enum "Planning Create Prod. Order";
        HideDialog: Boolean;
        CarryOutAction: Codeunit "Carry Out Action";
        CounterFailed: Integer;
        Counter: Integer;
        CounterTotal: Integer;
        Window: Dialog;
        Text011: Label 'You must make order for both line %1 and %2 because they are associated.';
        Text000: Label 'There are no planning lines to make orders for.';
        Text013: Label 'Not all Requisition Lines were carried out.\A total of %1 lines were not carried out because of errors encountered.';
        Text012: Label 'Carrying Out Actions  #1########## @2@@@@@@@@@@@@@';
}
