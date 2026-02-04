page 50704 QCSpecificationLines_PQ
{

    AutoSplitKey = true;
    Caption = 'Lines';
    DataCaptionFields = "Item No.";
    //MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = QCSpecificationLine_PQ;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Quality Measure"; Rec."Quality Measure")
                {
                    ApplicationArea = All;
                }
                field("Measure Description"; Rec."Measure Description")
                {
                    ApplicationArea = All;
                }
                field(Method; Rec.Method)
                {
                    ApplicationArea = All;
                }
                field("Method Description"; Rec."Method Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Conditions; Rec.Conditions)
                {
                    ApplicationArea = All;
                }
                field("Testing UOM"; Rec."Testing UOM")
                {
                    ApplicationArea = All;
                }
                field("UOM Description"; Rec."UOM Description")
                {
                    ApplicationArea = All;
                    //Visible = false;
                    Editable = false;
                }
                field("Result Type"; Rec."Result Type")
                {
                    Editable = false;
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
                    ApplicationArea = All;
                    Visible = False;
                }
                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = All;
                }
                field("Outside Testing"; Rec."Outside Testing")
                {
                    ApplicationArea = All;
                }
                field("Check Sum. (?)"; Rec."Check Sum. (?)")
                {
                    ApplicationArea = All;
                    Enabled = MeasureEditable;
                }
                field(Standart; Rec.Standart)
                {
                    ApplicationArea = All;
                }
                field("Sampling to"; Rec."Sampling to")
                {
                    ApplicationArea = All;
                }
                field("Display Report Seq."; Rec."Display Report Seq.")
                {
                    ApplicationArea = All;
                }
                field(IsInteger; Rec.IsInteger)
                {
                    Caption = 'Is Integer';
                    ApplicationArea = All;
                    Enabled = MeasureEditable;
                }
                field(Display; Rec.Display)
                {
                    ToolTip = 'This indicator filters which lines show on the QC Test form.';
                    ApplicationArea = All;
                }
                field("Last Test Date"; Rec."Last Test Date")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    var
                        TestLines: Record QualityTestLines_PQ;
                        QCOverviewPage: Page QualityTestOverview_PQ;
                    begin
                        if Rec."Last Test Date" > 0D then begin
                            CLEAR(QCOverviewPage);
                            TestLines.INIT;
                            TestLines.SETRANGE("Item No.", Rec."Item No.");
                            TestLines.SETRANGE("Customer No.", Rec."Customer No.");
                            TestLines.SETRANGE("Quality Measure", Rec."Quality Measure");
                            QCOverviewPage.SETTABLEVIEW(TestLines);
                            QCOverviewPage.RUN;
                        end;
                    end;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CommentOnPush;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Co&mments")
            {
                Caption = 'Co&mments';
                Image = ViewComments;
                ToolTip = 'Edit Comments';
                ApplicationArea = All;

                trigger OnAction();
                begin
                    //This functionality was copied from page #14004593. Unsupported part was commented. Please check it.
                    //CurrPage.QCLine.PAGE.
                    _ShowComment;
                    Rec.CALCFIELDS(Comment);
                    CurrPage.UPDATE(true);
                end;
            }
        }
    }

    trigger OnInit()
    var
        myInt: Integer;
    begin
        MeasureEditable := true;
    end;

    trigger OnAfterGetCurrRecord();
    begin
        UserIsQCMgr := QualityFunctions.TestQCMgr; //QC71.1
        MeasureEditableFormat();
    end;

    local procedure MeasureEditableFormat();
    begin
        if Rec."Result Type" = Rec."Result Type"::List then
            MeasureEditable := false
        else
            MeasureEditable := true;
    end;



    var
        "--NP1--": Integer;
        [InDataSet]
        UserIsQCMgr: Boolean;
        QualityFunctions: Codeunit QCFunctionLibrary_PQ;
        "MeasureEditable": Boolean;

    procedure _ShowComment();
    var
        QualSpecComment: Record QCLinesCommentLine_PQ;
    begin
        QualSpecComment.SETRANGE("Table Name", QualSpecComment."Table Name"::"QC Lines");
        QualSpecComment.SETRANGE("Item No.", Rec."Item No.");
        QualSpecComment.SETRANGE("Customer No.", Rec."Customer No.");
        QualSpecComment.SETRANGE(Type, Rec.Type);
        QualSpecComment.SETRANGE("Version Code", Rec."Version Code");
        QualSpecComment.SETRANGE("QC Line No.", Rec."Line No.");
        PAGE.RUNMODAL(PAGE::QualityControlComments_PQ, QualSpecComment);
    end;

    procedure ShowComment();
    var
        QualSpecComment: Record QCLinesCommentLine_PQ;
    begin
        QualSpecComment.SETRANGE("Table Name", QualSpecComment."Table Name"::"QC Lines");
        QualSpecComment.SETRANGE("Item No.", Rec."Item No.");
        QualSpecComment.SETRANGE("Customer No.", Rec."Customer No.");
        QualSpecComment.SETRANGE(Type, Rec.Type);
        QualSpecComment.SETRANGE("Version Code", Rec."Version Code");
        QualSpecComment.SETRANGE("QC Line No.", Rec."Line No.");
        PAGE.RUNMODAL(PAGE::QualityControlComments_PQ, QualSpecComment);
    end;

    local procedure CommentOnPush();
    begin
        ShowComment;
    end;
}
