page 50732 QualityPerStatus_PQ
{
    Caption = 'Quality Tests by Status';
    PageType = CardPart;
    //RefreshOnActivate = true;
    SourceTable = "Business Chart Buffer";
    //SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            usercontrol(BusinessChart; BusinessChart)
            {
                ApplicationArea = All;

                trigger DataPointClicked(point: JsonObject)
                begin
                    //SetDrillDownIndexes(point);
                    QualityPerStatusChartMgt.DrillDown(point, Rec);
                end;

                trigger AddInReady()
                begin
                    IsChartAddInReady := true;

                    if IsChartAddInReady then
                        InitializeSelectedChart;
                end;

                trigger Refresh()
                begin
                    if IsChartAddInReady and IsChartDataReady then
                        InitializeSelectedChart;
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        InitializeSelectedChart();
        IsChartDataReady := true;
    end;


    var
        QualityPerStatusChartMgt: Codeunit QualityStatusChartMgt_PQ;
        IsChartAddInReady: Boolean;
        IsChartDataReady: Boolean;

    local procedure InitializeSelectedChart()
    begin
        QualityPerStatusChartMgt.UpdateChart(Rec);
        UpdateChart;
    end;

    local procedure UpdateChart()
    begin
        Rec.UpdateChart(CurrPage.BusinessChart);
    end;
}

