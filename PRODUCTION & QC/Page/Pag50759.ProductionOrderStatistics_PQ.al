page 50759 ProductionOrderStatistics_PQ
{

    Caption = 'Production Order Statistics';
    DataCaptionFields = "No.", Description;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Production Order";

    layout
    {
        area(content)
        {

            field("Prod. Order Qty."; Rec.Quantity)
            {
                ApplicationArea = All;
                Caption = 'Prod. Order Qty.';
                Editable = false;
                ToolTip = 'The Quantity being produced on the Prod. Order';
            }
            group(General)
            {
                Caption = 'General';
                fixed(Control1903895301)
                {
                    ShowCaption = false;
                    group("Standard Cost")
                    {
                        Caption = 'Standard Cost';
                        field(MaterialCost_StandardCost; StdCost[1])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Material Cost';
                            Editable = false;
                        }
                        field(CapacityCost_StandardCost; StdCost[2])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Capacity Cost';
                            Editable = false;
                        }
                        field("StdCost[3]"; StdCost[3])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Subcontracted Cost';
                            Editable = false;
                        }
                        field("StdCost[4]"; StdCost[4])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Capacity Overhead';
                            Editable = false;
                        }
                        field("StdCost[5]"; StdCost[5])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Manufacturing Overhead';
                            Editable = false;
                        }
                        field(TotalCost_StandardCost; StdCost[6])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Total Cost';
                            Editable = false;
                        }
                        field(CapacityUoM; CapacityUoM)
                        {
                            ApplicationArea = All;
                            Caption = 'Capacity Need';
                            TableRelation = "Capacity Unit of Measure".Code;

                            trigger OnValidate()
                            var
                                CalendarMgt: Codeunit "Shop Calendar Management";
                            begin
                                ExpCapNeed := CostCalcMgt.CalcProdOrderExpCapNeed(Rec, false) / CalendarMgt.TimeFactor(CapacityUoM);
                                ActTimeUsed := CostCalcMgt.CalcProdOrderActTimeUsed(Rec, false) / CalendarMgt.TimeFactor(CapacityUoM);
                            end;
                        }
                        field(StdCostEach; StdCostEach)
                        {
                            ApplicationArea = All;
                            Caption = 'Cost Per Unit';
                            Editable = false;
                            ToolTip = 'Standard Cost of each unit of the Item';
                        }
                        field(Text000; Text000)
                        {
                            ApplicationArea = All;
                            Visible = false;
                        }
                        field("Capacity Need"; Text000)
                        {
                            ApplicationArea = All;
                            Caption = 'Capacity Need';
                            Visible = false;
                        }
                        field("Capacity in Hours"; Text000)
                        {
                            ApplicationArea = All;
                            Caption = 'Capacity in Hours';
                            Visible = false;
                        }
                        field("Parts Per Hour"; Text000)
                        {
                            ApplicationArea = All;
                            Caption = 'Parts Per Hour';
                            Visible = false;
                        }
                    }
                    group("Expected Cost")
                    {
                        Caption = 'Expected Cost';
                        field(MaterialCost_ExpectedCost; ExpCost[1])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(CapacityCost_ExpectedCost; ExpCost[2])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("ExpCost[3]"; ExpCost[3])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("ExpCost[4]"; ExpCost[4])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("ExpCost[5]"; ExpCost[5])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(TotalCost_ExpectedCost; ExpCost[6])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(Control1240070011; Text000)
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field(ExpCostEach; ExpCostEach)
                        {
                            ApplicationArea = All;
                            Caption = 'Cost Per Unit';
                            Editable = false;
                            ToolTip = 'Expected Cost per Unit of Measure of the Item';
                        }
                        field(Control1240070007; Text000)
                        {
                            ShowCaption = false;
                            Visible = false;
                            ApplicationArea = All;
                        }
                        field(ExpCapNeed; ExpCapNeed)
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Expected Capacity needed to produce the order';

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
                            ToolTip = 'Expected hours needed to produce the order';
                        }
                        field(ExpPartsPerHr; ExpPartsPerHr)
                        {
                            ApplicationArea = All;
                            Caption = 'Parts Per Hour';
                            Editable = false;
                            ToolTip = 'Expected average units produced per hour';
                        }
                    }
                    group("Actual Cost")
                    {
                        Caption = 'Actual Cost';
                        field(MaterialCost_ActualCost; ActCost[1])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(CapacityCost_ActualCost; ActCost[2])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("ActCost[3]"; ActCost[3])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("ActCost[4]"; ActCost[4])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("ActCost[5]"; ActCost[5])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(TotalCost_ActualCost; ActCost[6])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(Control1240070027; Text000)
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field(ActCostEach; ActCostEach)
                        {
                            ApplicationArea = All;
                            Caption = 'Cost Per Unit';
                            Editable = false;
                            ToolTip = 'Actual Posted Cost to the Prod. Order';
                        }
                        field(Control1240070025; Text000)
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field(ActTimeUsed; ActTimeUsed)
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Total Posted time against Prod. Order';

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
                            ToolTip = 'Actual Posted Capacity used for Prod. Order';
                        }
                        field(ActPartsPerHr; ActPartsPerHr)
                        {
                            ApplicationArea = All;
                            Caption = 'Parts Per Hour';
                            Editable = false;
                            ToolTip = 'Avg. items produced per hour';
                        }
                    }
                    group("Dev. %")
                    {
                        Caption = 'Dev. %';
                        field("VarPct[1]"; VarPct[1])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("VarPct[2]"; VarPct[2])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("VarPct[3]"; VarPct[3])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("VarPct[4]"; VarPct[4])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("VarPct[5]"; VarPct[5])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("VarPct[6]"; VarPct[6])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(TimeExpendedPct; TimeExpendedPct)
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    group("STD Cost Variance")
                    {
                        Caption = 'STD Cost Variance';
                        field("VarAmt[1]"; VarAmt[1])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("VarAmt[2]"; VarAmt[2])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("VarAmt[3]"; VarAmt[3])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("VarAmt[4]"; VarAmt[4])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("VarAmt[5]"; VarAmt[5])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("VarAmt[6]"; VarAmt[6])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(Control49; Text000)
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field(Control1240070016; Text000)
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field(Control1240070015; Text000)
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field(VarAmtCap; VarAmtCap)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ToolTip = 'Differenece between Standard Capacity Cost and Actual Cap. Cost';
                        }
                        field(VarHrsCap; VarHrsCap)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ToolTip = 'Differenece between Standard Capacity hours and Actual Cap. hours';
                        }
                        field(VarPartsPerHr; VarPartsPerHr)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ToolTip = 'Differenece between Standard production average and Actual production average';
                        }
                    }
                    group("STD Cost Dev. %")
                    {
                        Caption = 'STD Cost Dev. %';
                        field(Control1240070059; VarPct[1])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(Control1240070058; VarPct[2])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(Control1240070057; VarPct[3])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(Control1240070056; VarPct[4])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(Control1240070055; VarPct[5])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(Control1240070021; VarPct[6])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(Control1240070054; Text000)
                        {
                            ApplicationArea = All;
                            Caption = 'Capacity Need';
                            Visible = false;
                        }
                        field(Control1240070019; Text000)
                        {
                            ApplicationArea = All;
                            Caption = 'Capacity Need';
                            Visible = false;
                        }
                        field(TimeExpendedPct1; TimeExpendedPct)
                        {
                            ApplicationArea = All;
                            Caption = 'TimeExpendedPct';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                        }
                        field(Control1240070017; Text000)
                        {
                            ApplicationArea = All;
                            Caption = 'Capacity Need';
                            Visible = false;
                        }
                        field(Control1240070018; Text000)
                        {
                            ApplicationArea = All;
                            Caption = 'Capacity Need';
                            Visible = false;
                        }
                    }
                    group("Exp. Cost Variance")
                    {
                        Caption = 'Exp. Cost Variance';
                        field("VarAmtExp[1]"; VarAmtExp[1])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                        }
                        field("VarAmtExp[2]"; VarAmtExp[2])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                        }
                        field("VarAmtExp[3]"; VarAmtExp[3])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                        }
                        field("VarAmtExp[4]"; VarAmtExp[4])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                        }
                        field("VarAmtExp[5]"; VarAmtExp[5])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                        }
                        field("VarAmtExp[6]"; VarAmtExp[6])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                        }
                        field(Control1240070045; Text000)
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field(Control1240070044; Text000)
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field(Control1240070043; Text000)
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field(VarAmtCap2; VarAmtCap2)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ToolTip = 'Differenece between Expected Capacity Cost and Actual Cap. Cost';
                        }
                        field(VarHrsCap2; VarHrsCap2)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ToolTip = 'Differenece between Expected Capacity hours and Actual Cap. hours';
                        }
                        field(VarPartsPerHr2; VarPartsPerHr2)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Editable = false;
                            ToolTip = 'Differenece between Expected production average and Actual production average';
                        }
                    }
                    group("Exp Cost Dev. %")
                    {
                        Caption = 'Exp Cost Dev. %';
                        field("VarPctExp[1]"; VarPctExp[1])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                        }
                        field("VarPctExp[2]"; VarPctExp[2])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                        }
                        field("VarPctExp[3]"; VarPctExp[3])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                        }
                        field("VarPctExp[4]"; VarPctExp[4])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                        }
                        field("VarPctExp[5]"; VarPctExp[5])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                        }
                        field("VarPctExp[6]"; VarPctExp[6])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                        }
                        field(Control1240070032; Text000)
                        {
                            ApplicationArea = All;
                            Caption = 'Capacity Need';
                            Visible = false;
                        }
                        field(Control1240070029; Text000)
                        {
                            ApplicationArea = All;
                            Caption = 'Capacity Need';
                            Visible = false;
                        }
                        field(TimeExpendedPctExp; TimeExpendedPctExp)
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                        }
                        field(Control1240070024; Text000)
                        {
                            ApplicationArea = All;
                            Caption = 'Capacity Need';
                            Visible = false;
                        }
                        field(Control1240070028; Text000)
                        {
                            ApplicationArea = All;
                            Caption = 'Capacity Need';
                            Visible = false;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Print Detail")
            {
                ApplicationArea = All;
                Caption = '&Print Detail';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.SetRange(Rec."No.", Rec."No.");
                    //REPORT.Run(REPORT::"AM Prod.Order - Expect Actual", true, true, Rec);
                    Rec.SetRange(Rec."No.");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        CalendarMgt: Codeunit "Shop Calendar Management";
    begin
        Clear(StdCost);
        Clear(ExpCost);
        Clear(ActCost);
        Clear(CostCalcMgt);

        GLSetup.Get;

        ExpCapNeed := CostCalcMgt.CalcProdOrderExpCapNeed(Rec, false) / CalendarMgt.TimeFactor(CapacityUoM);
        ActTimeUsed := CostCalcMgt.CalcProdOrderActTimeUsed(Rec, false) / CalendarMgt.TimeFactor(CapacityUoM);
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
    end;

    trigger OnOpenPage()
    var
        MfgSetup: Record "Manufacturing Setup";
    begin
        //Registration();

        MfgSetup.Get();
        MfgSetup.TestField("Show Capacity In");
        CapacityUoM := MfgSetup."Show Capacity In";
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
        CapacityUoM: Code[10];
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
        VarAmtCap2: Decimal;
        VarHrsCap2: Decimal;
        VarPartsPerHr2: Decimal;

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

        end;
    end;

    local procedure CalcIndicatorPct(Value: Decimal; "Sum": Decimal): Decimal
    begin
        if Value = 0 then
            exit(0);

        exit(Round((Sum - Value) / Value * 100, 1));
    end;
}

