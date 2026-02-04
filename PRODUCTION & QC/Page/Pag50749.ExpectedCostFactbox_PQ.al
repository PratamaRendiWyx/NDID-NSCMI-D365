page 50749 ExpectedCostFactbox_PQ
{

    Caption = 'Statistics';
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
            group("Expected Cost")
            {
                Caption = 'Expected Cost';
                field("ExpCost[1]"; ExpCost[1])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Material Cost';
                    Editable = false;
                }
                field("ExpCost[2]"; ExpCost[2])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Capacity Cost';
                    Editable = false;
                }
                field("ExpCost[3]"; ExpCost[3])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Subcontracted Cost';
                    Editable = false;
                }
                field("ExpCost[4]"; ExpCost[4])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Capacity Overhead';
                    Editable = false;
                }
                field("ExpCost[5]"; ExpCost[5])
                {
                    ApplicationArea = All;
                    Caption = 'Manufacturing Overhead';
                    Editable = false;
                }
                field("ExpCost[6]"; ExpCost[6])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Total Cost';
                    Editable = false;
                }
                field(ExpCostEach; ExpCostEach)
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
                field(ExpCapNeed; ExpCapNeed)
                {
                    ApplicationArea = All;
                    Caption = 'Capacity Need';
                    DecimalPlaces = 0 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        CostCalcMgt.CalcProdOrderExpCapNeed(Rec, true);
                    end;
                }
                field(CapacityExpHours; CapacityExpHours)
                {
                    ApplicationArea = All;
                    Caption = 'Capacity in Hours';
                    Editable = false;
                }
                field(ExpPartsPerHr; ExpPartsPerHr)
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
        R0 := '';
        R1 := 'Material Cost                     ';
        R2 := 'Capacity Cost                     ';
        R3 := 'Subcontracted Cost                ';
        R4 := 'Capacity Overhead                 ';
        R5 := 'Manufacturing Overhead            ';
        R6 := 'Total Cost                        ';
        R7 := 'Cost Per Unit                     ';
        V1 := 'Expected Cost';
        V2 := 'Actual Cost';
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
        R0: Text;
        R1: Text;
        R2: Text;
        R3: Text;
        R4: Text;
        R5: Text;
        R6: Text;
        R7: Text;
        V1: Text;
        V2: Text;

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
        //xxx
        ExpCapNeed := ExpCapNeed / 60000;

        ActTimeUsed := CostCalcMgt.CalcProdOrderActTimeUsed(Rec, false);
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

