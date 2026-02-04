codeunit 50706 QualityStatusChartMgt_PQ
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        StatusCaptionTxt: Label 'Status';
        TotalTestsCaptionTxt: Label 'Total Tests';

    procedure UpdateChart(var BusChartBuf: Record "Business Chart Buffer")
    var
        GLSetup: Record "General Ledger Setup";
        ColumnIndex: Integer;
        InnerIndex: Integer;
        StatusName: array[9] of Text[100];
        TotalTests: array[9] of Decimal;
    begin

        BusChartBuf.Initialize;
        if GLSetup.Get then;
        BusChartBuf.AddMeasure(TotalTestsCaptionTxt, 1, BusChartBuf."Data Type"::Decimal, BusChartBuf."Chart Type"::Doughnut);
        BusChartBuf.SetXAxis(StatusCaptionTxt, BusChartBuf."Data Type"::String);
        CalcTotalQualityTests(StatusName, TotalTests);
        for ColumnIndex := 1 to 8 do begin
            //if SalesLCY[ColumnIndex] = 0 then
            //    exit;
            if TotalTests[ColumnIndex] <> 0 then begin
                InnerIndex += 1;
                BusChartBuf.AddColumn(StatusName[ColumnIndex]);
                BusChartBuf.SetValueByIndex(0, InnerIndex - 1, TotalTests[ColumnIndex]);
            end;
        end;
    end;

    procedure DrillDown(var Point: JsonObject; var BusChartBuf: Record "Business Chart Buffer")
    var
        StatusName: Variant;
        Measures: Text;
        XValueString: Text;
        JsonTokenMeasures: JsonToken;
        JsonTokenXValueString: JsonToken;
    begin
        clear(JsonTokenMeasures);
        clear(JsonTokenXValueString);
        if Point.Get('YValues', JsonTokenMeasures) then begin
            Measures := Format(JsonTokenMeasures);
            Measures := DelChr(Measures, '=', '["]');
        end;
        if Point.Get('XValueString', JsonTokenXValueString) then begin
            XValueString := format(JsonTokenXValueString);
            XValueString := DelChr(XValueString, '=', '"');
        end;

        BusChartBuf.GetXValue(BusChartBuf."Drill-Down X Index", StatusName);

        case XValueString of
            'New':
                DrillDownTest(0);
            'Ready for Testing':
                DrillDownTest(1);
            'In-Process':
                DrillDownTest(2);
            'Ready for Review':
                DrillDownTest(3);
            'Certified':
                DrillDownTest(4);
            'Certified with Waiver':
                DrillDownTest(5);
            'Certified Final':
                DrillDownTest(6);
            'Rejected':
                DrillDownTest(7);
            'Closed':
                DrillDownTest(8);
        end;
    end;

    local procedure CalcTotalQualityTests(var StatusName: array[9] of Text[100]; var TotalTests: array[9] of Decimal)
    var
        QualityTests: Record QualityTestHeader_PQ;
        TopCustomersBySalesJob: Codeunit "Top Customers By Sales Job";
        ChartManagement: Codeunit "Chart Management";
        ColumnIndex: Integer;
        OtherCustomersSalesLCY: Decimal;
    begin
        //if TopCustomersBySalesBuffer.IsEmpty then
        //    TopCustomersBySalesJob.UpdateCustomerTopList;

        if QualityTests.FindSet then begin
            StatusName[1] := format(QualityTests."Test Status"::New);
            StatusName[2] := format(QualityTests."Test Status"::"Ready for Testing");
            StatusName[3] := format(QualityTests."Test Status"::"In-Process");
            StatusName[4] := format(QualityTests."Test Status"::"Ready for Review");
            StatusName[5] := format(QualityTests."Test Status"::Certified);
            // StatusName[6] := format(QualityTests."Test Status"::"Certified Final");
            StatusName[6] := format(QualityTests."Test Status"::Rejected);
            StatusName[7] := format(QualityTests."Test Status"::Closed);

            repeat
                case QualityTests."Test Status" of
                    QualityTests."Test Status"::New:
                        TotalTests[1] += 1;
                    QualityTests."Test Status"::"Ready for Testing":
                        TotalTests[2] += 1;
                    QualityTests."Test Status"::"In-Process":
                        TotalTests[3] += 1;
                    QualityTests."Test Status"::"Ready for Review":
                        TotalTests[4] += 1;
                    QualityTests."Test Status"::Certified:
                        TotalTests[5] += 1;
                    // QualityTests."Test Status"::"Certified Final":
                    //     TotalTests[6] += 1;
                    QualityTests."Test Status"::Rejected:
                        TotalTests[6] += 1;
                    QualityTests."Test Status"::Closed:
                        TotalTests[7] += 1;
                end;
            until QualityTests.Next = 0;

            //ChartManagement.ScheduleTopCustomerListRefreshTask
        end;
    end;

    local procedure DrillDownTest(StatusFilter: Integer)
    var
        QualityTests: Record QualityTestHeader_PQ;
    begin
        QualityTests.SetRange("Test Status", StatusFilter);
        if QualityTests.FindSet then;
        PAGE.Run(PAGE::QCTestList_PQ, QualityTests);
    end;

    local procedure GetFilterToExcludeTopFiveCustomers(): Text
    var
        TopCustomersBySalesBuffer: Record "Top Customers By Sales Buffer";
        CustomerCounter: Integer;
        FilterToExcludeTopFiveCustomers: Text;
    begin
        CustomerCounter := 1;
        if TopCustomersBySalesBuffer.FindSet then
            repeat
                if CustomerCounter = 1 then
                    FilterToExcludeTopFiveCustomers := StrSubstNo('<>%1', TopCustomersBySalesBuffer.CustomerNo)
                else
                    FilterToExcludeTopFiveCustomers += StrSubstNo('&<>%1', TopCustomersBySalesBuffer.CustomerNo);
                CustomerCounter += 1;
            until (TopCustomersBySalesBuffer.Next = 0) or (CustomerCounter = 6);
        exit(FilterToExcludeTopFiveCustomers);
    end;
}

