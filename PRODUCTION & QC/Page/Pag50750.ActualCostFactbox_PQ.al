page 50750 ActualCostFactbox_PQ
{
    Caption = 'Actual Cost Factbox';
    DataCaptionFields = "No.", Description;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "Production Order";

    layout
    {
        area(content)
        {
            group("Actual Cost")
            {
                Caption = 'Actual Cost';
                field("ActCost[1]"; ActCost[1])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Material Cost';
                    Editable = false;
                }
                field("ActCost[2]"; ActCost[2])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Capacity Cost';
                    Editable = false;
                }
                field("ActCost[3]"; ActCost[3])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Subcontracted Cost';
                    Editable = false;
                }
                field("ActCost[4]"; ActCost[4])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Capacity Overhead';
                    Editable = false;
                }
                field("ActCost[5]"; ActCost[5])
                {
                    ApplicationArea = All;
                    Caption = 'Manufacturing Overhead';
                    Editable = false;
                }
                field("ActCost[6]"; ActCost[6])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Total Cost';
                    Editable = false;
                }
                field(ActCostEach; ActCostEach)
                {
                    ApplicationArea = All;
                    Caption = 'Cost Per Unit';
                    Editable = false;
                }
                field(Text000; Text000)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(ActTimeUsed; ActTimeUsed)
                {
                    ApplicationArea = All;
                    Caption = 'Actual Time Used';
                    DecimalPlaces = 0 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        CostCalcMgt.CalcProdOrderActTimeUsed(Rec, true);
                    end;
                }
                field(CapacityActHours; CapacityActHours)
                {
                    ApplicationArea = All;
                    Caption = 'Capacity in Hours';
                    Editable = false;
                }
                field(ActPartsPerHr; ActPartsPerHr)
                {
                    ApplicationArea = All;
                    Caption = 'Parts Per Hour';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalcExpectedCost;
        CurrPage.Update(false);
    end;

    var
        ProdOrderLine: Record "Prod. Order Line";
        GLSetup: Record "General Ledger Setup";
        CostCalcMgt: Codeunit "Cost Calculation Management";
        StdCost: array[6] of Decimal;
        ExpCost: array[6] of Decimal;
        ActCost: array[6] of Decimal;
        VarAmt: array[6] of Decimal;
        VarPct: array[6] of Decimal;
        DummyVar: Decimal;
        ShareOfTotalCapCost: Decimal;
        TimeExpendedPct: Decimal;
        ExpCapNeed: Decimal;
        ActTimeUsed: Decimal;
        Text000: Label 'Placeholder';
        "--MP6--": Integer;
        CapacityExpHours: Decimal;
        CapacityActHours: Decimal;
        StdCostEach: Decimal;
        ExpCostEach: Decimal;
        ActCostEach: Decimal;
        ExpPartsPerHr: Decimal;
        ActPartsPerHr: Decimal;
        VarAmtExp: array[6] of Decimal;
        VarPctExp: array[6] of Decimal;
        VarAmtCap: Decimal;
        VarHrsCap: Decimal;
        VarPartsPerHr: Decimal;
        TimeExpendedPctExp: Decimal;

    local procedure CalcTotal(Operand: array[6] of Decimal; var Total: Decimal)
    var
        i: Integer;
    begin
        Total := 0;

        for i := 1 to ArrayLen(Operand) - 1 do
            Total := Total + Operand[i];
    end;

    local procedure CalcVariance()
    var
        i: Integer;
    begin
        for i := 1 to ArrayLen(VarAmt) do begin
            VarAmt[i] := ActCost[i] - StdCost[i];
            VarPct[i] := CalcIndicatorPct(StdCost[i], ActCost[i]);

            //MP6 begin
            VarAmtExp[i] := ActCost[i] - ExpCost[i];
            VarPctExp[i] := CalcIndicatorPct(ExpCost[i], ActCost[i]);
            //MP6 end
        end;
    end;

    local procedure CalcIndicatorPct(Value: Decimal; "Sum": Decimal): Decimal
    begin
        if Value = 0 then
            exit(0);

        exit(Round((Sum - Value) / Value * 100, 1));
    end;

    procedure CalcExpectedCost()
    begin
        Clear(StdCost);
        Clear(ExpCost);
        Clear(ActCost);
        Clear(CostCalcMgt);

        GLSetup.Get;

        ExpCapNeed := CostCalcMgt.CalcProdOrderExpCapNeed(Rec, false);
        ActTimeUsed := CostCalcMgt.CalcProdOrderActTimeUsed(Rec, false);

        //xxx
        ActTimeUsed := ActTimeUsed / 60000;


        ProdOrderLine.SetRange(ProdOrderLine.Status, Rec.Status);
        ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", Rec."No.");
        ProdOrderLine.SetRange(ProdOrderLine."Planning Level Code", 0);
        ProdOrderLine.SetFilter(ProdOrderLine."Item No.", '<>%1', '');
        if ProdOrderLine.Find('-') then
            repeat
                CostCalcMgt.CalcShareOfTotalCapCost(ProdOrderLine, ShareOfTotalCapCost);
                CostCalcMgt.CalcProdOrderLineStdCost(
                  ProdOrderLine, 1, GLSetup."Amount Rounding Precision",
                  StdCost[1], StdCost[2], StdCost[3], StdCost[4], StdCost[5]);
                CostCalcMgt.CalcProdOrderLineExpCost(
                  ProdOrderLine, ShareOfTotalCapCost,
                  ExpCost[1], ExpCost[2], ExpCost[3], ExpCost[4], ExpCost[5]);
                CostCalcMgt.CalcProdOrderLineActCost(
                  ProdOrderLine,
                  ActCost[1], ActCost[2], ActCost[3], ActCost[4], ActCost[5],
                  DummyVar, DummyVar, DummyVar, DummyVar, DummyVar);
            until ProdOrderLine.Next = 0;

        CalcTotal(StdCost, StdCost[6]);
        CalcTotal(ExpCost, ExpCost[6]);
        CalcTotal(ActCost, ActCost[6]);
        CalcVariance;
        TimeExpendedPct := CalcIndicatorPct(ExpCapNeed, ActTimeUsed);

        //MP6 begin
        StdCostEach := 0;
        ExpCostEach := 0;
        ActCostEach := 0;
        ExpPartsPerHr := 0;
        ActPartsPerHr := 0;
        VarAmtCap := 0;
        VarHrsCap := 0;
        VarPartsPerHr := 0;

        CapacityExpHours := ExpCapNeed / 60;
        CapacityActHours := ActTimeUsed / 60;
        VarAmtCap := ActTimeUsed - ExpCapNeed;
        VarHrsCap := CapacityActHours - CapacityExpHours;
        if Rec.Quantity <> 0 then begin
            StdCostEach := StdCost[6] / Rec.Quantity;
            ExpCostEach := ExpCost[6] / Rec.Quantity;
            ActCostEach := ActCost[6] / Rec.Quantity;

            ExpPartsPerHr := CapacityExpHours / Rec.Quantity;
            ActPartsPerHr := CapacityActHours / Rec.Quantity;
            VarPartsPerHr := ActPartsPerHr - ExpPartsPerHr;
        end;
        //MP6 end
    end;
}

