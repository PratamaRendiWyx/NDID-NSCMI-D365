page 50726 QualityComplianceView_PQ
{
    // version QC13.01

    // QC7.7
    //   - Added "Style" To Actual Measure and Result Fields to make Red on Non-Conformance


    Caption = 'Quality Compliance View';
    Editable = false;
    PageType = List;
    SourceTable = QCTempComplianceView_PQ;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Version Code"; Rec."Version Code")
                {
                    ApplicationArea = All;
                }
                field("Quality Measure"; Rec."Quality Measure")
                {
                    ApplicationArea = All;
                }
                field("Result Type"; Rec."Result Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Method; Rec.Method)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Non Compliance"; Rec."Non Compliance")
                {
                    ApplicationArea = All;
                }
                field("Lower Limit"; Rec."Lower Limit")
                {
                    ApplicationArea = All;
                }
                field("Upper Limit"; Rec."Upper Limit")
                {
                    ApplicationArea = All;
                }
                field("Nominal Value"; Rec."Nominal Value")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Actual Value"; Rec."Actual Value")
                {
                    Style = Unfavorable;
                    StyleExpr = MeasureFail;
                    ApplicationArea = All;
                }
                field(Result; Rec.Result)
                {
                    Style = Unfavorable;
                    StyleExpr = MeasureFail;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        MeasureFail := Rec."Non Compliance"; //QC7.7
    end;


    var
        [InDataSet]
        MeasureFail: Boolean;
}

