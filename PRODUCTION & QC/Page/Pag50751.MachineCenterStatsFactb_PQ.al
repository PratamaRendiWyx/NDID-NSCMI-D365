page 50751 MachineCenterStatsFactb_PQ
{

    Caption = 'Machine Center Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "Machine Center";

    layout
    {
        area(content)
        {
            group("This Period")
            {
                Caption = 'This Period';
                field("WorkCtrDateName[1]"; WorkCtrDateName[1])
                {
                    ApplicationArea = All;
                    Caption = 'Expected';
                }
                field("WorkCtrCapacity[1]"; WorkCtrCapacity[1])
                {
                    ApplicationArea = All;
                    Caption = 'Total Capacity';
                    DecimalPlaces = 0 : 5;
                }
                field("WorkCtrEffCapacity[1]"; WorkCtrEffCapacity[1])
                {
                    ApplicationArea = All;
                    Caption = 'Effective Capacity';
                    DecimalPlaces = 0 : 5;
                }
                field("WorkCtrExpEfficiency[1]"; WorkCtrExpEfficiency[1])
                {
                    ApplicationArea = All;
                    Caption = 'Efficiency %';
                    DecimalPlaces = 0 : 5;
                }
                field("WorkCtrExpCost[1]"; WorkCtrExpCost[1])
                {
                    ApplicationArea = All;
                    Caption = 'Total Cost';
                    DecimalPlaces = 0 : 5;
                }
                field(Text000; Text000)
                {
                    ApplicationArea = All;
                    Caption = 'Actual';
                    Visible = false;
                }
                field("WorkCtrActNeed[1]"; WorkCtrActNeed[1])
                {
                    ApplicationArea = All;
                    Caption = 'Need';
                    DecimalPlaces = 0 : 5;
                }
                field("WorkCtrActEfficiency[1]"; WorkCtrActEfficiency[1])
                {
                    ApplicationArea = All;
                    Caption = 'Efficiency %';
                    DecimalPlaces = 0 : 5;
                }
                field("WorkCtrActCost[1]"; WorkCtrActCost[1])
                {
                    ApplicationArea = All;
                    Caption = 'Total Cost';
                    DecimalPlaces = 0 : 5;
                }
            }
            group("Prod. Order")
            {
                Caption = 'Prod. Order';
                field("Prod. Order Need (Qty.)"; Rec."Prod. Order Need (Qty.)")
                {
                    ApplicationArea = All;
                    Caption = 'Need (Qty.)';
                }
            }
        }
    }

    actions
    {
    }

    var
        MachineCenter2: Record "Machine Center";
        CapLedgEntry: Record "Capacity Ledger Entry";
        DateFilterCalc: Codeunit "DateFilter-Calc";
        WorkCtrDateFilter: array[4] of Text[30];
        WorkCtrDateName: array[4] of Text[30];
        i: Integer;
        CurrentDate: Date;
        WorkCtrCapacity: array[4] of Decimal;
        WorkCtrEffCapacity: array[4] of Decimal;
        WorkCtrExpEfficiency: array[4] of Decimal;
        WorkCtrExpCost: array[4] of Decimal;
        WorkCtrActNeed: array[4] of Decimal;
        WorkCtrActEfficiency: array[4] of Decimal;
        WorkCtrActCost: array[4] of Decimal;
        WorkCtrScrapQty: array[4] of Decimal;
        WorkCtrOutputQty: array[4] of Decimal;
        WorkCtrScrapPct: array[4] of Decimal;
        WorkCtrStopTime: array[4] of Decimal;
        WorkCtrRunTime: array[4] of Decimal;
        WorkCtrStopPct: array[4] of Decimal;
        Text000: Label 'Placeholder';

    local procedure CalcPercentage(PartAmount: Decimal; Base: Decimal): Decimal
    begin
        if Base <> 0 then
            exit(100 * PartAmount / Base);

        exit(0);
    end;
}

