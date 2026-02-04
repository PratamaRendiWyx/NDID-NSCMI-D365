page 50727 QualityTestOverview_PQ
{
    // version QC10.1

    // QC7.3
    //   - Added SETFILTER to OnOpenPage() to force the Display of the "Advanced Filter" pane
    //   - Added Test No., Item No. Customer No fields
    // 
    // QC80.4
    //   - Removed Filter Code in OnOpenPage that was interfering with pseudo "OnDrillDown" Code in QC Spec Lines Page "Last Test Date" Field

    Caption = 'Quailty Test Overview';
    DataCaptionFields = "Test No.","Item No.","Lot No./Serial No.";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = true;
    SourceTable = QualityTestLines_PQ;
    SourceTableView = SORTING("Test No.","Line No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Test No.";Rec."Test No.")
                {
                    ToolTip = 'Test No';
                    ApplicationArea = All;
                }
                field("Date Inspected";Rec."Date Inspected")
                {
                    ToolTip = 'Date Item Inspected';
                    ApplicationArea = All;
                }
                field("Time Inspected";Rec."Time Inspected")
                {
                    ToolTip = 'Time Item Inspected';
                    ApplicationArea = All;
                }
                field("Quality Measure";Rec."Quality Measure")
                {
                    ToolTip = 'Quality Measure';
                    ApplicationArea = All;
                }
                field("Measure Description";Rec."Measure Description")
                {
                    ToolTip = 'Measure Description';
                    ApplicationArea = All;
                }
                field(Method;Rec.Method)
                {
                    ToolTip = 'Quality Method';
                    ApplicationArea = All;
                }
                field("Method Description";Rec."Method Description")
                {
                    ToolTip = 'Quality Method Description';
                    ApplicationArea = All;
                }
                field(Conditions;Rec.Conditions)
                {
                    ToolTip = 'Conditions';
                    ApplicationArea = All;
                }
                field("Testing UOM";Rec."Testing UOM")
                {
                    ToolTip = 'Testing Unit Of Measure';
                    ApplicationArea = All;
                }
                field("UOM Description";Rec."UOM Description")
                {
                    ToolTip = '" Unit Of Measure Description"';
                    ApplicationArea = All;
                }
                field("Version Code";Rec."Version Code")
                {
                    ToolTip = 'Version Code';
                    ApplicationArea = All;
                }
                field("Item No.";Rec."Item No.")
                {
                    ToolTip = 'Item No for Quality Test';
                    ApplicationArea = All;
                }
                field("Customer No.";Rec."Customer No.")
                {
                    ToolTip = 'Customer Number for Quality Test';
                    ApplicationArea = All;
                }
                field("Lot No./Serial No.";Rec."Lot No./Serial No.")
                {
                    ToolTip = 'Lot/Serial number';
                    ApplicationArea = All;
                }
                field("Lower Limit";Rec."Lower Limit")
                {
                    ToolTip = 'Lower limit specification for test';
                    ApplicationArea = All;
                }
                field("Upper Limit";Rec."Upper Limit")
                {
                    ToolTip = 'Upper Limit specification for test';
                    ApplicationArea = All;
                }
                field("Nominal Value";Rec."Nominal Value")
                {
                    ToolTip = 'Nominal Value';
                    ApplicationArea = All;
                }
                field("Result Type";Rec."Result Type")
                {
                    ToolTip = 'Result Type';
                    ApplicationArea = All;
                }
                field("Actual Measure";Rec."Actual Measure")
                {
                    ToolTip = 'Actual Measure';
                    ApplicationArea = All;
                }
                field(Result;Rec.Result)
                {
                    ToolTip = 'Result';
                    ApplicationArea = All;
                }
                field("Non-Conformance";Rec."Non-Conformance")
                {
                    ToolTip = 'Indicates if there was non conformance in the test';
                    ApplicationArea = All;
                }
                field("Optional Display Prefix";Rec."Optional Display Prefix")
                {
                    ToolTip = 'Display Prefix';
                    ApplicationArea = All;
                }
                field("Test Line Complete";Rec."Test Line Complete")
                {
                    ToolTip = 'Indicates if test line is completed';
                    ApplicationArea = All;
                }
                field("Tested By";Rec."Tested By")
                {
                    ToolTip = 'Displays USERID of who performed the testing';
                    ApplicationArea = All;
                }
                field(Comment;Rec.Comment)
                {
                    ToolTip = '"Comments related to test "';
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
        //SETFILTER("Quality Measure",'<>''''');//QC7.3 - This merely forces the Display of the "Advanced Filter" pane, with that Field shown
        //SETRANGE("Quality Measure"); //QC7.3 - This merely forces the Display of the "Advanced Filter" pane, with that Field shown
    end;
}

