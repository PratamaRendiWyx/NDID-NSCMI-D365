page 50712 QCLotTestLines_PQ
{
    // version QC10.1

    // //QC4.30  Added the field Result type and Result List(Result)
    //           Code behind Result - OnBeforeInput & OnLookup
    //           Added two Global variables
    //           Added code OnBeforeInput on the Actual Measure field
    // //QC6  Moved code for editablity to OnFormat trigger
    //        Removed code on Comment Trigger to use standard flowfield lookups
    //
    // //QC7.2 08/18/13 Doug McIntosh, Cost Control Software
    //   - Added Non-Conformance Warning
    //   - Changed Style of certain fields to "Unfavorable" if Non-Conformance = TRUE
    //   - "Promoted" Comments to Subform "Ribbon"
    //
    // //QC71.1 11/27/13 Doug McIntosh, Cost Control Software
    //   - Added "Display" field
    //   - Added New Fields "Last Test Date", "Outside Testing", "Importance"
    //   - Added Global "UserIsQCMgr", and call to QualityFunctions.TestQCMgr to control Editing of almost all Fields, and Insertion/Deletion of Test Lines
    //
    // QC80.1 03/06/15 Doug McIntosh
    //   - "Refined" some Field-Styling that was added by QC7.2 (see above comments), to make "Actual Measure" and "Result" Fields be either "Strong" or "Unfavorable"
    //     - Added Global "LineStyle"
    //     - Added Text Constants "PassColor" and "Fail Color"
    //     - Added Code to OnAfterGetRecord trigger
    //   - Changes to allow "Test Line Complete" to be Editable by NON QC Mgrs. amd to allow Zero to be a valid "Actual Measure"
    //     - Changed "Editable" Property of "Test Line Complete" from "IsQCMgr" to "<Yes>"
    //     - Removed the "Blank Zero" Property from "Actual Measure" field
    //   - Changed Code in "CheckActualMeasure" Function to Set "Test Line Complete" to TRUE
    //
    // QC80.4  06/23/15  Doug McIntosh
    //   - Moved "test Line Complete", "Actual Measure" and "Result" further forward (Left) in Line
    //   - Moved "Custom Test" and "Outside Test" Further Back (Right) in Line
    //   - Removed "Frequency Code" Field
    //
    //QC13.0 11/26/18 Doug McIntosh
    // - Remove Quotes around Page Caption

    AutoSplitKey = true;
    Caption = 'Quality Lot Test Lines';
    PageType = ListPart;
    SourceTable = QualityTestLines_PQ;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Test Line Complete"; Rec."Test Line Complete")
                {
                    ToolTip = 'Indicates Test Line is complete. Uncheck to edit line';
                    ApplicationArea = All;
                }
                field("Quality Measure"; Rec."Quality Measure")
                {
                    Editable = LineEditEnable;
                    Style = Unfavorable;
                    StyleExpr = AlertColor;
                    ToolTip = 'Select Quality Measure';
                    ApplicationArea = All;
                }
                field("Measure Description"; Rec."Measure Description")
                {
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = AlertColor;
                    ApplicationArea = All;
                }
                field(Method; Rec.Method)
                {
                    Editable = LineEditEnable;
                    ToolTip = 'Enter testing Method';
                    ApplicationArea = All;
                }
                field("Method Description"; Rec."Method Description")
                {
                    Editable = LineEditEnable;
                    ApplicationArea = All;
                }
                field(Conditions; Rec.Conditions)
                {
                    Editable = LineEditEnable;
                    ToolTip = 'Enter Testing Conditions';
                    ApplicationArea = All;
                }
                field("Result Type"; Rec."Result Type")
                {
                    Editable = true; //LineEditEnable;
                    ToolTip = 'Result Type';
                    ApplicationArea = All;
                }
                field(Result; Rec.Result)
                {
                    Caption = 'Result List';
                    Editable = ResultEditable;
                    StyleExpr = LineStyle;
                    ToolTip = 'If a list type, press F4 for lookup';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        //QC4.30
                        Results.RESET;
                        Results.SETRANGE(Results."Quality Measure Code", Rec."Quality Measure");
                        /*
                        if Result <> '' then begin
                            Results.SETRANGE(Results.Code, FORMAT(Result));
                            Results.FIND('-');
                            Results.SETRANGE(Results.Code);
                        end;
                        */
                        CLEAR(ResultPage);
                        ResultPage.LOOKUPMODE(true);
                        ResultPage.SETTABLEVIEW(Results);
                        ResultPage.SETRECORD(Results);
                        if ResultPage.RUNMODAL = ACTION::LookupOK then begin
                            ResultPage.GETRECORD(Results);
                            Rec.VALIDATE(Result, Results.Code);
                            CheckActualMeasure;//QC7.2
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if Rec.Result <> xRec.Result then begin
                            Rec.VALIDATE(Result);
                            CheckActualMeasure;//QC7.2
                        end;
                    end;
                }
                field("Actual Measure"; Rec."Actual Measure")
                {
                    Editable = "Actual MeasureEditable";
                    StyleExpr = LineStyle;
                    ToolTip = 'Enter the Actual Test Results here';
                    ApplicationArea = All;

                    trigger OnValidate();
                    var
                        QCTestLines: Record QualityTestLines_PQ;
                    begin
                        if Rec."Actual Measure" <> 0 then begin
                            CheckActualMeasure;//QC7.2

                            QCTestLines.SetRange("Test No.", Rec."Test No.");
                            if QCTestLines.FindSet() then begin
                                repeat
                                    QCTestLines."Test Status" := QCTestLines."Test Status"::"In-Process";
                                    QCTestLines.Modify(false);
                                until QCTestLines.Next() = 0;
                            end;
                            // QCTestHeader.Modify(false);
                        end;
                    end;
                }
                field("Lower Limit"; Rec."Lower Limit")
                {
                    Editable = LineEditEnable;
                    ToolTip = 'Shows the Lower Limit';
                    ApplicationArea = All;
                }
                field("Upper Limit"; Rec."Upper Limit")
                {
                    Editable = LineEditEnable;
                    ToolTip = 'Shows the Upper Test Limit';
                    ApplicationArea = All;
                }
                field("Nominal Value"; Rec."Nominal Value")
                {
                    Visible = false;
                    Editable = LineEditEnable;
                    ToolTip = 'Shows the Nominal/Normal Value';
                    ApplicationArea = All;
                }
                field("Sampling to"; Rec."Sampling to")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Display Report Seq."; Rec."Display Report Seq.")
                {
                    ApplicationArea = All;
                    Editable = LineEditEnable;
                }
                field("Testing UOM"; Rec."Testing UOM")
                {
                    Editable = LineEditEnable;
                    ToolTip = 'UofM';
                    ApplicationArea = All;
                }
                field("Non-Conformance"; Rec."Non-Conformance")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                    ToolTip = 'If this line does not conform to standard, you will see a warning';
                    ApplicationArea = All;
                }
                field("Optional Display Prefix"; Rec."Optional Display Prefix")
                {
                    ToolTip = 'If QC only needs to be greater (>) the Lower limit and you prefer to print > the lower limit value instead of the actual value.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Optional Display Value"; Rec."Optional Display Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("QC By"; Rec."QC By")
                {
                    ApplicationArea = All;
                    Editable = true;//LineEditEnable;
                }
                field("QC Name"; Rec."QC Name")
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Reason Code';
                    ApplicationArea = All;
                    Editable = true;//LineEditEnable;
                }
                field("Reason Desc."; Rec."Reason Desc.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Custom Test"; Rec."Custom Test")
                {
                    Editable = false;
                    ToolTip = 'Custom Test';
                    ApplicationArea = All;
                }
                field("Outside Testing"; Rec."Outside Testing")
                {
                    Editable = LineEditEnable;
                    ToolTip = 'Yes, if testing is to be done by a sub-contractor';
                    ApplicationArea = All;
                }
                field("Date Inspected"; Rec."Date Inspected")
                {
                    Editable = true;//UserIsQCMgr;
                    ToolTip = 'Date Tested';
                    ApplicationArea = All;
                }
                field("Time Inspected"; Rec."Time Inspected")
                {
                    Editable = true;//UserIsQCMgr Or LineEditEnable;
                    ToolTip = 'Time Tested';
                    ApplicationArea = All;
                }
                field("Ignore for Update"; Rec."Ignore for Update")
                {
                    Visible = False;
                    ApplicationArea = All;
                    Editable = LineEditEnable;
                }
                field("Frequency Code"; Rec."Frequency Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                    Editable = LineEditEnable;
                }
                field("Last Test Date"; Rec."Last Test Date")
                {
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Last Date this was tested';
                    ApplicationArea = All;
                }
                field("Next Test Date"; Rec."Next Test Date")
                {
                    Editable = UserIsQCMgr;
                    ToolTip = 'Next date to be tested';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Test Status"; Rec."Test Status")
                {
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Test Status';
                    ApplicationArea = All;
                }
                field(Display; Rec.Display)
                {
                    Editable = LineEditEnable;
                    ApplicationArea = All;
                }
                field("Tested By"; Rec."Tested By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    Editable = false;
                    ToolTip = 'Comments are automatic';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Edit Line")
            {
                Caption = 'Edit Line';
                Image = Edit;
                ToolTip = 'Click to edit line';
                ApplicationArea = All;

                trigger OnAction();
                begin
                    //NP1 Added
                    if UserIsQCMgr then begin
                        LineEditEnable := true;
                        OldLine := Rec."Line No."; //Remember Line No. HERE, to keep "Page Refresh" from CANCELLING "Edit Mode"
                    end else begin
                        LineEditEnable := false;
                        MESSAGE(Text001); //Tell User that they Can't Edit the Line;
                    end;
                end;
            }
            action("Co&mments")
            {
                Caption = 'Co&mments';
                Image = ViewComments;
                ToolTip = 'Click for Line Comments';
                ApplicationArea = All;

                trigger OnAction();
                begin
                    //This functionality was copied from page #14004601. Unsupported part was commented. Please check it.
                    //CurrPage.QCLine.PAGE.
                    _ShowComment;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        //QC71.1 Start
        /*if Rec."Line No." = OldLine then
            LineEditEnable := true
        else begin
            LineEditEnable := false; //Edit one line at a time
            OldLine := -1; //Cancel "Edit Mode" for SURE
        end;
        */
        if UserIsQCMgr then
            LineEditEnable := true;
        //QC71.1 Finish
    end;

    trigger OnAfterGetRecord();
    begin
        UserIsQCMgr := QualityFunctions.TestQCMgr; //QC71.1
        LineEditEnable := UserIsQCMgr;//false; //QC71.1 - This is controlled by the "Edit Line" Action on this Subform
        ActualMeasureOnFormat;
        ResultOnFormat;
        AlertColor := Rec.AlertOnFormat;
        //QC80.1 Start
        if AlertColor then
            LineStyle := FailColor
        else
            LineStyle := PassColor;
        //QC80.1 Finish
    end;

    trigger OnInit();
    begin
        ResultEditable := true;
        "Actual MeasureEditable" := true;
        LineEditEnable := false; //QC71.1
        OldLine := -1; //Make Sure Line Edit Mode is NOT "Active"
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        ForceLineEdit(true); //QC71.1
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        ForceLineEdit(true); //QC71.1
    end;

    var
        Results: Record QCQualityMeasureOptions_PQ;
        ResultPage: Page QualityMeasureResults_PQ;
        [InDataSet]
        "Actual MeasureEditable": Boolean;
        [InDataSet]
        ResultEditable: Boolean;
        [InDataSet]
        AlertColor: Boolean;
        [InDataSet]
        UserIsQCMgr: Boolean;
        QualityFunctions: Codeunit QCFunctionLibrary_PQ;
        [InDataSet]
        LineEditEnable: Boolean;
        Text001: Label 'You must be a Quality Manager to Add, Delete, or Edit Certain Test Fields.';
        OldLine: Integer;
        LineStyle: Text;
        PassColor: Label 'Strong';
        FailColor: Label 'Unfavorable';
        QCText000: Label 'The %2 of ''''%1'''' for this Test is in Non-Conformance.\\';
        QCText001: Label 'Do you wish to continue?';

    procedure _ShowComment();
    var
        QualSpecComment: Record QCTestLineComment_PQ;
    begin
        QualSpecComment.SETRANGE("Test No.", Rec."Test No.");
        QualSpecComment.SETRANGE("Test Line", Rec."Line No.");
        PAGE.RUN(PAGE::QCTestLineComments_PQ, QualSpecComment);
    end;

    local procedure ActualMeasureOnFormat();
    begin
        if Rec."Result Type" = Rec."Result Type"::List then
            "Actual MeasureEditable" := false
        else
            "Actual MeasureEditable" := true;
    end;

    local procedure ResultOnFormat();
    begin
        if Rec."Result Type" = Rec."Result Type"::List then
            ResultEditable := true
        else
            ResultEditable := false;
    end;

    procedure CheckActualMeasure();
    var
        ResultText: Text;
        TypeText: Text;
        IsUpdateComplete: Boolean;
    begin
        // CurrPage.GetRecord(Rec);
        IsUpdateComplete := true;
        CurrPage.UPDATE(true);
        AlertColor := Rec.AlertOnFormat;
        if Rec."Non-Conformance" then begin
            if Rec."Result Type" = Rec."Result Type"::Numeric then begin
                ResultText := FORMAT(Rec."Actual Measure");
                TypeText := Rec.FIELDCAPTION("Actual Measure");
            end else begin
                ResultText := Rec.Result;
                TypeText := Rec.FIELDCAPTION(Result);
            end;
            if not CONFIRM(QCText000 +
                           QCText001, false, ResultText, TypeText) then begin
                Rec."Non-Conformance" := xRec."Non-Conformance";
                Rec."Actual Measure" := xRec."Actual Measure"; //Revert this Entry
                Rec.Result := xRec.Result;
                IsUpdateComplete := false;
            end;
        end;
        if IsUpdateComplete then
            Rec."Test Line Complete" := true; //QC80.1 Line Added
        CurrPage.UPDATE(true);
    end;

    procedure ForceLineEdit(iCondtion: Boolean)
    var
        QCSetup: Record QCSetup_PQ;
    begin
        if UserIsQCMgr then begin
            Rec."Custom Test" := true; //If a "New"/"Inserted" Line, then it MUST be a "Custom" Test, added by a QC Mgr
            if QCSetup.GET then
                Rec."Ignore for Update" := QCSetup."Default Value for Ignore"; //Get the Default for this from QC Setup
            OldLine := Rec."Line No.";
            LineEditEnable := iCondtion;
        end;
    end;
}
