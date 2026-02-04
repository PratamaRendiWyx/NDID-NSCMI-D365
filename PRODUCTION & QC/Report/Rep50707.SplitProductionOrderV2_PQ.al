report 50707 SplitProductionOrderV2_PQ
{
    Caption = 'Carry out Production Order';
    ProcessingOnly = true;

    dataset
    {
        dataitem(CreateNew; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                exit;
                //Action Here
                if Confirm(label1) then begin
                    //validation before split 
                    if StartingDate = 0D then
                        Error('Starting Date is Required.');
                    if quantity = 0 then
                        Error('Quantity is Required.');
                    if ShiftCode = '' then
                        Error('Shift Code is Required.');
                    //-
                    SplitProductionOrder();
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    ShowCaption = false;
                    //list field name
                    field(StartingDate; StartingDate)
                    {
                        Caption = 'Starting Date';
                        ApplicationArea = All;
                        ShowMandatory = true;

                    }
                    field(ShiftCode; ShiftCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Shift';
                        TableRelation = "Work Shift".Code;
                        ShowMandatory = true;
                        Visible = false;
                        trigger OnValidate()
                        var
                            myInt: Integer;
                            workShift: Record "Work Shift";
                        begin
                            if StartingDate = 0D then
                                Error('Starting Date is Required.');
                            Clear(workShift);
                            workShift.SetRange(Code, ShiftCode);
                            if workShift.Find('-') then
                                StartingTime := workShift."Starting Time";
                        end;
                    }
                    field(quantity; quantity)
                    {
                        Caption = 'Quantity';
                        ApplicationArea = All;
                        ShowMandatory = true;
                        trigger OnValidate()
                        var
                            myInt: Integer;
                        begin
                            if quantity > v_remainQty then
                                Error('Quantity can''t greather than remain qty [%1]', v_remainQty);
                            if quantity <= 0 then
                                Error('Quantity can''t less than remain qty [%1],', v_remainQty);
                        end;
                    }
                    field(ProductionLine; ProductionLine)
                    {
                        ApplicationArea = All;
                        trigger OnLookup(Var Text: Text): Boolean
                        var
                            ProdLine: Record "Production Line";
                            ProductionLines: page "Production Lines";
                            XData: Record "Production Line";
                        begin
                            Clear(ProductionLines);
                            Clear(ProdLine);
                            XData.SetRange("Item No.", productionOrder1."Source No.");
                            ProductionLines.SetRecord(XData);
                            ProductionLines.SetTableView(XData);
                            ProductionLines.LookupMode := true;
                            if ProductionLines.RunModal() = Action::LookupOK then begin
                                ProductionLines.SetSelectionFilter(ProdLine);
                                if ProdLine.FindSet() then begin
                                    ProductionLine := ProdLine.Code;
                                    CapacityLine := ProdLine."Capacity Line";
                                end;
                            end;
                        end;

                        trigger OnValidate()
                        var
                            ProdLine: Record "Production Line";
                        begin
                            Clear(ProdLine);
                            ProdLine.SetRange(Code, ProductionLine);
                            ProdLine.SetRange("Item No.", productionOrder1."Source No.");
                            if Not ProdLine.Find('-') then
                                Error('Production Line does not exists.');
                        end;
                    }
                    field(CapacityLine; CapacityLine)
                    {
                        ApplicationArea = All;
                        Caption = 'Capacity Line';
                        Enabled = false;
                    }
                    field(dueDate; dueDate)
                    {
                        Caption = 'Due Date';
                        ApplicationArea = All;
                        Visible = false;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    local procedure SplitProductionOrder()
    var
        manufacturingsetup: Record "Manufacturing Setup";
        OrderNo: Text;
        actualRemainQty: Decimal;
        RefreshProdOrder: Report "Refresh Production Order";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        // if productionOrder1.FindSet() then begin
        if quantity > v_remainQty then
            Error('Quantity can''t greather than remain qty [%1]', v_remainQty);
        if quantity <= 0 then
            Error('Quantity can''t less than remain qty [%1],', v_remainQty);

        Clear(actualRemainQty);
        // copy production order 
        productionOrder2.Init();
        productionOrder2.Copy(productionOrder1);
        Clear(OrderNo);
        Clear(manufacturingsetup);
        Clear(NoSeriesMgt);
        if manufacturingsetup.Get() then
            OrderNo := NoSeriesMgt.GetNextNo(manufacturingsetup."Firm Planned Order Nos.", WorkDate(), true);
        //insert data split production order
        actualRemainQty := v_remainQty - quantity;
        productionOrder2."Source No." := productionOrder1."Source No.";
        productionOrder2."Variant Code" := productionOrder1."Variant Code";
        productionOrder2."No." := OrderNo;
        productionOrder2."Starting Date-Time" := CreateDateTime(StartingDate, StartingTime);
        if dueDate = 0D then
            if StartingDateTime <> 0DT then
                dueDate := DT2Date(StartingDateTime) - 1;
        productionOrder2."Due Date" := dueDate;
        // productionOrder2.Validate("Starting Date-Time");
        productionOrder2."Capacity Line" := CapacityLine;
        productionOrder2.Shift := ShiftCode;
        productionOrder2."Production Line" := ProductionLine;
        productionOrder2.Quantity := quantity;
        productionOrder2.IsSplitProcess := true;
        productionOrder2.Status := productionOrder2.Status::"Firm Planned";
        productionOrder2.Insert(true);

        //refresh production order for release production order
        Clear(CodeProductionOrderMgt);
        CodeProductionOrderMgt.refreshProductionOrder(productionOrder2);

        //update | Delete orignal firm production order 
        if actualRemainQty > 0 then begin
            productionOrder1.Quantity := actualRemainQty;
            productionOrder1.Modify(true);
            //refresh production order (Original : firm production order)
            Clear(CodeProductionOrderMgt);
            CodeProductionOrderMgt.refreshProductionOrder(productionOrder1);
        end else begin
            Clear(ProdOrderLine);
            ProdOrderLine.Reset();
            ProdOrderLine.SetRange("Prod. Order No.", productionOrder1."No.");
            if ProdOrderLine.FindSet() then begin
                //cleansing RSV
                //cleansingReservationEntry(ProdOrderLine."Prod. Order No.");
                //-
                ProdOrderLine.DeleteRelations();
                ProdOrderLine.Delete();
                productionOrder1.DeleteProdOrderRelations();
                productionOrder1.Delete();
            end;
        end;
        // end;
    end;

    local procedure cleansingReservationEntry(iProdOrderNo: Text)
    var
        reservationEntry: Record "Reservation Entry";
    begin
        //cleansing 2, production Order
        Clear(reservationEntry);
        reservationEntry.Reset();
        reservationEntry.SetRange("Source ID", iProdOrderNo);
        if reservationEntry.FindSet() then begin
            reservationEntry.DeleteAll();
        end;
        //-
    end;

    procedure setParameter(var iReqLines: Record "Requisition Line"; var iQty: Decimal)
    begin
        RequtitionLines := iReqLines;
        quantity := iQty;
    end;

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        CurrReport.UseRequestPage(true);
    end;

    //var refresh production order
    var
        Item: Record Item;
        CalcMethod: Option "One Level","All Levels";
        UpdateReservations: Boolean;

    var
        RequtitionLines: Record "Requisition Line";
        NoSeriesMgt: Codeunit "No. Series";
        StartingDateTime: DateTime;
        ProductionLine: Code[20];
        StartingDate: Date;
        StartingTime: Time;
        ShiftCode: Code[20];
        CapacityLine: Decimal;
        quantity: Decimal;
        dueDate: Date;
        v_remainQty: Decimal;
        productionOrder1: Record "Production Order";
        productionOrder2: Record "Production Order";
        label1: Label 'Are you sure want to split production order ?';

        CodeProductionOrderMgt: Codeunit ProdOrderManagement_PQ;

}
