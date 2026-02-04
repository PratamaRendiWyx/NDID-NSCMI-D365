page 50724 QualityMeasureResults_PQ
{
    // version QC10.1

    AutoSplitKey = true;
    Caption = 'Quality Measure Results';
    DataCaptionFields = "Quality Measure Code";
    PageType = List;
    SourceTable = QCQualityMeasureOptions_PQ;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code";Rec.Code)
                {
                    ToolTip = 'Quality Measure Code';
                    ApplicationArea = All;
                }
                field(Description;Rec.Description)
                {
                    ToolTip = 'Quality Measure Description';
                    ApplicationArea = All;
                }
                field("Non-Conformance";Rec."Non-Conformance")
                {
                    ToolTip = 'Indicates any non-conformance in this quality measure';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        /*
        if QCMeasureT.GET("Quality Measure Code") then
          if QCMeasureT."Result Type" <> QCMeasureT."Result Type"::List then
            ERROR(QCText000);
        */
    end;

    var
        QCMeasureT : Record QualityControlMeasures_PQ;
        QCText000 : Label 'The Quality Measure must be a Result Type of List.';
}

