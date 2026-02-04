table 50707 QualityTestLines_PQ
{
    // version QC80.4

    // //QC37.05  Changed the field Lot No. to "Lot No./Serial No."
    //            Removed the word Lot out of the table name.
    // //QC3.7b  QC37.05b     Changed the Upper, Lower, Nominal and Actual values
    //                        to a decimal setting of 2:5
    // //QC4SP1.2 Added Customer No. to the testing lines.
    // //QC4.30   Added fields Result and Result Type
    // //QC6      Added code onValidate of Result field to error if code entered
    //              does not exist in Results table
    // 
    // //QC7.2 
    //   - Added Fields "Conditions", "UOM Description"
    // 
    // //QC7.3
    //   - Added Fields "Reason Code", "Reason Desc."
    //   - Changed "Actual Value" Field to 2:5 Decimal Places
    // 
    // //QC7.4
    //   - Updated "Test Status" to handle "New" Status Options
    //     - Options Were:
    //       - New,In-Process,Certified,Rejected,Closed
    //     - Options Are Now:
    //       - New,Ready for Testing,In-Process,Ready for Review,Certified,Certified with Waiver,Certified Final,,,,,,,Rejected,Closed
    //     - Increased all "User Name" fields to 50 length
    // 
    // //QC71.1 
    //   - Added New Fields "Last Test Date", "Outside Testing", "Importance" (all Copied from Spec Lines)
    //   - Added Global "QualityFunctions"
    //   - Added Logic to control Insert and Delete of Lines if NOT a "Quality Manager"
    //   - Added "Custom Test" Line to help with "Date Update" of Spec Master ("Custom Tests" will be Filtered OUT). TRUE when QC Mgr creates an ad-hoc Test Line
    //   - Added Logic to Bring In "Result Type" from OnValidate of "Quality Measure"
    //   - Added Logic to choose whether Test Line Comments would be "Auto-Created" on certain Field Value Changes
    // 
    // QC7.6 
    //   - Added Options '>=' and '<=' to the "Optional Display Prefix" Field, and adjusted the "TestOptionalDisplay" Func. accordingly
    // 
    // QC71.3
    //   - Renumbered Fields 50k to 60k down to the 100-? Range
    // 
    // QC80.1
    //   - Changes to Allow "Test Line Complete" to permit an "Actual Measure" of Zero for a "Completed" Test Line
    //     - Code Changes on OnValidate Triggers of "Lower Limit", "Upper Limit", "Actual Measure" and "Test Line Complete"
    // 
    // QC80.4
    //   - Changed CAPTION of "Date Imspected" Field to "Date Tested"
    //   - Changed CAPTION of "Time Inspected" Field to "Time Tested"
    //   - Added Code to Place USERID in BOTH the "Tested By" and "Entered By" Fields

    Caption = 'Quality Test Lines';

    fields
    {
        field(1; "Test No."; Code[20])
        {
            Description = 'Key';
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Item No."; Code[20])
        {
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(4; "Lot No./Serial No."; Code[101])
        {
            TableRelation = "Lot No. Information"."Lot No." WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;
        }
        field(5; "Test Date"; Date)
        {
            Enabled = false;
            DataClassification = CustomerContent;
        }
        field(6; "Test Time"; Time)
        {
            Enabled = false;
            DataClassification = CustomerContent;
        }
        field(7; "Test Qty"; Decimal)
        {
            Description = 'QC7.2 Name Changed from Qty Inspected';
            DataClassification = CustomerContent;
        }
        field(8; "Unit of Measure"; Code[10])
        {
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;
        }
        field(9; "Tested By"; Code[50])
        {
            Description = 'User ID';
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(10; "Entered By"; Code[50])
        {
            Description = 'User ID Auto Stamp';
            Editable = false;
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(11; "Test Status"; Option)
        {
            Editable = false;
            OptionCaption = 'New,Ready for Testing,In-Process,Ready for Review,Certified,Certified with Waiver,Certified Final,,,,,,,Rejected,Closed';
            OptionMembers = New,"Ready for Testing","In-Process","Ready for Review",Certified,"Certified with Waiver","Certified Final",,,,,,,Rejected,Closed;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(12; "Quality Measure"; Code[20])
        {
            Description = 'Table Rel';
            TableRelation = QualityControlMeasures_PQ;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
                QCMeasuresT.GET("Quality Measure");
                "Measure Description" := QCMeasuresT.Description;
                "Result Type" := QCMeasuresT."Result Type"; //QC71.1
            end;
        }
        field(13; "Measure Description"; Text[30])
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(14; "Lower Limit"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                LineNo: Integer;
                TestLineCommentsT: Record QCTestLineComment_PQ;
            begin
                TestStatus;

                //QC71.1 Start
                QCSetup.GET;

                if ((xRec."Lower Limit" <> "Lower Limit") and (QCSetup."Auto Test Line Comments")) then begin   //changing the limits comment creation if enabled
                                                                                                                //QC71.1 Finish

                    TestLineCommentsT.SETRANGE("Test No.", "Test No.");
                    TestLineCommentsT.SETRANGE("Test Line", "Line No.");
                    if TestLineCommentsT.FIND('+') then
                        LineNo := TestLineCommentsT."Line No." + 10000
                    else
                        LineNo := 10000;
                    TestLineCommentsT.INIT;
                    TestLineCommentsT."Test No." := "Test No.";
                    TestLineCommentsT."Test Line" := "Line No.";
                    TestLineCommentsT."Line No." := LineNo;
                    TestLineCommentsT.Date := WORKDATE;
                    TestLineCommentsT."Entered By" := USERID;
                    TestLineCommentsT.Comment := 'Lower Limit was changed from ' +
                                                  FORMAT(xRec."Lower Limit") + ' to ' +
                                                  FORMAT("Lower Limit");
                    TestLineCommentsT.INSERT;
                end;

                //IF "Actual Measure" <> 0 THEN //QC80.1 - REM-OUT To allow Zero as an Actual Measure
                VALIDATE("Actual Measure");
            end;
        }
        field(15; "Upper Limit"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                LineNo: Integer;
                TestLineCommentsT: Record QCTestLineComment_PQ;
            begin
                TestStatus;

                //QC71.1 Start
                QCSetup.GET;

                if ((xRec."Upper Limit" <> "Upper Limit") and (QCSetup."Auto Test Line Comments")) then begin   //changing the limits comment creation if enabled
                                                                                                                //QC71.1 Finish

                    TestLineCommentsT.SETRANGE("Test No.", "Test No.");
                    TestLineCommentsT.SETRANGE("Test Line", "Line No.");
                    if TestLineCommentsT.FIND('+') then
                        LineNo := TestLineCommentsT."Line No." + 10000
                    else
                        LineNo := 10000;
                    TestLineCommentsT.INIT;
                    TestLineCommentsT."Test No." := "Test No.";
                    TestLineCommentsT."Test Line" := "Line No.";
                    TestLineCommentsT."Line No." := LineNo;
                    TestLineCommentsT.Date := WORKDATE;
                    TestLineCommentsT."Entered By" := USERID;
                    TestLineCommentsT.Comment := 'Upper Limit was changed from ' +
                                                  FORMAT(xRec."Upper Limit") + ' to ' +
                                                  FORMAT("Upper Limit");
                    TestLineCommentsT.INSERT;
                end;

                //IF "Actual Measure" <> 0 THEN //QC80.1 - REM-OUT To allow Zero as an Actual Measure
                VALIDATE("Actual Measure");
            end;
        }
        field(16; "Nominal Value"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(17; "Testing UOM"; Code[10])
        {
            Caption = 'Testing Unit of Measure';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(18; "Display"; Boolean)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(19; "Method"; Code[20])
        {
            Description = 'Table Rel';
            TableRelation = QualityControlMethods_PQ;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
                QCMethodsT.GET(Method);
                "Method Description" := QCMethodsT.Description;
            end;
        }
        field(20; "Method Description"; Text[30])
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(21; "Customer No."; Code[20])
        {
            Description = 'QC4SP1.2';
            DataClassification = CustomerContent;
        }
        field(22; "Comment"; Boolean)
        {
            CalcFormula = Exist(QCTestLineComment_PQ WHERE("Test No." = FIELD("Test No."),
                                                                  "Test Line" = FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Actual Measure"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                LineNo: Integer;
            begin
                TestStatus;
                if "Date Inspected" = 0D then
                    "Date Inspected" := WORKDATE;
                if "Time Inspected" = 0T then
                    "Time Inspected" := TIME;
                "Entered By" := USERID;
                "Tested By" := USERID; //QC80.4

                QCTestHeaderT.GET("Test No.");
                QCTestHeaderT."Test Status" := QCTestHeaderT."Test Status"::"In-Process"; //QC7.4 Changed from Numeric value of 1
                if QCTestHeaderT."Tested By" = '' then
                    QCTestHeaderT."Tested By" := "Tested By";
                QCTestHeaderT.MODIFY;
                QCTestHeaderT.UpdateProdRoutingLineStatus(2);
                //QCTestForm.update;

                "Non-Conformance" := false;

                //QC80.1 Start - Allow "Actual Measure" (and "Lower Limit" and/or "Upper Limit") to be Zero
                //NOTE: The idea here is that if the Actual Measure is Zero, then "Test Line Complete" will be also acceptable...
                //...and this Function will be called also from the OnValidate of "Test Line Complete"

                if (("Actual Measure" <> 0) or ("Test Line Complete" = true)) then begin
                    //IF "Lower Limit" <> 0 THEN
                    if "Actual Measure" < "Lower Limit" then
                        "Non-Conformance" := true;

                    //IF "Upper Limit" <> 0 THEN
                    if "Actual Measure" > "Upper Limit" then
                        "Non-Conformance" := true;


                    //QC80.1 Finish

                    //QC71.1 Start;

                    QCSetup.GET;

                    if ((xRec."Actual Measure" <> "Actual Measure") and (QCSetup."Auto Test Line Comments")) then begin   //changing actual measurement comment creation if enabled
                        TestLineComments.SETRANGE("Test No.", "Test No.");
                        TestLineComments.SETRANGE("Test Line", "Line No.");
                        if TestLineComments.FIND('+') then
                            LineNo := TestLineComments."Line No." + 10000
                        else
                            LineNo := 10000;

                        TestLineComments.INIT;
                        TestLineComments."Test No." := "Test No.";
                        TestLineComments."Test Line" := "Line No.";
                        TestLineComments."Line No." := LineNo;
                        TestLineComments.Date := WORKDATE;
                        TestLineComments."Entered By" := USERID;
                        TestLineComments.Comment := 'Actual Measurement was changed from ' +
                                                     FORMAT(xRec."Actual Measure") + ' to ' +
                                                     FORMAT("Actual Measure");
                        TestLineComments.INSERT;

                    end;

                end else begin
                    //QC71.1 Start
                    if (((xRec."Actual Measure" <> 0) or (xRec."Test Line Complete" = true)) and (QCSetup."Auto Test Line Comments")) then begin //QC80.1 "Test Line Complete" Term Added
                                                                                                                                                 //taking away the actual measurement comment create if enabled
                                                                                                                                                 //QC71.1 Finish
                        TestLineComments.SETRANGE("Test No.", "Test No.");
                        TestLineComments.SETRANGE("Test Line", "Line No.");
                        if TestLineComments.FIND('+') then
                            LineNo := TestLineComments."Line No." + 10000
                        else
                            LineNo := 10000;

                        TestLineComments.INIT;
                        TestLineComments."Test No." := "Test No.";
                        TestLineComments."Test Line" := "Line No.";
                        TestLineComments."Line No." := LineNo;
                        TestLineComments.Date := WORKDATE;
                        TestLineComments."Entered By" := USERID;
                        TestLineComments.Comment := 'Actual Measurement was changed from ' +
                                                     FORMAT(xRec."Actual Measure") + ' to 0.';
                        TestLineComments.INSERT;
                        "Non-Conformance" := false;
                    end;
                end;

                if "Optional Display Value" <> 0 then
                    TestOptionalDisplay(FIELDNO("Actual Measure"))
                else begin
                    "Optional Display Prefix" := "Optional Display Prefix"::"=";
                    "Optional Display Value" := "Actual Measure";
                end;
            end;
        }
        field(24; "Non-Conformance"; Boolean)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
                AlertColor := AlertOnFormat; //QC7.2
            end;
        }
        field(25; "Date Inspected"; Date)
        {
            Caption = 'Date Tested';
            Description = 'Auto filled when Actual Measure is entered';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // TestStatus;
            end;
        }
        field(26; "Time Inspected"; Time)
        {
            Caption = 'Time Tested';
            Description = 'Auto filled when Actual Measure is entered';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // TestStatus;
            end;
        }
        field(27; "Version Code"; Code[20])
        {
            Description = 'Non editable';
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(30; "Optional Display Prefix"; Option)
        {
            Description = '=,>,<,>=,<=';
            OptionCaption = '=,>,<,>=,<=';
            OptionMembers = "=",">","<",">=","<=";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //Add a text value to this field such as > 3  or < 5
                //to display on a Certification Page or report instead
                //of printing the actual test value.
                TestStatus;
                TestOptionalDisplay(FIELDNO("Optional Display Prefix"));
            end;
        }
        field(31; "Optional Display Value"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
                TestOptionalDisplay(FIELDNO("Optional Display Value"));
            end;
        }
        field(32; "Test Line Complete"; Boolean)
        {
            Caption = 'Complete';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestLineStatus;
                //QC80.1 Start - IF Numeric, make sure Zero "Actual Measure" gets Validated too
                if "Test Line Complete" = true then begin
                    if "Result Type" = "Result Type"::Numeric then begin   //needed for wizard
                                                                           //QC80.1 Start - Handle Blank Result Special
                        ActualMeasure := "Actual Measure";
                        if Result <> '' then begin
                            EVALUATE(ActualMeasure, Result); //this line in original...
                        end;
                        VALIDATE("Actual Measure", ActualMeasure);
                        //QC80.1 Finish
                    end;
                end;
                //QC80.1 Finish
            end;
        }
        field(50; "Result"; Code[10])
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                LineNo: Integer;
                Results: Record QCQualityMeasureOptions_PQ;
            begin
                TestStatus;

                //QC6
                if Result <> '' then begin
                    ResultsT.SETRANGE("Quality Measure Code", "Quality Measure");
                    ResultsT.SETRANGE(Code, Result);
                    if not ResultsT.FINDFIRST then
                        ERROR(Text006, Result);
                end;
                //QC6
                if "Date Inspected" = 0D then
                    "Date Inspected" := WORKDATE;
                if "Time Inspected" = 0T then
                    "Time Inspected" := TIME;
                "Entered By" := USERID;
                "Tested By" := USERID; //QC80.4

                QCTestHeaderT.GET("Test No.");
                QCTestHeaderT."Test Status" := QCTestHeaderT."Test Status"::"In-Process"; //QC7.4 Changed from Numeric value of 1;
                if QCTestHeaderT."Tested By" = '' then
                    QCTestHeaderT."Tested By" := "Tested By";
                QCTestHeaderT.MODIFY;

                QCTestHeaderT.UpdateProdRoutingLineStatus(2);
                //QCTestForm.update;

                "Non-Conformance" := false;



                if Result <> '' then begin
                    if "Result Type" = "Result Type"::Numeric then begin   //needed for wizard
                                                                           //QC80.1 Start - Handle Blank Result Special
                        if Result <> '' then
                            EVALUATE(ActualMeasure, Result); //this line in original...
                                                             //QC80.1 Finish
                        VALIDATE("Actual Measure", ActualMeasure);
                    end else begin
                        Results.SETRANGE("Quality Measure Code", "Quality Measure");
                        Results.SETRANGE(Code, Result);
                        if Results.FIND('+') then begin
                            if Results."Non-Conformance" then begin
                                "Non-Conformance" := true; //QC7.2 Changed "Phase" of Field from "QC Quality Test Results" Table to agree with "Non-Conformance" phase
                            end;
                        end;
                        //QC71.1 Start
                        QCSetup.GET;
                        if ((xRec.Result <> Result) and (QCSetup."Auto Test Line Comments")) then begin   //changing result comment creation if enabled
                                                                                                          //QC71.1 Finish
                            TestLineComments.SETRANGE("Test No.", "Test No.");
                            TestLineComments.SETRANGE("Test Line", "Line No.");
                            if TestLineComments.FIND('+') then
                                LineNo := TestLineComments."Line No." + 10000
                            else
                                LineNo := 10000;

                            TestLineComments.INIT;
                            TestLineComments."Test No." := "Test No.";
                            TestLineComments."Test Line" := "Line No.";
                            TestLineComments."Line No." := LineNo;
                            TestLineComments.Date := WORKDATE;
                            TestLineComments."Entered By" := USERID;
                            TestLineComments.Comment := 'Result was changed from ' +
                                                         xRec.Result + ' to ' +
                                                         Result;
                            TestLineComments.INSERT;

                        end;
                    end;

                end else begin
                    if ((xRec.Result <> '') and (QCSetup."Auto Test Line Comments")) then begin   //QC71.1 - taking away the result comment creation if enabled
                        TestLineComments.SETRANGE("Test No.", "Test No.");
                        TestLineComments.SETRANGE("Test Line", "Line No.");
                        if TestLineComments.FIND('+') then
                            LineNo := TestLineComments."Line No." + 10000
                        else
                            LineNo := 10000;

                        TestLineComments.INIT;
                        TestLineComments."Test No." := "Test No.";
                        TestLineComments."Test Line" := "Line No.";
                        TestLineComments."Line No." := LineNo;
                        TestLineComments.Date := WORKDATE;
                        TestLineComments."Entered By" := USERID;
                        TestLineComments.Comment := 'Result was changed from ' +
                                                     xRec.Result + ' to blank.';
                        TestLineComments.INSERT;
                        "Non-Conformance" := false;
                    end;
                end;
            end;
        }
        field(51; "Result Type"; Option)
        {
            OptionMembers = Numeric,List;
            DataClassification = CustomerContent;
        }
        field(52; "Wizard Line Count"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(53; "UOM Description"; Text[30])
        {
            Caption = 'Unit of Measure Description';
            Description = 'QC7.2 Added';
            DataClassification = CustomerContent;
        }
        field(54; "Conditions"; Text[30])
        {
            Description = 'QC7.2 Added';
            DataClassification = CustomerContent;
        }
        field(55; "Reason Code"; Code[10])
        {
            Description = 'QC7.3 Added';
            TableRelation = "Reason Code".Code;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                ReasonCode: Record "Reason Code";
            begin
                //QC7.3 - Code Added
                if ReasonCode.GET("Reason Code") then
                    "Reason Desc." := ReasonCode.Description;
            end;
        }
        field(56; "Reason Desc."; Text[100])
        {
            Description = 'QC7.3 Added';
            DataClassification = CustomerContent;
        }
        field(100; "Frequency Code"; Integer)
        {
            BlankZero = true;
            Description = 'QC71.1 Added';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(101; "Last Test Date"; Date)
        {
            Description = 'QC71.1 Added';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(102; "Next Test Date"; Date)
        {
            Description = 'QC71.1 Added';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(103; "Outside Testing"; Boolean)
        {
            Description = 'QC71.1 Added';
            DataClassification = CustomerContent;
        }
        field(104; "Custom Test"; Boolean)
        {
            Description = 'QC71.1 Added';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(105; "Ignore for Update"; Boolean)
        {
            Description = 'QC71.1 Added';
            DataClassification = CustomerContent;
        }
        field(106; "Mandatory"; Boolean)
        {
            Description = 'QC71.1 Added';
            DataClassification = CustomerContent;
        }
        field(107; "Lot No."; Code[50])
        {
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Item No."));
            DataClassification = CustomerContent;
            Caption = 'Lot No.';
            Editable = false;
        }
        field(108; "Serial No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Serial No.';
            Editable = false;
        }
        field(109; "Error Check Sum."; Boolean) { }
        field(110; Standart; Text[150])
        {

        }
        field(111; IsInteger; Boolean)
        {

        }
        field(112; "Sampling to"; Integer)
        {

        }
        field(113; "QC By"; Code[20])
        {
            Caption = 'Test By';
            TableRelation = Employee."No.";
            trigger OnValidate()
            var
                myInt: Integer;
                employee: Record Employee;
            begin
                if "QC By" <> '' then begin
                    employee.Reset();
                    employee.SetRange("No.", "QC By");
                    if employee.Find('-') then
                        "QC Name" := employee.FullName();
                end else
                    "QC Name" := '';
            end;
        }
        field(114; "QC Name"; Text[100])
        {
            Caption = 'Test By Name';
            Editable = false;
        }
        field(115; "Display Report Seq."; Integer)
        {

        }
    }

    keys
    {
        key(Key1; "Test No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        //QC71.1 Start
        if QualityFunctions.TestQCMgr() then begin
            //  TestStatus;
            TestLineComments.SETRANGE("Test No.", "Test No.");
            TestLineComments.SETRANGE("Test Line", "Line No.");
            TestLineComments.DELETEALL;
        end else
            ERROR(Text007); //Abort Delete if NOT a "Quality Manager"
        //QC71.1 Finish
    end;

    trigger OnInsert();
    begin
        TestStatus;
        //QC71.1 Start
        if QualityFunctions.TestQCMgr() then begin
            if QCTestHeaderT.GET("Test No.") then begin
                "Item No." := QCTestHeaderT."Item No.";
                "Lot No./Serial No." := QCTestHeaderT."Lot No./Serial No.";
                "Test Qty" := QCTestHeaderT."Test Qty";
                "Unit of Measure" := QCTestHeaderT."Unit of Measure";
                "Tested By" := QCTestHeaderT."Tested By";
                "Test Status" := QCTestHeaderT."Test Status";
            end;
        end else
            ERROR(Text007); //Abort Insert if NOT a "Quality Manager"
        //QC71.1 Finish
    end;

    var
        QCMeasuresT: Record QualityControlMeasures_PQ;
        QCMethodsT: Record QualityControlMethods_PQ;
        QCTestHeaderT: Record QualityTestHeader_PQ;
        TestLineComments: Record QCTestLineComment_PQ;
        Text000: Label 'Optional Value does not match the Actual Values non-conformance status.';
        Text001: Label 'The Optional value must be equal to the Actual Value.';
        Text002: Label 'The Optional value must be less than the Actual Measure.';
        Text003: Label 'The Optional value must be greater than the Actual Measure.';
        Text004: Label 'The Optional value is less than the Lower Limit.  Are you sure you want to continue?';
        Text005: Label 'The Optional value is greater than the Upper Limit.  Are you sure you want to continue?';
        ActualMeasure: Decimal;
        ResultsT: Record QCQualityMeasureOptions_PQ;
        Text006: Label 'Results Code %1 does not exist.';
        [InDataSet]
        AlertColor: Boolean;
        Text007: Label 'You must be a Quality Manager to Insert or Delete Test Lines';
        QualityFunctions: Codeunit QCFunctionLibrary_PQ;
        QCSetup: Record QCSetup_PQ;

    procedure TestOptionalDisplay(CalledByFieldNo: Integer);
    var
        LineNo: Integer;
        TempNonConformStatus: Boolean;
    begin
        TempNonConformStatus := false;
        if (CalledByFieldNo = FIELDNO("Optional Display Value")) or
           (CalledByFieldNo = FIELDNO("Optional Display Prefix")) or
           (CalledByFieldNo = FIELDNO("Actual Measure")) then begin
            if "Optional Display Value" <> 0 then
                case "Optional Display Prefix" of
                    "Optional Display Prefix"::"=":
                        begin
                            if "Optional Display Value" <> "Actual Measure" then
                                "Optional Display Value" := "Actual Measure";
                        end;

                    //Greater Than Prefix
                    "Optional Display Prefix"::">", "Optional Display Prefix"::">=": //QC7.6 - Added '>='
                        begin
                            if "Actual Measure" <> xRec."Actual Measure" then begin
                                "Optional Display Prefix" := "Optional Display Prefix"::"=";
                                "Optional Display Value" := "Actual Measure";
                            end else begin
                                if "Upper Limit" <> 0 then
                                    if "Optional Display Prefix" <> xRec."Optional Display Prefix" then
                                        if ("Optional Display Value" = 0) or
                                           ("Optional Display Value" = "Actual Measure") or
                                           ("Optional Display Value" >= "Upper Limit") then
                                            "Optional Display Value" := "Lower Limit";
                                if "Optional Display Value" < "Lower Limit" then
                                    if not CONFIRM(Text004) then begin
                                        "Optional Display Value" := xRec."Optional Display Value";
                                        exit;
                                    end;
                                if "Optional Display Value" > "Actual Measure" then
                                    ERROR(Text003);
                                if "Optional Display Value" >= "Upper Limit" then
                                    TempNonConformStatus := true;
                                if TempNonConformStatus <> "Non-Conformance" then
                                    ERROR(Text000);
                            end;
                        end;

                    //Less than prefix
                    "Optional Display Prefix"::"<", "Optional Display Prefix"::"<=":  //QC7.6 - Added '<='
                        begin
                            if "Actual Measure" <> xRec."Actual Measure" then begin
                                "Optional Display Prefix" := "Optional Display Prefix"::"=";
                                "Optional Display Value" := "Actual Measure";
                            end else begin
                                if "Lower Limit" <> 0 then
                                    if "Optional Display Prefix" <> xRec."Optional Display Prefix" then
                                        if ("Optional Display Value" = 0) or
                                           ("Optional Display Value" = "Actual Measure") or
                                           ("Optional Display Value" <= "Upper Limit") then
                                            "Optional Display Value" := "Upper Limit";
                                if "Optional Display Value" > "Upper Limit" then
                                    if not CONFIRM(Text005) then begin
                                        "Optional Display Value" := xRec."Optional Display Value";
                                        exit;
                                    end;
                                if "Optional Display Value" < "Actual Measure" then
                                    ERROR(Text002);
                                if "Optional Display Value" <= "Lower Limit" then
                                    TempNonConformStatus := true;
                                if TempNonConformStatus <> "Non-Conformance" then
                                    ERROR(Text000);
                            end;
                        end;
                end;    //end Case
        end;
    end;

    procedure TestStatus();
    var
        TestHeaderT: Record QualityTestHeader_PQ;
    begin
        if TestHeaderT.GET("Test No.") then
            if TestHeaderT."Test Status" > TestHeaderT."Test Status"::"In-Process" then
                TestHeaderT.FIELDERROR("Test Status")
            else
                if (("Test Line Complete" = true) and (xRec."Test Line Complete" = true)) then //QC80.1 "xRec" Term added to keep false error from happening
                    FIELDERROR("Test Line Complete");
    end;

    procedure TestLineStatus();
    var
        TestHeaderT: Record QualityTestHeader_PQ;
    begin
        if TestHeaderT.GET("Test No.") then
            if TestHeaderT."Test Status" > TestHeaderT."Test Status"::"In-Process" then
                TestHeaderT.FIELDERROR("Test Status");
    end;

    procedure AlertOnFormat(): Boolean;
    begin
        //QC7.2 Added

        AlertColor := "Non-Conformance"; //Color certain Fields Red if Line is in Non-Conformance
        exit(AlertColor);
    end;
}

