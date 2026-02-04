codeunit 50700 QCFunctionLibrary_PQ
{
    // version QC13.01

    // //Added Code for Result Type in two places, GetTestSpec & GetTestCustSpec
    // //QC6.1  Added new function to create Security Role
    // QC6.1.1 - Added code to disallow a refresh of a Quality Test where the Test Status is Certified
    //           Added code to save previous values entered and included them with the refreshed values
    //           Modified the TestGetSpecs function and the TestGetCustSpecs function
    //
    //           Modified TestGetSpecs and TestGetCustSpecs to allow the Non Displayed items to still go to the test.
    //           Just not to display on the report.
    //
    // //QC7.3
    //   - Added lines to copy new "Lines" Fields "Conditions" and "UOM Description"
    //
    // //QC7.4
    //   - Changed TestGetSpecs and TestGetCustSpecs to not "Clobber" (Through an OnValidate) the QCTestHEADER's "Test Status" if there are NOT "Actuals" on the LINES
    //   - Changed TestGetSpecs and TestGetCustSpecs to only allow on "New" Test Status, and changed Global Text004 verbage to agree
    //
    // //QC71.1 
    //   - Added lines in GetTestSpecs and GetTestCustSpecs Funcs to copy new "Lines" Fields "Mandatory", "Last Test Date", "Outside Testing"
    //   - Added Logic in GetTestSpecs and GetTestCustSpecs Funcs to obey "Get All Specs" Feature (See, also, Test Header Page)
    //   - Added Logic to prevent "Test Status" being clobbered during TestGetSpecs and TestGetCustSpecs
    //   - Added Logic to Preserve any Existing "Custom Test" Lines and Add/Insert them back where they were in the Lines
    //   - Added Function to Test User "Role" (Test for "Quality Manager")
    //   - Added Function to Update Next Test Dates on Master from a Test
    //   - Changed the Filter for "Ignore for Update" to FALSE instead of TRUE (filter term was backwards)
    //
    // QC80.1 
    //   - Changes to Allow "Test Line Complete" to permit an "Actual Measure" of Zero for a "Completed" Test Line
    //
    // QC80.4 
    //   - Updated Code in UpdateSpecNextTestDates Func to use WORKDATE for "Last Test Date" for updating Spec Lines
    //
    // QC11.01 
    //   - Changes to help with Event-Driven Coding and general Cost Control Code Cleanup
    //     - Moved several Code-Blocks and Global and Local Vars and Text Constants originally inserted in-line into Codeunits 22 and 6501 into Functions...
    //       - ..."ItemJnlPosLineCheckItemTrackingHandleLotNoSerialNo", "ItemTrackingDataCollectionCreateEntrySummary2", "FinalizeConformanceDecision"
    //     - Copied NAV Local Function  "GetTextStringWithLineNo" into this Codeunit so that Code moved from CU 22 would work. It is still in CU 22 as well
    //
    // QC13.01 
    //  - Changes for Stripe Integration
    //    - Added Function "GetProductName" to Return Product Name, mainly for Stripe Integration
    // QC200.01 
    //  - Added functions to control Serial/Lot No. Information creation.

    TableNo = "Production BOM Header";
    Permissions = tabledata 32 = rmdi;

    trigger OnRun();
    begin
    end;

    var
        GlobalSourceNo: Code[20];
        GlobalSourceLineNo: Integer;
        GlobalTestQty: Decimal;
        Text000: Label 'The %1 cannot be copied to itself.';
        Text001: Label '%1 on %2 %3 must not be %4';
        Text002: Label '%1 on %2 %3 %4 must not be %5';
        Text003: Label 'Quality Specification Lines were not found.\\This Error can also be caused by choosing to ''Get''\\only ''Mandatory'' Specs, without any Spec. Lines\\Being marked as ''Mandatory''.\\Please check and Try Again.';
        Text004: Label 'Test Status must be New to run this function';
        Text005: Label 'Quality Specification has not been certified for this item (%1) and Customer (%2) combination.';


    procedure CopyQCSpecs(SelectedQCHeader: Record QCSpecificationHeader_PQ; FromVersionCode: Code[10]; CurrentQCHeader: Record QCSpecificationHeader_PQ; ToVersionCode: Code[10]);
    var
        FromQCSpecLines: Record QCSpecificationLine_PQ;
        ToQCSpecLines: Record QCSpecificationLine_PQ;
        QCSpecVersion: Record QCSpecificationVersions_PQ;
        FromQCComments: Record QCLinesCommentLine_PQ;
        ToQCComments: Record QCLinesCommentLine_PQ;
    begin
        if (SelectedQCHeader."Item No." = CurrentQCHeader."Item No.") and
           (SelectedQCHeader."Customer No." = CurrentQCHeader."Customer No.") and
           (SelectedQCHeader.Type = CurrentQCHeader.Type) and
           (FromVersionCode = ToVersionCode)
        then
            ERROR(Text000, CurrentQCHeader.TABLECAPTION);

        if ToVersionCode = '' then begin
            if CurrentQCHeader.Status = CurrentQCHeader.Status::Certified then
                ERROR(
                  Text001,
                  CurrentQCHeader.FIELDCAPTION(Status),
                  CurrentQCHeader.TABLECAPTION,
                  CurrentQCHeader."Item No.",
                  CurrentQCHeader.Status);
        end else begin
            QCSpecVersion.GET(
              SelectedQCHeader."Item No.", SelectedQCHeader."Customer No.", SelectedQCHeader.Type, ToVersionCode);
            if QCSpecVersion.Status = QCSpecVersion.Status::Certified then
                ERROR(
                  Text002,
                  QCSpecVersion.FIELDCAPTION(Status),
                  QCSpecVersion.TABLECAPTION,
                  QCSpecVersion."Item No.",
                  QCSpecVersion."Version Code",
                  QCSpecVersion.Status);
        end;

        ToQCSpecLines.SETRANGE("Item No.", CurrentQCHeader."Item No.");
        ToQCSpecLines.SETRANGE("Customer No.", CurrentQCHeader."Customer No.");
        ToQCSpecLines.SETRANGE(Type, CurrentQCHeader.Type);
        ToQCSpecLines.SETRANGE("Version Code", ToVersionCode);
        ToQCSpecLines.DELETEALL;

        ToQCComments.SETRANGE("Table Name", ToQCComments."Table Name"::"QC Header");   //assume QC header
        ToQCComments.SETRANGE("Item No.", CurrentQCHeader."Item No.");
        ToQCComments.SETRANGE("Customer No.", CurrentQCHeader."Customer No.");
        ToQCComments.SETRANGE(Type, CurrentQCHeader.Type);
        ToQCComments.SETRANGE("Version Code", ToVersionCode);
        ToQCComments.DELETEALL;

        FromQCSpecLines.SETRANGE("Item No.", SelectedQCHeader."Item No.");
        FromQCSpecLines.SETRANGE("Customer No.", SelectedQCHeader."Customer No.");
        FromQCSpecLines.SETRANGE(Type, SelectedQCHeader.Type);
        FromQCSpecLines.SETRANGE("Version Code", FromVersionCode);
        if FromQCSpecLines.FIND('-') then
            repeat
                ToQCSpecLines := FromQCSpecLines;
                ToQCSpecLines."Item No." := CurrentQCHeader."Item No.";
                ToQCSpecLines."Customer No." := CurrentQCHeader."Customer No.";
                ToQCSpecLines.Type := CurrentQCHeader.Type;
                ToQCSpecLines."Version Code" := ToVersionCode;
                ToQCSpecLines.INSERT;
            until FromQCSpecLines.NEXT = 0;

        FromQCComments.SETRANGE("Table Name", FromQCComments."Table Name"::"QC Header");
        FromQCComments.SETRANGE("Item No.", SelectedQCHeader."Item No.");
        FromQCComments.SETRANGE("Customer No.", SelectedQCHeader."Customer No.");
        FromQCComments.SETRANGE(Type, SelectedQCHeader.Type);
        FromQCComments.SETRANGE("Version Code", FromVersionCode);
        if FromQCComments.FIND('-') then
            repeat
                ToQCComments := FromQCComments;
                ToQCComments."Item No." := CurrentQCHeader."Item No.";
                ToQCComments."Customer No." := CurrentQCHeader."Customer No.";
                ToQCComments.Type := CurrentQCHeader.Type;
                ToQCComments."Version Code" := ToVersionCode;
                ToQCComments.INSERT;
            until FromQCComments.NEXT = 0;
    end;

    procedure CopyQCHeader(SelectedQCHeader: Record QCSpecificationVersions_PQ; FromVersionCode: Code[10]; CurrentQCHeader: Record QCSpecificationHeader_PQ; ToVersionCode: Code[10]);
    var
        FromQCSpecLines: Record QCSpecificationLine_PQ;
        ToQCSpecLines: Record QCSpecificationLine_PQ;
        QCSpecVersion: Record QCSpecificationVersions_PQ;
        FromQCComments: Record QCLinesCommentLine_PQ;
        ToQCComments: Record QCLinesCommentLine_PQ;
    begin
        if (SelectedQCHeader."Item No." = CurrentQCHeader."Item No.") and
           (SelectedQCHeader."Customer No." = CurrentQCHeader."Customer No.") and
           (SelectedQCHeader.Type = CurrentQCHeader.Type) and
           (FromVersionCode = ToVersionCode)
        then
            ERROR(Text000, CurrentQCHeader.TABLECAPTION);

        if ToVersionCode = '' then begin
            if CurrentQCHeader.Status = CurrentQCHeader.Status::Certified then
                ERROR(
                  Text001,
                  CurrentQCHeader.FIELDCAPTION(Status),
                  CurrentQCHeader.TABLECAPTION,
                  CurrentQCHeader."Item No.",
                  CurrentQCHeader.Status);
        end else begin
            QCSpecVersion.GET(
              SelectedQCHeader."Item No.", SelectedQCHeader."Customer No.", SelectedQCHeader.Type, ToVersionCode);
            if QCSpecVersion.Status = QCSpecVersion.Status::Certified then
                ERROR(
                  Text002,
                  QCSpecVersion.FIELDCAPTION(Status),
                  QCSpecVersion.TABLECAPTION,
                  QCSpecVersion."Item No.",
                  QCSpecVersion."Version Code",
                  QCSpecVersion.Status);
        end;

        ToQCSpecLines.SETRANGE("Item No.", CurrentQCHeader."Item No.");
        ToQCSpecLines.SETRANGE("Customer No.", CurrentQCHeader."Customer No.");
        ToQCSpecLines.SETRANGE(Type, CurrentQCHeader.Type);
        ToQCSpecLines.SETRANGE("Version Code", ToVersionCode);
        ToQCSpecLines.DELETEALL;

        ToQCComments.SETRANGE("Table Name", ToQCComments."Table Name"::"QC Header");   //assume QC header
        ToQCComments.SETRANGE("Item No.", CurrentQCHeader."Item No.");
        ToQCComments.SETRANGE("Customer No.", CurrentQCHeader."Customer No.");
        ToQCComments.SETRANGE(Type, CurrentQCHeader.Type);
        ToQCComments.SETRANGE("Version Code", ToVersionCode);
        ToQCComments.DELETEALL;

        FromQCSpecLines.SETRANGE("Item No.", SelectedQCHeader."Item No.");
        FromQCSpecLines.SETRANGE("Customer No.", SelectedQCHeader."Customer No.");
        FromQCSpecLines.SETRANGE(Type, SelectedQCHeader.Type);
        FromQCSpecLines.SETRANGE("Version Code", FromVersionCode);
        if FromQCSpecLines.FIND('-') then
            repeat
                ToQCSpecLines := FromQCSpecLines;
                ToQCSpecLines."Item No." := CurrentQCHeader."Item No.";
                ToQCSpecLines."Customer No." := CurrentQCHeader."Customer No.";
                ToQCSpecLines.Type := CurrentQCHeader.Type;
                ToQCSpecLines."Version Code" := ToVersionCode;
                ToQCSpecLines.INSERT;
            until FromQCSpecLines.NEXT = 0;

        FromQCComments.SETRANGE("Table Name", FromQCComments."Table Name"::"QC Header");
        FromQCComments.SETRANGE("Item No.", SelectedQCHeader."Item No.");
        FromQCComments.SETRANGE("Customer No.", SelectedQCHeader."Customer No.");
        FromQCComments.SETRANGE(Type, SelectedQCHeader.Type);
        FromQCComments.SETRANGE("Version Code", FromVersionCode);
        if FromQCComments.FIND('-') then
            repeat
                ToQCComments := FromQCComments;
                ToQCComments."Item No." := CurrentQCHeader."Item No.";
                ToQCComments."Customer No." := CurrentQCHeader."Customer No.";
                ToQCComments.Type := CurrentQCHeader.Type;
                ToQCComments."Version Code" := ToVersionCode;
                ToQCComments.INSERT;
            until FromQCComments.NEXT = 0;
    end;

    procedure CopyFromVersion(var QCSpecVersion2: Record QCSpecificationVersions_PQ);
    var
        QCSpecHeaderT: Record QCSpecificationHeader_PQ;
        OldQCSpecVersionT: Record QCSpecificationVersions_PQ;
    begin
        OldQCSpecVersionT := QCSpecVersion2;

        QCSpecHeaderT."Item No." := QCSpecVersion2."Item No.";
        QCSpecHeaderT."Customer No." := QCSpecVersion2."Customer No.";
        QCSpecHeaderT.Type := QCSpecVersion2.Type;
        if PAGE.RUNMODAL(0, QCSpecVersion2) = ACTION::LookupOK then begin
            if OldQCSpecVersionT.Status = OldQCSpecVersionT.Status::Certified then
                ERROR(
                  Text002,
                  OldQCSpecVersionT.FIELDCAPTION(Status),
                  OldQCSpecVersionT.TABLECAPTION,
                  OldQCSpecVersionT."Item No.",
                  OldQCSpecVersionT."Version Code",
                  OldQCSpecVersionT.Status);
            CopyQCHeader(OldQCSpecVersionT, QCSpecVersion2."Version Code", QCSpecHeaderT, OldQCSpecVersionT."Version Code");
        end;

        QCSpecVersion2 := OldQCSpecVersionT;
    end;

    procedure GetQCVersion(ItemNo: Code[20]; CustNo: Code[20]; Type: Code[20]; Date: Date; Origin: Option QCTestCopy,PrimarySpecCard,SalesLine): Code[10];
    var
        QCVersion: Record QCSpecificationVersions_PQ;
        VerCode: Code[20];
    begin
        case Origin of
            Origin::QCTestCopy:      // 0 = Gets certified primary only
                begin
                    QCVersion.SETCURRENTKEY("Item No.", "Customer No.", Type, "Effective Date");
                    QCVersion.SETRANGE("Item No.", ItemNo);
                    QCVersion.SETRANGE("Customer No.", '');
                    if Type <> '' then
                        QCVersion.SETRANGE(Type, Type);
                    QCVersion.SETFILTER("Effective Date", '%1|..%2', 0D, Date);
                    QCVersion.SETRANGE(Status, QCVersion.Status::Certified);
                    if not QCVersion.FIND('+') then
                        CLEAR(QCVersion);

                    exit(QCVersion."Version Code");
                end;
            Origin::PrimarySpecCard:    // 1 = Gets current certified version related to Primary Spec
                begin
                    QCVersion.SETCURRENTKEY("Item No.", "Customer No.", Type, "Effective Date");
                    QCVersion.SETRANGE("Item No.", ItemNo);
                    QCVersion.SETRANGE("Customer No.", CustNo);
                    if Type <> '' then
                        QCVersion.SETRANGE(Type, Type);
                    QCVersion.SETFILTER("Effective Date", '%1|..%2', 0D, Date);
                    QCVersion.SETRANGE(Status, QCVersion.Status::Certified);
                    if QCVersion.FIND('+') then
                        VerCode := QCVersion."Version Code"
                    else
                        VerCode := '';
                    exit(VerCode);
                end;
            Origin::SalesLine:     // 2 =
                begin
                    QCVersion.SETCURRENTKEY("Item No.", "Customer No.", Type, "Effective Date");
                    QCVersion.SETRANGE("Item No.", ItemNo);
                    QCVersion.SETRANGE("Customer No.", CustNo);
                    if Type <> '' then
                        QCVersion.SETRANGE(Type, Type);
                    QCVersion.SETFILTER("Effective Date", '%1|..%2', 0D, Date);
                    QCVersion.SETRANGE(Status, QCVersion.Status::Certified);
                    if QCVersion.FIND('+') then
                        VerCode := QCVersion."Version Code"
                    else
                        VerCode := '';
                    exit(VerCode);
                end;
        end;
    end;

    procedure TestGetSpecs2(var QCTestHeader: Record QualityTestHeader_PQ; VersionCode: Code[20]; SpecificationNo: Code[20]; GetAllSpecs: Boolean);
    var
        QCTestLinesT: Record QualityTestLines_PQ;
        QCTestLineCommentT: Record QCTestLineComment_PQ;
        FromQCSpecLinesT: Record QCSpecificationLine_PQ;
        ToQCTestLinesT: Record QualityTestLines_PQ;
        FromSpecLinesCommentT: Record QCLinesCommentLine_PQ;
        ToTestLinesCommentT: Record QCTestLineComment_PQ;
        QualitySpecHeader: Record QCSpecificationHeader_PQ;
        TempQCTestLinesT: Record QualityTestLines_PQ temporary;
        "-NP1--": Integer;
        TempQCTestHeader: Record QualityTestHeader_PQ;
        TempCustomQCTestLines: Record QualityTestLines_PQ temporary;
        LineNo: Integer;
        FoundLine: Boolean;
    begin
        if QualitySpecHeader.GET(QCTestHeader."Item No.", '', SpecificationNo) then begin
            QCTestHeader."Category Code" := QualitySpecHeader."Category Code";
            QCTestHeader.Modify;
        end;

        //QC71.1 Start
        TempQCTestHeader := QCTestHeader; //Preserve Incoming Record so that "Test Status" doesn't get scrogged
        //QC71.1 Finish

        //QC6.1.1 START
        //IF QCTestHeader."Test Status" = QCTestHeader."Test Status"::"In-Process" THEN //QC7.4
        if QCTestHeader."Test Status" <> QCTestHeader."Test Status"::New then //QC7.4
            ERROR(Text004);
        //QC6.1.1 FINISH

        QCTestLinesT.SETRANGE("Test No.", QCTestHeader."Test No.");
        QCTestLinesT.SETRANGE("Custom Test", false); //QC71.1
        //QC6.1.1 START
        TempQCTestLinesT.DELETEALL;
        if QCTestLinesT.FINDSET then
            repeat
                TempQCTestLinesT := QCTestLinesT;
                TempQCTestLinesT.INSERT;
                QCTestLinesT.DELETE;
            until QCTestLinesT.NEXT = 0;
        //QCTestLinesT.DELETEALL;

        //QC71.1 Start
        QCTestLinesT.SETRANGE("Custom Test", true); //Get ready to remember the Custom Test Lines
        TempCustomQCTestLines.RESET;
        TempCustomQCTestLines.DELETEALL;
        QCTestLinesT.SETRANGE("Custom Test", true);
        if QCTestLinesT.FINDSET then
            repeat
                TempCustomQCTestLines := QCTestLinesT;
                TempCustomQCTestLines.INSERT(false); //Remember "Custom Tests" (Will be inserted/added to existing Lines)
                QCTestLinesT.DELETE;
            until QCTestLinesT.NEXT = 0;
        LineNo := 10000;
        QCTestLinesT.SETRANGE("Custom Test", false);
        //QC71.1 Finish

        //QC6.1.1 START

        QCTestLineCommentT.SETRANGE("Test No.", QCTestHeader."Test No.");
        QCTestLineCommentT.DELETEALL;

        FromQCSpecLinesT.SETRANGE("Item No.", QCTestHeader."Item No.");
        FromQCSpecLinesT.SETRANGE("Customer No.", '');
        FromQCSpecLinesT.SETRANGE(Type, SpecificationNo);
        FromQCSpecLinesT.SETRANGE("Version Code", VersionCode);

        //QC71.1 Start
        if not GetAllSpecs then
            FromQCSpecLinesT.SETRANGE(Mandatory, true); //Only Get Specs that are "Mandatory" if NOT "Bet All"
        //QC71.1 Finish

        //QC6.1.1 START
        //FromQCSpecLinesT.SETRANGE(Display,TRUE);
        //QC6.1.1 FINISH
        if not FromQCSpecLinesT.FIND('-') then
            ERROR(Text003)
        else
            repeat
                //QC6.1.1 START
                if (QualitySpecHeader.GET(FromQCSpecLinesT."Item No.", FromQCSpecLinesT."Customer No.", FromQCSpecLinesT.Type)) and
                   (QualitySpecHeader.Status <> QualitySpecHeader.Status::Certified) then
                    ERROR(Text005, FromQCSpecLinesT."Item No.", FromQCSpecLinesT."Customer No.");

                //QC6.1.1 FINISH
                ToQCTestLinesT.INIT;
                ToQCTestLinesT."Test No." := QCTestHeader."Test No.";
                ToQCTestLinesT."Line No." := FromQCSpecLinesT."Line No.";
                ToQCTestLinesT."Item No." := QCTestHeader."Item No.";
                ToQCTestLinesT."Lot No./Serial No." := QCTestHeader."Lot No./Serial No.";
                ToQCTestLinesT."Lot No." := QCTestHeader."Lot No.";
                ToQCTestLinesT."Serial No." := QCTestHeader."Serial No.";
                ToQCTestLinesT."Test Date" := QCTestHeader."Test Start Date";
                ToQCTestLinesT."Test Time" := QCTestHeader."Test Start Time";
                ToQCTestLinesT."Test Qty" := QCTestHeader."Test Qty";
                ToQCTestLinesT."Unit of Measure" := QCTestHeader."Unit of Measure";
                ToQCTestLinesT."Tested By" := QCTestHeader."Tested By";
                ToQCTestLinesT."Entered By" := USERID;
                ToQCTestLinesT."Test Status" := QCTestHeader."Test Status";
                ToQCTestLinesT."Quality Measure" := FromQCSpecLinesT."Quality Measure";
                ToQCTestLinesT."Measure Description" := FromQCSpecLinesT."Measure Description";
                ToQCTestLinesT."Lower Limit" := FromQCSpecLinesT."Lower Limit";
                ToQCTestLinesT."Upper Limit" := FromQCSpecLinesT."Upper Limit";
                ToQCTestLinesT."Nominal Value" := FromQCSpecLinesT."Nominal Value";
                ToQCTestLinesT."Testing UOM" := FromQCSpecLinesT."Testing UOM";
                ToQCTestLinesT.Display := FromQCSpecLinesT.Display;
                ToQCTestLinesT.Method := FromQCSpecLinesT.Method;
                ToQCTestLinesT."Method Description" := FromQCSpecLinesT."Method Description";
                ToQCTestLinesT."Version Code" := VersionCode;
                ToQCTestLinesT.Standart := FromQCSpecLinesT.Standart;
                ToQCTestLinesT."Sampling to" := FromQCSpecLinesT."Sampling to";
                ToQCTestLinesT."Display Report Seq." := FromQCSpecLinesT."Display Report Seq.";
                ToQCTestLinesT.IsInteger := FromQCSpecLinesT.IsInteger;
                //

                //QC7.3 Start
                ToQCTestLinesT."UOM Description" := FromQCSpecLinesT."UOM Description";
                ToQCTestLinesT.Conditions := FromQCSpecLinesT.Conditions; //Copy new Fields
                                                                          //QC7.3 Finish

                //QC71.1 Start - Copy new Fields
                //    ToQCTestLinesT."Frequency Code" := FromQCSpecLinesT."Frequency Code";
                ToQCTestLinesT."Last Test Date" := FromQCSpecLinesT."Last Test Date";
                //    ToQCTestLinesT."Next Test Date" := FromQCSpecLinesT."Next Test Date";
                ToQCTestLinesT."Outside Testing" := FromQCSpecLinesT."Outside Testing";
                ToQCTestLinesT.Mandatory := FromQCSpecLinesT.Mandatory;
                //QC71.1 Finish

                //QC4.30
                ToQCTestLinesT."Result Type" := FromQCSpecLinesT."Result Type";
                //ToQCTestLinesT."Actual Measure"   ...manually entered
                //ToQCTestLinesT."Non-Conformance"  ...triggered with Actual measure entry
                //ToQCTestLinesT."Date Inspected"   ...triggered with Actual measure entry
                //ToQCTestLinesT."Time Inspected"   ...triggered with Actual measure entry

                //QC6.1.1 START
                TempQCTestLinesT.SETRANGE("Test No.", ToQCTestLinesT."Test No.");
                TempQCTestLinesT.SETRANGE("Item No.", ToQCTestLinesT."Item No.");
                TempQCTestLinesT.SETRANGE("Lot No./Serial No.", ToQCTestLinesT."Lot No./Serial No.");
                TempQCTestLinesT.SETRANGE("Quality Measure", ToQCTestLinesT."Quality Measure");
                TempQCTestLinesT.SETRANGE("Lower Limit", ToQCTestLinesT."Lower Limit");
                TempQCTestLinesT.SETRANGE("Upper Limit", ToQCTestLinesT."Upper Limit");

                //QC71.1 Start
                TempQCTestLinesT.SETRANGE("Customer No.", ToQCTestLinesT."Customer No.");
                TempQCTestLinesT.SETRANGE(Conditions, ToQCTestLinesT.Conditions);
                TempQCTestLinesT.SETRANGE(Method, ToQCTestLinesT.Method);
                TempQCTestLinesT.SETRANGE("Custom Test", ToQCTestLinesT."Custom Test");
                //QC71.1 Finish

                FoundLine := false; //QC71.1 Added
                if TempQCTestLinesT.FINDFIRST then begin
                    FoundLine := true; //QC71.1 Added
                    if (ToQCTestLinesT."Result Type" = ToQCTestLinesT."Result Type"::List) and (TempQCTestLinesT.Result <> '') then   //QC71.1
                        ToQCTestLinesT.VALIDATE(Result, TempQCTestLinesT.Result)
                    else
                        if ((TempQCTestLinesT."Actual Measure" <> 0) or (TempQCTestLinesT."Test Line Complete" = true)) then //QC71.1 and QC80.1
                            ToQCTestLinesT.VALIDATE("Actual Measure", TempQCTestLinesT."Actual Measure");
                    ToQCTestLinesT."Date Inspected" := TempQCTestLinesT."Date Inspected";
                    ToQCTestLinesT."Time Inspected" := TempQCTestLinesT."Time Inspected";
                    ToQCTestLinesT."Optional Display Prefix" := TempQCTestLinesT."Optional Display Prefix";
                    ToQCTestLinesT."Optional Display Value" := TempQCTestLinesT."Optional Display Value";
                end;
                //QC6.1.1 FINISH

                if VersionCode = '' then begin
                    FromSpecLinesCommentT.SETRANGE("Table Name", FromSpecLinesCommentT."Table Name"::"QC Lines");
                    FromSpecLinesCommentT.SETRANGE("Item No.", QCTestHeader."Item No.");
                    FromSpecLinesCommentT.SETRANGE("Customer No.", '');
                    FromSpecLinesCommentT.SETRANGE(Type, SpecificationNo);
                    FromSpecLinesCommentT.SETRANGE("QC Line No.", FromQCSpecLinesT."Line No.");
                    if FromSpecLinesCommentT.FIND('-') then
                        repeat
                            ToTestLinesCommentT.INIT;
                            ToTestLinesCommentT."Test No." := QCTestHeader."Test No.";
                            ToTestLinesCommentT."Test Line" := ToQCTestLinesT."Line No.";
                            ToTestLinesCommentT."Line No." := FromSpecLinesCommentT."Line No.";
                            ToTestLinesCommentT.Date := FromSpecLinesCommentT.Date;
                            ToTestLinesCommentT."Entered By" := USERID;
                            ToTestLinesCommentT.Comment := FromSpecLinesCommentT.Comment;
                            ToTestLinesCommentT.Code := FromSpecLinesCommentT.Code;
                            ToTestLinesCommentT.INSERT;
                        until FromSpecLinesCommentT.NEXT = 0;
                end else begin
                    //      QCTestHeader := TempQCTestHeader; //QC71.1 - Restore Record from "Backup"
                    QCTestHeader."Test Status" := QCTestHeader."Test Status"::New; //QC71.1
                    QCTestHeader."Spec Version Used" := VersionCode;
                    QCTestHeader.MODIFY;

                    FromSpecLinesCommentT.SETRANGE("Table Name", FromSpecLinesCommentT."Table Name"::"QC Lines");
                    FromSpecLinesCommentT.SETRANGE("Item No.", QCTestHeader."Item No.");
                    FromSpecLinesCommentT.SETRANGE("Customer No.", '');
                    FromSpecLinesCommentT.SETRANGE(Type, SpecificationNo);
                    FromSpecLinesCommentT.SETRANGE("Version Code", VersionCode);
                    FromSpecLinesCommentT.SETRANGE("QC Line No.", FromQCSpecLinesT."Line No.");
                    if FromSpecLinesCommentT.FIND('-') then
                        repeat
                            ToTestLinesCommentT.INIT;
                            ToTestLinesCommentT."Test No." := QCTestHeader."Test No.";
                            ToTestLinesCommentT."Test Line" := ToQCTestLinesT."Line No.";
                            ToTestLinesCommentT."Line No." := FromSpecLinesCommentT."Line No.";
                            ToTestLinesCommentT.Date := FromSpecLinesCommentT.Date;
                            ToTestLinesCommentT."Entered By" := USERID;
                            ToTestLinesCommentT.Comment := FromSpecLinesCommentT.Comment;
                            ToTestLinesCommentT.Code := FromSpecLinesCommentT.Code;
                            ToTestLinesCommentT.INSERT;
                        until FromSpecLinesCommentT.NEXT = 0;
                end;
                TestGetSpecs2OnBeforeInsertQCTestLines(ToQCTestLinesT, FromQCSpecLinesT);
                ToQCTestLinesT.INSERT;

            until FromQCSpecLinesT.NEXT = 0;

        //QC71.1 Start
        LineNo := 0;
        if ToQCTestLinesT.FINDLAST then
            LineNo := ToQCTestLinesT."Line No."; //Find Last Line No.
        LineNo := LineNo + 10000;
        if TempCustomQCTestLines.FINDSET then
            repeat
                ToQCTestLinesT.SETFILTER("Line No.", '<=%1', TempCustomQCTestLines."Line No.");
                if ToQCTestLinesT.FIND('+') then
                    LineNo := ToQCTestLinesT."Line No." + 10
                else begin
                    ToQCTestLinesT.SETRANGE("Line No.");
                    LineNo := 10000;
                    if ToQCTestLinesT.FIND('+') then
                        LineNo := ToQCTestLinesT."Line No." + 129; //Place after Last Line
                end;
                ToQCTestLinesT := TempCustomQCTestLines;
                ToQCTestLinesT."Line No." := LineNo;
                LineNo := LineNo + 10000;
                ToQCTestLinesT.INSERT(false); //Add "Custom Tests" to the other Tests
            until TempCustomQCTestLines.NEXT = 0;
        //QC71.1 Finish
    end;

    procedure TestGetSpecs(var QCTestHeader: Record QualityTestHeader_PQ; VersionCode: Code[20]; GetAllSpecs: Boolean);
    var
        QCTestLinesT: Record QualityTestLines_PQ;
        QCTestLineCommentT: Record QCTestLineComment_PQ;
        FromQCSpecLinesT: Record QCSpecificationLine_PQ;
        ToQCTestLinesT: Record QualityTestLines_PQ;
        FromSpecLinesCommentT: Record QCLinesCommentLine_PQ;
        ToTestLinesCommentT: Record QCTestLineComment_PQ;
        QualitySpecHeader: Record QCSpecificationHeader_PQ;
        TempQCTestLinesT: Record QualityTestLines_PQ temporary;
        "-NP1--": Integer;
        TempQCTestHeader: Record QualityTestHeader_PQ;
        TempCustomQCTestLines: Record QualityTestLines_PQ temporary;
        LineNo: Integer;
        FoundLine: Boolean;
    begin
        //QC71.1 Start
        TempQCTestHeader := QCTestHeader; //Preserve Incoming Record so that "Test Status" doesn't get scrogged
        //QC71.1 Finish

        //QC6.1.1 START
        //IF QCTestHeader."Test Status" = QCTestHeader."Test Status"::"In-Process" THEN //QC7.4
        if QCTestHeader."Test Status" <> QCTestHeader."Test Status"::New then //QC7.4
            ERROR(Text004);
        //QC6.1.1 FINISH

        QCTestLinesT.SETRANGE("Test No.", QCTestHeader."Test No.");
        QCTestLinesT.SETRANGE("Custom Test", false); //QC71.1
        //QC6.1.1 START
        TempQCTestLinesT.DELETEALL;
        if QCTestLinesT.FINDSET then
            repeat
                TempQCTestLinesT := QCTestLinesT;
                TempQCTestLinesT.INSERT;
                QCTestLinesT.DELETE;
            until QCTestLinesT.NEXT = 0;
        //QCTestLinesT.DELETEALL;

        //QC71.1 Start
        QCTestLinesT.SETRANGE("Custom Test", true); //Get ready to remember the Custom Test Lines
        TempCustomQCTestLines.RESET;
        TempCustomQCTestLines.DELETEALL;
        QCTestLinesT.SETRANGE("Custom Test", true);
        if QCTestLinesT.FINDSET then
            repeat
                TempCustomQCTestLines := QCTestLinesT;
                TempCustomQCTestLines.INSERT(false); //Remember "Custom Tests" (Will be inserted/added to existing Lines)
                QCTestLinesT.DELETE;
            until QCTestLinesT.NEXT = 0;
        LineNo := 10000;
        QCTestLinesT.SETRANGE("Custom Test", false);
        //QC71.1 Finish

        //QC6.1.1 START

        QCTestLineCommentT.SETRANGE("Test No.", QCTestHeader."Test No.");
        QCTestLineCommentT.DELETEALL;

        FromQCSpecLinesT.SETRANGE("Item No.", QCTestHeader."Item No.");
        FromQCSpecLinesT.SETRANGE("Customer No.", '');
        FromQCSpecLinesT.SETRANGE(Type, '');
        FromQCSpecLinesT.SETRANGE("Version Code", VersionCode);

        //QC71.1 Start
        if not GetAllSpecs then
            FromQCSpecLinesT.SETRANGE(Mandatory, true); //Only Get Specs that are "Mandatory" if NOT "Bet All"
        //QC71.1 Finish

        //QC6.1.1 START
        //FromQCSpecLinesT.SETRANGE(Display,TRUE);
        //QC6.1.1 FINISH
        if not FromQCSpecLinesT.FIND('-') then
            ERROR(Text003)
        else
            repeat
                //QC6.1.1 START
                if (QualitySpecHeader.GET(FromQCSpecLinesT."Item No.", FromQCSpecLinesT."Customer No.", FromQCSpecLinesT.Type)) and
                   (QualitySpecHeader.Status <> QualitySpecHeader.Status::Certified) then
                    ERROR(Text005, FromQCSpecLinesT."Item No.", FromQCSpecLinesT."Customer No.");
                //QC6.1.1 FINISH
                ToQCTestLinesT.INIT;
                ToQCTestLinesT."Test No." := QCTestHeader."Test No.";
                ToQCTestLinesT."Line No." := FromQCSpecLinesT."Line No.";
                ToQCTestLinesT."Item No." := QCTestHeader."Item No.";
                ToQCTestLinesT."Lot No./Serial No." := QCTestHeader."Lot No./Serial No.";
                ToQCTestLinesT."Test Date" := QCTestHeader."Test Start Date";
                ToQCTestLinesT."Test Time" := QCTestHeader."Test Start Time";
                ToQCTestLinesT."Test Qty" := QCTestHeader."Test Qty";
                ToQCTestLinesT."Unit of Measure" := QCTestHeader."Unit of Measure";
                ToQCTestLinesT."Tested By" := QCTestHeader."Tested By";
                ToQCTestLinesT."Entered By" := USERID;
                ToQCTestLinesT."Test Status" := QCTestHeader."Test Status";
                ToQCTestLinesT."Quality Measure" := FromQCSpecLinesT."Quality Measure";
                ToQCTestLinesT."Measure Description" := FromQCSpecLinesT."Measure Description";
                ToQCTestLinesT."Lower Limit" := FromQCSpecLinesT."Lower Limit";
                ToQCTestLinesT."Upper Limit" := FromQCSpecLinesT."Upper Limit";
                ToQCTestLinesT."Nominal Value" := FromQCSpecLinesT."Nominal Value";
                ToQCTestLinesT."Testing UOM" := FromQCSpecLinesT."Testing UOM";
                ToQCTestLinesT.Display := FromQCSpecLinesT.Display;
                ToQCTestLinesT.Method := FromQCSpecLinesT.Method;
                ToQCTestLinesT."Method Description" := FromQCSpecLinesT."Method Description";
                ToQCTestLinesT."Version Code" := VersionCode;
                ToQCTestLinesT.Standart := FromQCSpecLinesT.Standart;
                ToQCTestLinesT."Sampling to" := FromQCSpecLinesT."Sampling to";
                ToQCTestLinesT."Display Report Seq." := FromQCSpecLinesT."Display Report Seq.";
                ToQCTestLinesT.IsInteger := FromQCSpecLinesT.IsInteger;

                //QC7.3 Start
                ToQCTestLinesT."UOM Description" := FromQCSpecLinesT."UOM Description";
                ToQCTestLinesT.Conditions := FromQCSpecLinesT.Conditions; //Copy new Fields
                                                                          //QC7.3 Finish

                //QC71.1 Start - Copy new Fields
                //    ToQCTestLinesT."Frequency Code" := FromQCSpecLinesT."Frequency Code";
                ToQCTestLinesT."Last Test Date" := FromQCSpecLinesT."Last Test Date";
                //    ToQCTestLinesT."Next Test Date" := FromQCSpecLinesT."Next Test Date";
                ToQCTestLinesT."Outside Testing" := FromQCSpecLinesT."Outside Testing";
                ToQCTestLinesT.Mandatory := FromQCSpecLinesT.Mandatory;
                //QC71.1 Finish

                //QC4.30
                ToQCTestLinesT."Result Type" := FromQCSpecLinesT."Result Type";
                //ToQCTestLinesT."Actual Measure"   ...manually entered
                //ToQCTestLinesT."Non-Conformance"  ...triggered with Actual measure entry
                //ToQCTestLinesT."Date Inspected"   ...triggered with Actual measure entry
                //ToQCTestLinesT."Time Inspected"   ...triggered with Actual measure entry

                //QC6.1.1 START
                TempQCTestLinesT.SETRANGE("Test No.", ToQCTestLinesT."Test No.");
                TempQCTestLinesT.SETRANGE("Item No.", ToQCTestLinesT."Item No.");
                TempQCTestLinesT.SETRANGE("Lot No./Serial No.", ToQCTestLinesT."Lot No./Serial No.");
                TempQCTestLinesT.SETRANGE("Quality Measure", ToQCTestLinesT."Quality Measure");
                TempQCTestLinesT.SETRANGE("Lower Limit", ToQCTestLinesT."Lower Limit");
                TempQCTestLinesT.SETRANGE("Upper Limit", ToQCTestLinesT."Upper Limit");

                //QC71.1 Start
                TempQCTestLinesT.SETRANGE("Customer No.", ToQCTestLinesT."Customer No.");
                TempQCTestLinesT.SETRANGE(Conditions, ToQCTestLinesT.Conditions);
                TempQCTestLinesT.SETRANGE(Method, ToQCTestLinesT.Method);
                TempQCTestLinesT.SETRANGE("Custom Test", ToQCTestLinesT."Custom Test");
                //QC71.1 Finish

                FoundLine := false; //QC71.1 Added
                if TempQCTestLinesT.FINDFIRST then begin
                    FoundLine := true; //QC71.1 Added
                    if (ToQCTestLinesT."Result Type" = ToQCTestLinesT."Result Type"::List) and (TempQCTestLinesT.Result <> '') then   //QC71.1
                        ToQCTestLinesT.VALIDATE(Result, TempQCTestLinesT.Result)
                    else
                        if ((TempQCTestLinesT."Actual Measure" <> 0) or (TempQCTestLinesT."Test Line Complete" = true)) then //QC71.1 and QC80.1
                            ToQCTestLinesT.VALIDATE("Actual Measure", TempQCTestLinesT."Actual Measure");
                    ToQCTestLinesT."Date Inspected" := TempQCTestLinesT."Date Inspected";
                    ToQCTestLinesT."Time Inspected" := TempQCTestLinesT."Time Inspected";
                    ToQCTestLinesT."Optional Display Prefix" := TempQCTestLinesT."Optional Display Prefix";
                    ToQCTestLinesT."Optional Display Value" := TempQCTestLinesT."Optional Display Value";
                end;
                //QC6.1.1 FINISH

                if VersionCode = '' then begin
                    FromSpecLinesCommentT.SETRANGE("Table Name", FromSpecLinesCommentT."Table Name"::"QC Lines");
                    FromSpecLinesCommentT.SETRANGE("Item No.", QCTestHeader."Item No.");
                    FromSpecLinesCommentT.SETRANGE("Customer No.", '');
                    FromSpecLinesCommentT.SETRANGE(Type, '');
                    FromSpecLinesCommentT.SETRANGE("QC Line No.", FromQCSpecLinesT."Line No.");
                    if FromSpecLinesCommentT.FIND('-') then
                        repeat
                            ToTestLinesCommentT.INIT;
                            ToTestLinesCommentT."Test No." := QCTestHeader."Test No.";
                            ToTestLinesCommentT."Test Line" := ToQCTestLinesT."Line No.";
                            ToTestLinesCommentT."Line No." := FromSpecLinesCommentT."Line No.";
                            ToTestLinesCommentT.Date := FromSpecLinesCommentT.Date;
                            ToTestLinesCommentT."Entered By" := USERID;
                            ToTestLinesCommentT.Comment := FromSpecLinesCommentT.Comment;
                            ToTestLinesCommentT.Code := FromSpecLinesCommentT.Code;
                            ToTestLinesCommentT.INSERT;
                        until FromSpecLinesCommentT.NEXT = 0;
                end else begin
                    //      QCTestHeader := TempQCTestHeader; //QC71.1 - Restore Record from "Backup"
                    QCTestHeader."Test Status" := QCTestHeader."Test Status"::New; //QC71.1
                    QCTestHeader."Spec Version Used" := VersionCode;
                    QCTestHeader.MODIFY;

                    FromSpecLinesCommentT.SETRANGE("Table Name", FromSpecLinesCommentT."Table Name"::"QC Lines");
                    FromSpecLinesCommentT.SETRANGE("Item No.", QCTestHeader."Item No.");
                    FromSpecLinesCommentT.SETRANGE("Customer No.", '');
                    FromSpecLinesCommentT.SETRANGE(Type, '');
                    FromSpecLinesCommentT.SETRANGE("Version Code", VersionCode);
                    FromSpecLinesCommentT.SETRANGE("QC Line No.", FromQCSpecLinesT."Line No.");
                    if FromSpecLinesCommentT.FIND('-') then
                        repeat
                            ToTestLinesCommentT.INIT;
                            ToTestLinesCommentT."Test No." := QCTestHeader."Test No.";
                            ToTestLinesCommentT."Test Line" := ToQCTestLinesT."Line No.";
                            ToTestLinesCommentT."Line No." := FromSpecLinesCommentT."Line No.";
                            ToTestLinesCommentT.Date := FromSpecLinesCommentT.Date;
                            ToTestLinesCommentT."Entered By" := USERID;
                            ToTestLinesCommentT.Comment := FromSpecLinesCommentT.Comment;
                            ToTestLinesCommentT.Code := FromSpecLinesCommentT.Code;
                            ToTestLinesCommentT.INSERT;
                        until FromSpecLinesCommentT.NEXT = 0;
                end;
                ToQCTestLinesT.INSERT;

            until FromQCSpecLinesT.NEXT = 0;

        //QC71.1 Start
        LineNo := 0;
        if ToQCTestLinesT.FINDLAST then
            LineNo := ToQCTestLinesT."Line No."; //Find Last Line No.
        LineNo := LineNo + 10000;
        if TempCustomQCTestLines.FINDSET then
            repeat
                ToQCTestLinesT.SETFILTER("Line No.", '<=%1', TempCustomQCTestLines."Line No.");
                if ToQCTestLinesT.FIND('+') then
                    LineNo := ToQCTestLinesT."Line No." + 10
                else begin
                    ToQCTestLinesT.SETRANGE("Line No.");
                    LineNo := 10000;
                    if ToQCTestLinesT.FIND('+') then
                        LineNo := ToQCTestLinesT."Line No." + 129; //Place after Last Line
                end;
                ToQCTestLinesT := TempCustomQCTestLines;
                ToQCTestLinesT."Line No." := LineNo;
                LineNo := LineNo + 10000;
                ToQCTestLinesT.INSERT(false); //Add "Custom Tests" to the other Tests
            until TempCustomQCTestLines.NEXT = 0;
        //QC71.1 Finish
    end;

    procedure GetTempCompliance(TempEntrySummaryT: Record "Entry Summary");
    var
        QCTempComplianceT: Record QCTempComplianceView_PQ temporary;
        QSpecLineT: Record QCSpecificationLine_PQ;
        QLotTestLineT: Record QualityTestLines_PQ;
        QCTempComplianceT2: Record QCTempComplianceView_PQ;
    begin
        QSpecLineT.SETRANGE("Item No.", TempEntrySummaryT."Item No.");
        QSpecLineT.SETRANGE("Customer No.", TempEntrySummaryT."Customer No.");
        QSpecLineT.SETRANGE(Type, '');
        QSpecLineT.SETRANGE("Version Code", TempEntrySummaryT."Version Code");
        if QSpecLineT.FIND('-') then
            repeat
                QCTempComplianceT.INIT;
                QCTempComplianceT."Quality Measure" := QSpecLineT."Quality Measure";
                QCTempComplianceT.Description := QSpecLineT."Measure Description";
                QCTempComplianceT.Method := QSpecLineT.Method;
                QCTempComplianceT."Item No." := TempEntrySummaryT."Item No.";
                QCTempComplianceT."Customer No." := TempEntrySummaryT."Customer No.";
                QCTempComplianceT."Version Code" := TempEntrySummaryT."Version Code";
                QCTempComplianceT."Lower Limit" := QSpecLineT."Lower Limit";
                QCTempComplianceT."Upper Limit" := QSpecLineT."Upper Limit";
                QCTempComplianceT."Nominal Value" := QSpecLineT."Nominal Value";
                QCTempComplianceT."Non Compliance" := false;
                QCTempComplianceT."Actual Value" := 0;

                //Get test record - with customer no.
                QLotTestLineT.SETRANGE("Item No.", TempEntrySummaryT."Item No.");
                if TempEntrySummaryT."Lot No." <> '' then
                    QLotTestLineT.SETRANGE("Lot No./Serial No.", TempEntrySummaryT."Lot No.")
                else
                    QLotTestLineT.SETRANGE("Lot No./Serial No.", TempEntrySummaryT."Serial No.");

                QLotTestLineT.SETRANGE("Quality Measure", QSpecLineT."Quality Measure");
                //    QLotTestLineT.SETRANGE("Test Status",QLotTestLineT."Test Status"::"In-Process");  //QC71.1 REM-Out - Need to Re-Think
                //QC4SP1.2
                QLotTestLineT.SETRANGE("Customer No.", TempEntrySummaryT."Customer No.");
                //
                if QLotTestLineT.FIND('+') then begin
                    QCTempComplianceT."Actual Value" := QLotTestLineT."Actual Measure";
                    //QC4.30
                    QCTempComplianceT.Result := QLotTestLineT.Result;
                    QCTempComplianceT."Result Type" := QLotTestLineT."Result Type";
                    //
                    if QLotTestLineT."Non-Conformance" = true then
                        QCTempComplianceT."Non Compliance" := true;
                    QCTempComplianceT."Test Line Complete" := QLotTestLineT."Test Line Complete"; //QC80.1 Line Added

                end else begin
                    //QC4SP1.2
                    //Get test record - without customer no.
                    QLotTestLineT.SETRANGE("Item No.", TempEntrySummaryT."Item No.");
                    if TempEntrySummaryT."Lot No." <> '' then
                        QLotTestLineT.SETRANGE("Lot No./Serial No.", TempEntrySummaryT."Lot No.")
                    else
                        QLotTestLineT.SETRANGE("Lot No./Serial No.", TempEntrySummaryT."Serial No.");

                    QLotTestLineT.SETRANGE("Quality Measure", QSpecLineT."Quality Measure");
                    //      QLotTestLineT.SETRANGE("Test Status",QLotTestLineT."Test Status"::"In-Process"); //QC71.1 REM-Out - Need to Re-Think this
                    //QC4SP1.2
                    QLotTestLineT.SETFILTER("Customer No.", '%1', '');
                    //
                    if QLotTestLineT.FIND('+') then begin
                        QCTempComplianceT."Actual Value" := QLotTestLineT."Actual Measure";
                        //QC4.30
                        QCTempComplianceT.Result := QLotTestLineT.Result;
                        QCTempComplianceT."Result Type" := QLotTestLineT."Result Type";
                        //
                        if QLotTestLineT."Non-Conformance" = true then
                            QCTempComplianceT."Non Compliance" := true;
                        QCTempComplianceT."Test Line Complete" := QLotTestLineT."Test Line Complete"; //QC80.1 Line Added

                    end else begin
                        //QC4SP1.2 - Test not found for a spec
                        QCTempComplianceT."Non Compliance" := true;
                        QCTempComplianceT.Description := 'TEST NOT FOUND';
                        //
                    end;
                end;

                //IF QSpecLineT.Display THEN
                if (QCTempComplianceT."Actual Value" <> 0) or
                   (QLotTestLineT.Result <> '') or                //QC4.30
                   (QCTempComplianceT."Test Line Complete" = true) or //QC80.1 Added
                   (QCTempComplianceT.Description = 'TEST NOT FOUND') then   //QC4SP1.2
                    QCTempComplianceT.INSERT;

            until QSpecLineT.NEXT = 0;

        QCTempComplianceT.SETRANGE("Item No.", TempEntrySummaryT."Item No.");
        //IF QCTempComplianceT.FIND('-') THEN
        PAGE.RUN(PAGE::QualityComplianceView_PQ, QCTempComplianceT);
    end;

    procedure TestGetCustSpecs2(var QCTestHeader: Record QualityTestHeader_PQ; VersionCode: Code[20]; SpecificationNo: Code[20]; GetAllSpecs: Boolean);
    var
        QCTestLinesT: Record QualityTestLines_PQ;
        QCTestLineCommentT: Record QCTestLineComment_PQ;
        FromQCSpecLinesT: Record QCSpecificationLine_PQ;
        ToQCTestLinesT: Record QualityTestLines_PQ;
        FromSpecLinesCommentT: Record QCLinesCommentLine_PQ;
        ToTestLinesCommentT: Record QCTestLineComment_PQ;
        QualitySpecHeader: Record QCSpecificationHeader_PQ;
        TempQCTestLinesT: Record QualityTestLines_PQ temporary;
        "--NP1--": Integer;
        TempQCTestHeader: Record QualityTestHeader_PQ;
        TempCustomQCTestLines: Record QualityTestLines_PQ temporary;
        LineNo: Integer;
        FoundLine: Boolean;
    begin
        //QC71.1 Start
        TempQCTestHeader := QCTestHeader; //Preserve Incoming Record so that "Test Status" doesn't get scrogged
        //QC71.1 Finish

        //QC6.1.1 START
        //IF QCTestHeader."Test Status" = QCTestHeader."Test Status"::"In-Process" THEN //QC7.4
        if QCTestHeader."Test Status" <> QCTestHeader."Test Status"::New then //QC7.4
            ERROR(Text004);
        //QC6.1.1 FINISH
        //QC4SP1.2
        QCTestLinesT.SETRANGE("Test No.", QCTestHeader."Test No.");
        QCTestLinesT.SETRANGE("Custom Test", false); //QC71.1
        //QC6.1.1 START
        TempQCTestLinesT.DELETEALL;
        if QCTestLinesT.FINDSET then
            repeat
                TempQCTestLinesT := QCTestLinesT;
                TempQCTestLinesT.INSERT;
                QCTestLinesT.DELETE;
            until QCTestLinesT.NEXT = 0;
        //QCTestLinesT.DELETEALL;
        //QC6.1.1 FINISH

        //QC71.1 Start
        QCTestLinesT.SETRANGE("Custom Test", true); //Get ready to remember the Custom Test Lines
        TempCustomQCTestLines.RESET;
        TempCustomQCTestLines.DELETEALL;
        QCTestLinesT.SETRANGE("Custom Test", true);
        if QCTestLinesT.FINDSET then
            repeat
                TempCustomQCTestLines := QCTestLinesT;
                TempCustomQCTestLines.INSERT(false); //Remember "Custom Tests" (Will be inserted/added to existing Lines)
                QCTestLinesT.DELETE;
            until QCTestLinesT.NEXT = 0;
        LineNo := 10000;
        QCTestLinesT.SETRANGE("Custom Test", false); //Only Process the NON-"Custom" Lines
        //QC71.1 Finish


        QCTestLineCommentT.SETRANGE("Test No.", QCTestHeader."Test No.");
        QCTestLineCommentT.DELETEALL;

        FromQCSpecLinesT.SETRANGE("Item No.", QCTestHeader."Item No.");
        FromQCSpecLinesT.SETRANGE("Customer No.", QCTestHeader."Customer No.");
        FromQCSpecLinesT.SETRANGE(Type, SpecificationNo);
        FromQCSpecLinesT.SETRANGE("Version Code", VersionCode);

        //QC71.1 Start
        if not GetAllSpecs then
            FromQCSpecLinesT.SETRANGE(Mandatory, true); //Only Get Specs that are "Mandatory" if NOT "Bet All"
        //QC71.1 Finish

        //QC6.1.1 START
        //FromQCSpecLinesT.SETRANGE(Display,TRUE);
        //QC6.1.1 FINISH
        if not FromQCSpecLinesT.FIND('-') then
            ERROR(Text003)
        else
            repeat
                //QC6.1.1 START
                if (QualitySpecHeader.GET(FromQCSpecLinesT."Item No.", FromQCSpecLinesT."Customer No.", FromQCSpecLinesT.Type)) and
                   (QualitySpecHeader.Status <> QualitySpecHeader.Status::Certified) then
                    ERROR(Text005, FromQCSpecLinesT."Item No.", QualitySpecHeader.Status::Certified);
                //QC6.1.1 FINISH

                ToQCTestLinesT.INIT;
                ToQCTestLinesT."Test No." := QCTestHeader."Test No.";
                ToQCTestLinesT."Line No." := FromQCSpecLinesT."Line No.";
                ToQCTestLinesT."Item No." := QCTestHeader."Item No.";
                ToQCTestLinesT."Lot No./Serial No." := QCTestHeader."Lot No./Serial No.";
                ToQCTestLinesT."Lot No." := QCTestHeader."Lot No.";
                ToQCTestLinesT."Serial No." := QCTestHeader."Serial No.";
                //QC4SP1.2
                ToQCTestLinesT."Customer No." := QCTestHeader."Customer No.";
                //
                ToQCTestLinesT."Test Date" := QCTestHeader."Test Start Date";
                ToQCTestLinesT."Test Time" := QCTestHeader."Test Start Time";
                ToQCTestLinesT."Test Qty" := QCTestHeader."Test Qty";
                ToQCTestLinesT."Unit of Measure" := QCTestHeader."Unit of Measure";
                ToQCTestLinesT."Tested By" := QCTestHeader."Tested By";
                ToQCTestLinesT."Entered By" := USERID;
                ToQCTestLinesT."Test Status" := QCTestHeader."Test Status";
                ToQCTestLinesT."Quality Measure" := FromQCSpecLinesT."Quality Measure";
                ToQCTestLinesT."Measure Description" := FromQCSpecLinesT."Measure Description";
                ToQCTestLinesT."Lower Limit" := FromQCSpecLinesT."Lower Limit";
                ToQCTestLinesT."Upper Limit" := FromQCSpecLinesT."Upper Limit";
                ToQCTestLinesT."Nominal Value" := FromQCSpecLinesT."Nominal Value";
                ToQCTestLinesT."Testing UOM" := FromQCSpecLinesT."Testing UOM";
                ToQCTestLinesT.Display := FromQCSpecLinesT.Display;
                ToQCTestLinesT.Method := FromQCSpecLinesT.Method;
                ToQCTestLinesT."Method Description" := FromQCSpecLinesT."Method Description";
                ToQCTestLinesT."Version Code" := VersionCode;
                ToQCTestLinesT.Standart := FromQCSpecLinesT.Standart;
                ToQCTestLinesT."Sampling to" := FromQCSpecLinesT."Sampling to";
                ToQCTestLinesT."Display Report Seq." := FromQCSpecLinesT."Display Report Seq.";
                ToQCTestLinesT.IsInteger := FromQCSpecLinesT.IsInteger;
                //QC4.30
                ToQCTestLinesT."Result Type" := FromQCSpecLinesT."Result Type";
                //ToQCTestLinesT."Actual Measure"   ...manually entered
                //ToQCTestLinesT."Non-Conformance"  ...triggered with Actual measure entry
                //ToQCTestLinesT."Date Inspected"   ...triggered with Actual measure entry
                //ToQCTestLinesT."Time Inspected"   ...triggered with Actual measure entry

                //QC7.3 Start
                ToQCTestLinesT."UOM Description" := FromQCSpecLinesT."UOM Description";
                ToQCTestLinesT.Conditions := FromQCSpecLinesT.Conditions; //Copy new Fields
                                                                          //QC7.3 Finish

                //QC71.1 Start - Copy New Fields
                //    ToQCTestLinesT."Frequency Code" := FromQCSpecLinesT."Frequency Code";
                ToQCTestLinesT."Last Test Date" := FromQCSpecLinesT."Last Test Date";
                //    ToQCTestLinesT."Next Test Date" := FromQCSpecLinesT."Next Test Date";
                ToQCTestLinesT."Outside Testing" := FromQCSpecLinesT."Outside Testing";
                ToQCTestLinesT.Mandatory := FromQCSpecLinesT.Mandatory;
                //QC71.1 Finish

                //QC6.1.1 START
                TempQCTestLinesT.SETRANGE("Test No.", ToQCTestLinesT."Test No.");
                TempQCTestLinesT.SETRANGE("Item No.", ToQCTestLinesT."Item No.");
                TempQCTestLinesT.SETRANGE("Lot No./Serial No.", ToQCTestLinesT."Lot No./Serial No.");
                TempQCTestLinesT.SETRANGE("Quality Measure", ToQCTestLinesT."Quality Measure");
                TempQCTestLinesT.SETRANGE("Lower Limit", ToQCTestLinesT."Lower Limit");
                TempQCTestLinesT.SETRANGE("Upper Limit", ToQCTestLinesT."Upper Limit");

                //QC71.1 Start
                TempQCTestLinesT.SETRANGE("Customer No.", ToQCTestLinesT."Customer No.");
                TempQCTestLinesT.SETRANGE(Conditions, ToQCTestLinesT.Conditions);
                TempQCTestLinesT.SETRANGE(Method, ToQCTestLinesT.Method);
                TempQCTestLinesT.SETRANGE("Custom Test", ToQCTestLinesT."Custom Test");
                //QC71.1 Finish

                FoundLine := false; //QC71.1 Added
                if TempQCTestLinesT.FINDFIRST then begin
                    FoundLine := true; //QC71.1 Added
                    if (ToQCTestLinesT."Result Type" = ToQCTestLinesT."Result Type"::List) and (TempQCTestLinesT.Result <> '') then   //QC71.1
                        ToQCTestLinesT.VALIDATE(Result, TempQCTestLinesT.Result)
                    else
                        if ((TempQCTestLinesT."Actual Measure" <> 0) or (TempQCTestLinesT."Test Line Complete" = true)) then         //QC71.1 and QC80.1
                            ToQCTestLinesT.VALIDATE("Actual Measure", TempQCTestLinesT."Actual Measure");
                    ToQCTestLinesT."Date Inspected" := TempQCTestLinesT."Date Inspected";
                    ToQCTestLinesT."Time Inspected" := TempQCTestLinesT."Time Inspected";
                    ToQCTestLinesT."Optional Display Prefix" := TempQCTestLinesT."Optional Display Prefix";
                    ToQCTestLinesT."Optional Display Value" := TempQCTestLinesT."Optional Display Value";
                end;
                //QC6.1.1 FINISH

                if VersionCode = '' then begin
                    FromSpecLinesCommentT.SETRANGE("Table Name", FromSpecLinesCommentT."Table Name"::"QC Lines");
                    FromSpecLinesCommentT.SETRANGE("Item No.", QCTestHeader."Item No.");
                    FromSpecLinesCommentT.SETRANGE("Customer No.", QCTestHeader."Customer No.");
                    FromSpecLinesCommentT.SETRANGE(Type, SpecificationNo);
                    FromSpecLinesCommentT.SETRANGE("QC Line No.", FromQCSpecLinesT."Line No.");
                    if FromSpecLinesCommentT.FIND('-') then
                        repeat
                            ToTestLinesCommentT.INIT;
                            ToTestLinesCommentT."Test No." := QCTestHeader."Test No.";
                            ToTestLinesCommentT."Test Line" := ToQCTestLinesT."Line No.";
                            ToTestLinesCommentT."Line No." := FromSpecLinesCommentT."Line No.";
                            ToTestLinesCommentT.Date := FromSpecLinesCommentT.Date;
                            ToTestLinesCommentT."Entered By" := USERID;
                            ToTestLinesCommentT.Comment := FromSpecLinesCommentT.Comment;
                            ToTestLinesCommentT.Code := FromSpecLinesCommentT.Code;
                            ToTestLinesCommentT.INSERT;
                        until FromSpecLinesCommentT.NEXT = 0;
                end else begin
                    //       QCTestHeader := TempQCTestHeader; //QC71.1 - Restore Record from "Backup"
                    QCTestHeader."Test Status" := QCTestHeader."Test Status"::New; //QC71.1
                    QCTestHeader."Spec Version Used" := VersionCode;
                    QCTestHeader.MODIFY;

                    FromSpecLinesCommentT.SETRANGE("Table Name", FromSpecLinesCommentT."Table Name"::"QC Lines");
                    FromSpecLinesCommentT.SETRANGE("Item No.", QCTestHeader."Item No.");
                    FromSpecLinesCommentT.SETRANGE("Customer No.", QCTestHeader."Customer No.");
                    FromSpecLinesCommentT.SETRANGE(Type, SpecificationNo);
                    FromSpecLinesCommentT.SETRANGE("Version Code", VersionCode);
                    FromSpecLinesCommentT.SETRANGE("QC Line No.", FromQCSpecLinesT."Line No.");
                    if FromSpecLinesCommentT.FIND('-') then
                        repeat
                            ToTestLinesCommentT.INIT;
                            ToTestLinesCommentT."Test No." := QCTestHeader."Test No.";
                            ToTestLinesCommentT."Test Line" := ToQCTestLinesT."Line No.";
                            ToTestLinesCommentT."Line No." := FromSpecLinesCommentT."Line No.";
                            ToTestLinesCommentT.Date := FromSpecLinesCommentT.Date;
                            ToTestLinesCommentT."Entered By" := USERID;
                            ToTestLinesCommentT.Comment := FromSpecLinesCommentT.Comment;
                            ToTestLinesCommentT.Code := FromSpecLinesCommentT.Code;
                            ToTestLinesCommentT.INSERT;
                        until FromSpecLinesCommentT.NEXT = 0;
                end;
                TestGetCustSpecs2OnBeforeInsertQCTestLines(ToQCTestLinesT, FromQCSpecLinesT);
                ToQCTestLinesT.INSERT;

            until FromQCSpecLinesT.NEXT = 0;

        //QC71.1 Start - Add/Insert the "Custom Test" Lines we squirreled away...
        LineNo := 0;
        if ToQCTestLinesT.FINDLAST then
            LineNo := ToQCTestLinesT."Line No."; //Find Last Line No.
        LineNo := LineNo + 10000;
        if TempCustomQCTestLines.FINDSET then
            repeat
                ToQCTestLinesT.SETFILTER("Line No.", '<=%1', TempCustomQCTestLines."Line No.");
                if ToQCTestLinesT.FIND('+') then
                    LineNo := ToQCTestLinesT."Line No." + 10
                else begin
                    ToQCTestLinesT.SETRANGE("Line No.");
                    LineNo := 10000;
                    if ToQCTestLinesT.FIND('+') then
                        LineNo := ToQCTestLinesT."Line No." + 129; //Place after Last Line
                end;
                ToQCTestLinesT := TempCustomQCTestLines;
                ToQCTestLinesT."Line No." := LineNo;
                LineNo := LineNo + 10000;
                ToQCTestLinesT.INSERT(false); //Add "Custom Tests" to the other Tests
            until TempCustomQCTestLines.NEXT = 0;
        //QC71.1 Finish
    end;

    procedure TestGetCustSpecs(var QCTestHeader: Record QualityTestHeader_PQ; VersionCode: Code[20]; GetAllSpecs: Boolean);
    var
        QCTestLinesT: Record QualityTestLines_PQ;
        QCTestLineCommentT: Record QCTestLineComment_PQ;
        FromQCSpecLinesT: Record QCSpecificationLine_PQ;
        ToQCTestLinesT: Record QualityTestLines_PQ;
        FromSpecLinesCommentT: Record QCLinesCommentLine_PQ;
        ToTestLinesCommentT: Record QCTestLineComment_PQ;
        QualitySpecHeader: Record QCSpecificationHeader_PQ;
        TempQCTestLinesT: Record QualityTestLines_PQ temporary;
        "--NP1--": Integer;
        TempQCTestHeader: Record QualityTestHeader_PQ;
        TempCustomQCTestLines: Record QualityTestLines_PQ temporary;
        LineNo: Integer;
        FoundLine: Boolean;
    begin
        //QC71.1 Start
        TempQCTestHeader := QCTestHeader; //Preserve Incoming Record so that "Test Status" doesn't get scrogged
        //QC71.1 Finish

        //QC6.1.1 START
        //IF QCTestHeader."Test Status" = QCTestHeader."Test Status"::"In-Process" THEN //QC7.4
        if QCTestHeader."Test Status" <> QCTestHeader."Test Status"::New then //QC7.4
            ERROR(Text004);
        //QC6.1.1 FINISH
        //QC4SP1.2
        QCTestLinesT.SETRANGE("Test No.", QCTestHeader."Test No.");
        QCTestLinesT.SETRANGE("Custom Test", false); //QC71.1
        //QC6.1.1 START
        TempQCTestLinesT.DELETEALL;
        if QCTestLinesT.FINDSET then
            repeat
                TempQCTestLinesT := QCTestLinesT;
                TempQCTestLinesT.INSERT;
                QCTestLinesT.DELETE;
            until QCTestLinesT.NEXT = 0;
        //QCTestLinesT.DELETEALL;
        //QC6.1.1 FINISH

        //QC71.1 Start
        QCTestLinesT.SETRANGE("Custom Test", true); //Get ready to remember the Custom Test Lines
        TempCustomQCTestLines.RESET;
        TempCustomQCTestLines.DELETEALL;
        QCTestLinesT.SETRANGE("Custom Test", true);
        if QCTestLinesT.FINDSET then
            repeat
                TempCustomQCTestLines := QCTestLinesT;
                TempCustomQCTestLines.INSERT(false); //Remember "Custom Tests" (Will be inserted/added to existing Lines)
                QCTestLinesT.DELETE;
            until QCTestLinesT.NEXT = 0;
        LineNo := 10000;
        QCTestLinesT.SETRANGE("Custom Test", false); //Only Process the NON-"Custom" Lines
        //QC71.1 Finish


        QCTestLineCommentT.SETRANGE("Test No.", QCTestHeader."Test No.");
        QCTestLineCommentT.DELETEALL;

        FromQCSpecLinesT.SETRANGE("Item No.", QCTestHeader."Item No.");
        FromQCSpecLinesT.SETRANGE("Customer No.", QCTestHeader."Customer No.");
        FromQCSpecLinesT.SETRANGE(Type, '');
        FromQCSpecLinesT.SETRANGE("Version Code", VersionCode);

        //QC71.1 Start
        if not GetAllSpecs then
            FromQCSpecLinesT.SETRANGE(Mandatory, true); //Only Get Specs that are "Mandatory" if NOT "Bet All"
        //QC71.1 Finish

        //QC6.1.1 START
        //FromQCSpecLinesT.SETRANGE(Display,TRUE);
        //QC6.1.1 FINISH
        if not FromQCSpecLinesT.FIND('-') then
            ERROR(Text003)
        else
            repeat
                //QC6.1.1 START
                if (QualitySpecHeader.GET(FromQCSpecLinesT."Item No.", FromQCSpecLinesT."Customer No.", FromQCSpecLinesT.Type)) and
                   (QualitySpecHeader.Status <> QualitySpecHeader.Status::Certified) then
                    ERROR(Text005, FromQCSpecLinesT."Item No.", QualitySpecHeader.Status::Certified);
                //QC6.1.1 FINISH

                ToQCTestLinesT.INIT;
                ToQCTestLinesT."Test No." := QCTestHeader."Test No.";
                ToQCTestLinesT."Line No." := FromQCSpecLinesT."Line No.";
                ToQCTestLinesT."Item No." := QCTestHeader."Item No.";
                ToQCTestLinesT."Lot No./Serial No." := QCTestHeader."Lot No./Serial No.";
                //QC4SP1.2
                ToQCTestLinesT."Customer No." := QCTestHeader."Customer No.";
                //
                ToQCTestLinesT."Test Date" := QCTestHeader."Test Start Date";
                ToQCTestLinesT."Test Time" := QCTestHeader."Test Start Time";
                ToQCTestLinesT."Test Qty" := QCTestHeader."Test Qty";
                ToQCTestLinesT."Unit of Measure" := QCTestHeader."Unit of Measure";
                ToQCTestLinesT."Tested By" := QCTestHeader."Tested By";
                ToQCTestLinesT."Entered By" := USERID;
                ToQCTestLinesT."Test Status" := QCTestHeader."Test Status";
                ToQCTestLinesT."Quality Measure" := FromQCSpecLinesT."Quality Measure";
                ToQCTestLinesT."Measure Description" := FromQCSpecLinesT."Measure Description";
                ToQCTestLinesT."Lower Limit" := FromQCSpecLinesT."Lower Limit";
                ToQCTestLinesT."Upper Limit" := FromQCSpecLinesT."Upper Limit";
                ToQCTestLinesT."Nominal Value" := FromQCSpecLinesT."Nominal Value";
                ToQCTestLinesT."Testing UOM" := FromQCSpecLinesT."Testing UOM";
                ToQCTestLinesT.Display := FromQCSpecLinesT.Display;
                ToQCTestLinesT.Method := FromQCSpecLinesT.Method;
                ToQCTestLinesT."Method Description" := FromQCSpecLinesT."Method Description";
                ToQCTestLinesT."Version Code" := VersionCode;
                ToQCTestLinesT.Standart := FromQCSpecLinesT.Standart;
                ToQCTestLinesT."Sampling to" := FromQCSpecLinesT."Sampling to";
                ToQCTestLinesT."Display Report Seq." := FromQCSpecLinesT."Display Report Seq.";
                ToQCTestLinesT.IsInteger := FromQCSpecLinesT.IsInteger;
                //QC4.30
                ToQCTestLinesT."Result Type" := FromQCSpecLinesT."Result Type";
                //ToQCTestLinesT."Actual Measure"   ...manually entered
                //ToQCTestLinesT."Non-Conformance"  ...triggered with Actual measure entry
                //ToQCTestLinesT."Date Inspected"   ...triggered with Actual measure entry
                //ToQCTestLinesT."Time Inspected"   ...triggered with Actual measure entry

                //QC7.3 Start
                ToQCTestLinesT."UOM Description" := FromQCSpecLinesT."UOM Description";
                ToQCTestLinesT.Conditions := FromQCSpecLinesT.Conditions; //Copy new Fields
                                                                          //QC7.3 Finish

                //QC71.1 Start - Copy New Fields
                //    ToQCTestLinesT."Frequency Code" := FromQCSpecLinesT."Frequency Code";
                ToQCTestLinesT."Last Test Date" := FromQCSpecLinesT."Last Test Date";
                //    ToQCTestLinesT."Next Test Date" := FromQCSpecLinesT."Next Test Date";
                ToQCTestLinesT."Outside Testing" := FromQCSpecLinesT."Outside Testing";
                ToQCTestLinesT.Mandatory := FromQCSpecLinesT.Mandatory;
                //QC71.1 Finish

                //QC6.1.1 START
                TempQCTestLinesT.SETRANGE("Test No.", ToQCTestLinesT."Test No.");
                TempQCTestLinesT.SETRANGE("Item No.", ToQCTestLinesT."Item No.");
                TempQCTestLinesT.SETRANGE("Lot No./Serial No.", ToQCTestLinesT."Lot No./Serial No.");
                TempQCTestLinesT.SETRANGE("Quality Measure", ToQCTestLinesT."Quality Measure");
                TempQCTestLinesT.SETRANGE("Lower Limit", ToQCTestLinesT."Lower Limit");
                TempQCTestLinesT.SETRANGE("Upper Limit", ToQCTestLinesT."Upper Limit");

                //QC71.1 Start
                TempQCTestLinesT.SETRANGE("Customer No.", ToQCTestLinesT."Customer No.");
                TempQCTestLinesT.SETRANGE(Conditions, ToQCTestLinesT.Conditions);
                TempQCTestLinesT.SETRANGE(Method, ToQCTestLinesT.Method);
                TempQCTestLinesT.SETRANGE("Custom Test", ToQCTestLinesT."Custom Test");
                //QC71.1 Finish

                FoundLine := false; //QC71.1 Added
                if TempQCTestLinesT.FINDFIRST then begin
                    FoundLine := true; //QC71.1 Added
                    if (ToQCTestLinesT."Result Type" = ToQCTestLinesT."Result Type"::List) and (TempQCTestLinesT.Result <> '') then   //QC71.1
                        ToQCTestLinesT.VALIDATE(Result, TempQCTestLinesT.Result)
                    else
                        if ((TempQCTestLinesT."Actual Measure" <> 0) or (TempQCTestLinesT."Test Line Complete" = true)) then         //QC71.1 and QC80.1
                            ToQCTestLinesT.VALIDATE("Actual Measure", TempQCTestLinesT."Actual Measure");
                    ToQCTestLinesT."Date Inspected" := TempQCTestLinesT."Date Inspected";
                    ToQCTestLinesT."Time Inspected" := TempQCTestLinesT."Time Inspected";
                    ToQCTestLinesT."Optional Display Prefix" := TempQCTestLinesT."Optional Display Prefix";
                    ToQCTestLinesT."Optional Display Value" := TempQCTestLinesT."Optional Display Value";
                end;
                //QC6.1.1 FINISH

                if VersionCode = '' then begin
                    FromSpecLinesCommentT.SETRANGE("Table Name", FromSpecLinesCommentT."Table Name"::"QC Lines");
                    FromSpecLinesCommentT.SETRANGE("Item No.", QCTestHeader."Item No.");
                    FromSpecLinesCommentT.SETRANGE("Customer No.", QCTestHeader."Customer No.");
                    FromSpecLinesCommentT.SETRANGE(Type, '');
                    FromSpecLinesCommentT.SETRANGE("QC Line No.", FromQCSpecLinesT."Line No.");
                    if FromSpecLinesCommentT.FIND('-') then
                        repeat
                            ToTestLinesCommentT.INIT;
                            ToTestLinesCommentT."Test No." := QCTestHeader."Test No.";
                            ToTestLinesCommentT."Test Line" := ToQCTestLinesT."Line No.";
                            ToTestLinesCommentT."Line No." := FromSpecLinesCommentT."Line No.";
                            ToTestLinesCommentT.Date := FromSpecLinesCommentT.Date;
                            ToTestLinesCommentT."Entered By" := USERID;
                            ToTestLinesCommentT.Comment := FromSpecLinesCommentT.Comment;
                            ToTestLinesCommentT.Code := FromSpecLinesCommentT.Code;
                            ToTestLinesCommentT.INSERT;
                        until FromSpecLinesCommentT.NEXT = 0;
                end else begin
                    //       QCTestHeader := TempQCTestHeader; //QC71.1 - Restore Record from "Backup"
                    QCTestHeader."Test Status" := QCTestHeader."Test Status"::New; //QC71.1
                    QCTestHeader."Spec Version Used" := VersionCode;
                    QCTestHeader.MODIFY;

                    FromSpecLinesCommentT.SETRANGE("Table Name", FromSpecLinesCommentT."Table Name"::"QC Lines");
                    FromSpecLinesCommentT.SETRANGE("Item No.", QCTestHeader."Item No.");
                    FromSpecLinesCommentT.SETRANGE("Customer No.", QCTestHeader."Customer No.");
                    FromSpecLinesCommentT.SETRANGE(Type, '');
                    FromSpecLinesCommentT.SETRANGE("Version Code", VersionCode);
                    FromSpecLinesCommentT.SETRANGE("QC Line No.", FromQCSpecLinesT."Line No.");
                    if FromSpecLinesCommentT.FIND('-') then
                        repeat
                            ToTestLinesCommentT.INIT;
                            ToTestLinesCommentT."Test No." := QCTestHeader."Test No.";
                            ToTestLinesCommentT."Test Line" := ToQCTestLinesT."Line No.";
                            ToTestLinesCommentT."Line No." := FromSpecLinesCommentT."Line No.";
                            ToTestLinesCommentT.Date := FromSpecLinesCommentT.Date;
                            ToTestLinesCommentT."Entered By" := USERID;
                            ToTestLinesCommentT.Comment := FromSpecLinesCommentT.Comment;
                            ToTestLinesCommentT.Code := FromSpecLinesCommentT.Code;
                            ToTestLinesCommentT.INSERT;
                        until FromSpecLinesCommentT.NEXT = 0;
                end;
                ToQCTestLinesT.INSERT;

            until FromQCSpecLinesT.NEXT = 0;

        //QC71.1 Start - Add/Insert the "Custom Test" Lines we squirreled away...
        LineNo := 0;
        if ToQCTestLinesT.FINDLAST then
            LineNo := ToQCTestLinesT."Line No."; //Find Last Line No.
        LineNo := LineNo + 10000;
        if TempCustomQCTestLines.FINDSET then
            repeat
                ToQCTestLinesT.SETFILTER("Line No.", '<=%1', TempCustomQCTestLines."Line No.");
                if ToQCTestLinesT.FIND('+') then
                    LineNo := ToQCTestLinesT."Line No." + 10
                else begin
                    ToQCTestLinesT.SETRANGE("Line No.");
                    LineNo := 10000;
                    if ToQCTestLinesT.FIND('+') then
                        LineNo := ToQCTestLinesT."Line No." + 129; //Place after Last Line
                end;
                ToQCTestLinesT := TempCustomQCTestLines;
                ToQCTestLinesT."Line No." := LineNo;
                LineNo := LineNo + 10000;
                ToQCTestLinesT.INSERT(false); //Add "Custom Tests" to the other Tests
            until TempCustomQCTestLines.NEXT = 0;
        //QC71.1 Finish
    end;



    procedure "--QC71.1--"();
    begin
    end;

    procedure CalcNextTestDate(LastTestDate: Date; FrequencyCode: Integer) NextTestDate: Date;
    var
        LastMonth: Integer;
        LastYear: Integer;
        DateFormula: Text;
    begin
        //QC71.1 Added

        if FrequencyCode = 0 then
            exit(0D);
        if LastTestDate = 0D then
            LastTestDate := WORKDATE;
        DateFormula := FORMAT(FrequencyCode) + 'M';//Set to Add this many Months to Last Test Date
        LastMonth := DATE2DMY(LastTestDate, 2);
        LastYear := DATE2DMY(LastTestDate, 3);
        LastTestDate := DMY2DATE(1, LastMonth, LastYear); //Force 1st Day of Month for Last Test Date for Calc Purposes
        NextTestDate := CALCDATE(DateFormula, LastTestDate); //There's your Answer!
    end;

    procedure UpdateSpecNextTestDates(TestHeader: Record QualityTestHeader_PQ);
    var
        QCSetup: Record QCSetup_PQ;
        SpecHeader: Record QCSpecificationHeader_PQ;
        SpecLines: Record QCSpecificationLine_PQ;
        TestLines: Record QualityTestLines_PQ;
        LastDateToUse: Date;
        OkToRun: Boolean;
        FoundSpecHeader: Boolean;
        FoundSpecLine: Boolean;
    begin
        //QC71.1 -  Added to Update (If allowed) the "Last Test Date" and "Next Test Date" on the Spec Master from a particular Lot/SN Test
        //ALWAYS Uses the "Creation Date" (of the Test Header) for Calculations; but may send "Date Tested", or "Creation Date" back up to Spec Lines
        //QC Setup contains many "Switches" that control the behavior of this Function
        //Spec-Line to Test-Line "Matching" is based on "Quality Measure" & "Method" & "Conditions" & "Outside Testing", NOT the "Line No."
        //"Frequency Code" from the TEST Lines is used, because it COULD have been Edited.
        //"Ignore for Update" Test Lines are IGNORED (Filtered-out)

        TestHeader.TESTFIELD("Creation Date");

        //QC80.4 Start
        //LastDateToUse := TestHeader."Creation Date"; //Used for ALL Date Calculations
        LastDateToUse := WORKDATE;
        //QC80.4 Finish

        OkToRun := false; //Just in case...

        if QCSetup.GET then begin
            // if TestHeader."Test Status" = TestHeader."Test Status"::Certified then
            //     OkToRun := QCSetup."Update on Certified"
            // else
            //     if TestHeader."Test Status" = TestHeader."Test Status"::"Certified with Waiver" then
            //         OkToRun := QCSetup."Update on Cert with Waiver"
            //     else
            //         if TestHeader."Test Status" = TestHeader."Test Status"::"Certified Final" then
            //             OkToRun := QCSetup."Update on Certified Final"; //Decide if we can Run this Function on this Status

            // Always update "Last Test Date" considering any Certified status
            if TestHeader."Test Status" in [TestHeader."Test Status"::Certified] then
                OkToRun := true;

            SpecHeader.SETRANGE("Item No.", TestHeader."Item No.");
            SpecHeader.SETRANGE("Customer No.", TestHeader."Customer No.");
            SpecHeader.SETRANGE(Type, TestHeader."Specification Type");
            if SpecHeader.FINDFIRST then begin //IS there a Specification "Master"?
                if OkToRun then begin //...Off we go!!!
                    TestLines.SETRANGE("Test No.", TestHeader."Test No.");
                    TestLines.SETRANGE("Ignore for Update", false); //Filter-out "Ignored" Tests (Usually "Custom Tests")
                    TestLines.SETRANGE(TestLines."Test Line Complete", true); //...Only Update "Completed" Lines!!!
                    if TestLines.FINDSET then
                        repeat
                            SpecLines.RESET;
                            SpecLines.SETRANGE("Item No.", TestHeader."Item No.");
                            SpecLines.SETRANGE("Customer No.", TestHeader."Customer No.");
                            SpecLines.SETRANGE("Quality Measure", TestLines."Quality Measure");
                            SpecLines.SETRANGE(Method, TestLines.Method);
                            SpecLines.SETRANGE(Conditions, TestLines.Conditions);
                            SpecLines.SETRANGE(SpecLines."Outside Testing", TestLines."Outside Testing");
                            if SpecLines.FINDFIRST then begin
                                //          SpecLines."Next Test Date" := CalcNextTestDate(LastDateToUse,TestLines."Frequency Code");

                                // This option has been disabled
                                // if QCSetup."Update Actual Last Test Dates" then
                                // -----------------------------
                                if true then
                                    SpecLines."Last Test Date" := TestLines."Date Inspected" //Update with the Actual Testing Date
                                else
                                    SpecLines."Last Test Date" := LastDateToUse; //Else, use the Expected Blend Date
                                SpecLines.MODIFY; //Make it so...
                            end;
                        until TestLines.NEXT = 0;
                end;
            end;
        end; //End of QCSetup GET...
    end;

    procedure TestQCMgr() UserIsQCMgr: Boolean;
    var
        UserSetup: Record "User Setup";
    begin
        //QC71.1 - Function Added to Determine if the User is a "Quality Manager" in User Setup table
        //  Controls the Editing of Several Test Line Fields as well as whether a Test Status can be Changed

        UserIsQCMgr := false;
        if UserSetup.GET(USERID) then begin
            UserIsQCMgr := UserSetup."CCS Quality Manager";
        end;
    end;

    local procedure "--QC11.01-"();
    begin
    end;

    procedure ItemJnlPosLineCheckItemTrackingHandleLotNoSerialNo(var ItemJnlLine: Record "Item Journal Line");
    var
        QCSetup: Record QCSetup_PQ;
        QCSpecT: Record QCSpecificationHeader_PQ;
        QCTestT: Record QualityTestHeader_PQ;
        SerialNoRequiredErr: Label 'You must assign a serial number for item %1.', Comment = '%1 - Item No.';
        LotNoRequiredErr: Label 'You must assign a lot number for item %1.', Comment = '%1 - Item No.';
        ActiveVer: Code[20];
        QCText000: Label 'Quality Test is Required and no test was found for Item %1 and Lot No. %2.';
        QCText002: Label 'Quality Test is Required and no Specification was found for Item %1 and Customer %2.';
        QCText003: Label 'Quality Test is Required and no test was found for Item %1 and Serial No. %2.';
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        //SNRequired: Boolean;
        //LotRequired: Boolean;
        //SNInfoRequired: Boolean;
        //LotInfoRequired: Boolean;
        ItemTrackingSetup: Record "Item Tracking Setup";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        SourceCodeSetup.Get;
        if ItemJnlLine."Source Code" = SourceCodeSetup."Revaluation Journal" then
            exit;
        //QC11.01 - Code and some Vars. moved here from Function "CheckItemTracking" in Codeunit 22

        //QC11.02 Start - Borrow some code and variables from CU 22 to set up this Call
        Item.GET(ItemJnlLine."Item No.");

        ItemTrackingCode.Code := Item."Item Tracking Code";
        // replaced by GetItemTrackingSetup
        //ItemTrackingMgt.GetItemTrackingSettings(
        //  ItemTrackingCode, ItemJnlLine."Entry Type", ItemJnlLine.Signed(ItemJnlLine."Quantity (Base)") > 0,
        //  SNRequired, LotRequired, SNInfoRequired, LotInfoRequired);
        ItemTrackingMgt.GetItemTrackingSetup(ItemTrackingCode, ItemJnlLine."Entry Type".AsInteger(), ItemJnlLine.Signed(ItemJnlLine."Quantity (Base)") > 0,
          ItemTrackingSetup);

        //QC11.02 Finish

        //new code for Lot No. Handling
        if (ItemTrackingSetup."Lot No. Required") and (not ItemJnlLine."Drop Shipment") and (ItemJnlLine.Quantity <> 0) and (ItemJnlLine."Item Charge No." = '') then begin
            if ItemJnlLine."Lot No." = '' then
                ERROR(GetTextStringWithLineNo(LotNoRequiredErr, ItemJnlLine."Item No.", ItemJnlLine."Line No."));
        end;
        //end Finish QC90 Lot No. Handling

        //new code for SN Handling
        if (ItemTrackingSetup."Serial No. Required") and (ItemJnlLine.Quantity <> 0) and (ItemJnlLine."Item Charge No." = '') then begin
            if ItemJnlLine."Serial No." = '' then
                ERROR(GetTextStringWithLineNo(SerialNoRequiredErr, ItemJnlLine."Item No.", ItemJnlLine."Line No."));
        end;   //end SN Handling - QC37.05
    end;

    local procedure GetTextStringWithLineNo(BasicTextString: Text; ItemNo: Code[20]; LineNo: Integer): Text;
    var
        LineNoTxt: Label ' Line No. = ''%1''.', Comment = '%1 - Line No.';
    begin
        //QC11.01 - Function copied here from Codeunit 22

        if LineNo = 0 then
            exit(STRSUBSTNO(BasicTextString, ItemNo));
        exit(STRSUBSTNO(BasicTextString, ItemNo) + STRSUBSTNO(LineNoTxt, LineNo));
    end;

    procedure ItemTrackingDataCollectionCreateEntrySummary2(var TrackingSpecification: Record "Tracking Specification" temporary; LookupMode: Option "Serial No.","Lot No."; var TempReservEntry: Record "Reservation Entry" temporary; var TempGlobalEntrySummary: Record "Entry Summary" temporary);
    var
        SalesLineT: Record "Sales Line";
        QSpecHeaderT: Record QCSpecificationHeader_PQ;
        ActiveVersionCode: Code[20];
        GetCompanySpec: Boolean;
        QSpecLineT: Record QCSpecificationLine_PQ;
        QLotTestLineT: Record QualityTestLines_PQ;
        ItemJnlLineT: Record "Item Journal Line";
        ItemT: Record Item;
        TransferLineT: Record "Transfer Line";
    begin
        //QC11.01 - Function and Local Vars Added. Moved here from Codeunit 6501, "CreateEntrySummry2" Function

        //QC Start - Begin HUGE Code Insersion that comes between 2 lines of Original NAV Code

        //QC
        GetCompanySpec := false;
        TempGlobalEntrySummary."QC Non Compliance" := false;
        TempGlobalEntrySummary."QC Compliance" := '';

        if TrackingSpecification."Source Type" = DATABASE::"Sales Line" then // Handle Sales-Line Source
            if SalesLineT.GET(TrackingSpecification."Source Subtype", TrackingSpecification."Source ID",
                              TrackingSpecification."Source Ref. No.")
            //Source Subtype = Document Type
            //Source ID      = Document No.
            //Source Ref. No.= Line No.
            then begin
                if ItemT.GET(TrackingSpecification."Item No.") then begin
                    ItemT.CALCFIELDS("Has Quality Specifications");
                    TempGlobalEntrySummary."QC Specs Exist" := ItemT."Has Quality Specifications"; //Set "QC Specs Exist"
                end;

                //- Customer or Company Spec??
                if QSpecHeaderT.GET(TrackingSpecification."Item No.",
                                    SalesLineT."Sell-to Customer No.", QSpecHeaderT.GetSpecNoFromNonOutputSpecification(TrackingSpecification."Item No.", SalesLineT."Sell-to Customer No.", '')) then begin
                    ActiveVersionCode := GetQCVersion(TrackingSpecification."Item No.",
                                         SalesLineT."Sell-to Customer No.", '',
                                         WORKDATE, 2);   //Origin = Salesline
                    if ActiveVersionCode = '' then
                        if QSpecHeaderT.Status <> QSpecHeaderT.Status::Certified then
                        //QC7.7 Start
                        begin
                            GetCompanySpec := true; //original line
                            TempGlobalEntrySummary."Cust Specs Exist" := true; //QC7.7 Added
                        end;
                    //QC7.7 Finish
                end else
                    GetCompanySpec := true;

                //QC7.7 Note - GetCompanySpec is part of the original QC-Related Logic in this Function. It relates to the (original) Cooked-Down "Compliance" Determination...
                // ...It is less-Relevant (but not completely so) with the addition of Function "FinalizeConformanceDecision" having the Final Say-So as to what ends up as...
                // ...the Cooked-Down "QC Non Compliance" Boolean and "QC Compliance" Text 'Results'

                //end- Customer or Company Spec??

                //QC7.7 Start - Not "Obeying" "GetCompanySpec" anymore. Need to look at BOTH Company (Item) AND Customer Specs and Tests!

                //IF GetCompanySpec THEN BEGIN
                begin
                    //QC7.7 Finish
                    ActiveVersionCode := GetQCVersion(TrackingSpecification."Item No.", '', '', WORKDATE, 2);   //Origin = SalesLine

                    QSpecLineT.SETRANGE("Item No.", TrackingSpecification."Item No.");
                    QSpecLineT.SETRANGE("Customer No.", '');
                    QSpecLineT.SETRANGE(Type, '');
                    QSpecLineT.SETRANGE("Version Code", ActiveVersionCode);
                    if QSpecLineT.FINDSET then //Found Item Spec
                        repeat
                            QLotTestLineT.SETRANGE("Item No.", TrackingSpecification."Item No.");
                            //QC37.05
                            if LookupMode = LookupMode::"Lot No." then
                                QLotTestLineT.SETRANGE("Lot No./Serial No.", TempReservEntry."Lot No.");
                            if LookupMode = LookupMode::"Serial No." then
                                QLotTestLineT.SETRANGE("Lot No./Serial No.", TempReservEntry."Serial No.");
                            //
                            QLotTestLineT.SETRANGE("Quality Measure", QSpecLineT."Quality Measure");
                            QLotTestLineT.SETRANGE("Test Status", QLotTestLineT."Test Status"::"Certified Final"); //QC80.1 Corrected "Test Status" value
                                                                                                                   //QC4SP1.2
                            QLotTestLineT.SETFILTER("Customer No.", '%1', '');
                            //

                            if QLotTestLineT.FINDLAST then begin
                                TempGlobalEntrySummary."QC Test Exists" := true;  //Set "QC Test Exists"
                                                                                  //QC80.1 - Added "Test Line Complete" term to line below
                                if ((QLotTestLineT."Actual Measure" <> 0) or (QLotTestLineT."Test Line Complete" = true)) then begin // Handle Numeric Test Line
                                    if QLotTestLineT."Non-Conformance" then begin
                                        TempGlobalEntrySummary."QC Non Compliance" := true;
                                        //QC7.7 Start
                                        TempGlobalEntrySummary."Item Test Non Compliant" := true; //Set new Field
                                                                                                  //TempGlobalEntrySummary."QC Compliance" := 'NO';
                                                                                                  //QC7.7 Finish
                                    end;
                                end else begin  // Handle 'Result List' Test Line
                                                //QC5.01 begin
                                    if QLotTestLineT.Result <> '' then begin
                                        if QLotTestLineT."Non-Conformance" then begin
                                            TempGlobalEntrySummary."QC Non Compliance" := true;
                                            //QC7.7 Start
                                            TempGlobalEntrySummary."Item Test Non Compliant" := true; //Set new Field
                                                                                                      //TempGlobalEntrySummary."QC Compliance" := 'NO';
                                                                                                      //QC7.7 Finish
                                        end;
                                    end;
                                end;
                                //QC5.01 end
                            end;
                        until QSpecLineT.NEXT = 0;

                    // new fields on Entry Summary table
                    TempGlobalEntrySummary."QC Option" := TempGlobalEntrySummary."QC Option"::Company;
                    TempGlobalEntrySummary."Item No." := TrackingSpecification."Item No.";
                    TempGlobalEntrySummary."Customer No." := '';
                    TempGlobalEntrySummary."Version Code" := ActiveVersionCode;

                    //End Sales Line Without Sell-To Customer (???) Processing (Just to set proper flags?)
                    //Now, Process Sales-Line "Call" WITH a Sell-To Customer No. (Normal?)

                    //QC7.7 Start - REMoved the "ELSE", so that we process BOTH Company AND Customer-Specific Specs and Tests
                    //END ELSE BEGIN     //get customer specific QC spec (GetCompanySpec = FALSE got us here...)
                end;
                begin //If NOT "Use Company Spec" ...
                      //QC7.7 Finish

                    //**
                    QSpecLineT.SETRANGE("Item No.", TrackingSpecification."Item No.");
                    QSpecLineT.SETRANGE("Customer No.", SalesLineT."Sell-to Customer No.");
                    QSpecLineT.SETRANGE(Type, '');
                    QSpecLineT.SETRANGE("Version Code", ActiveVersionCode);
                    if QSpecLineT.FINDSET then begin //QC7.7 Start (BEGIN added too)
                        TempGlobalEntrySummary."Cust Specs Exist" := true; //CUSTOMER (Sell-To Cust.) Spec Exists for this Item
                                                                           //QC7.7 Finish
                        repeat
                            QLotTestLineT.SETRANGE("Item No.", TrackingSpecification."Item No.");
                            //QC37.05
                            if LookupMode = LookupMode::"Lot No." then
                                QLotTestLineT.SETRANGE("Lot No./Serial No.", TempReservEntry."Lot No.");
                            if LookupMode = LookupMode::"Serial No." then
                                QLotTestLineT.SETRANGE("Lot No./Serial No.", TempReservEntry."Serial No.");
                            //
                            QLotTestLineT.SETRANGE("Quality Measure", QSpecLineT."Quality Measure");
                            QLotTestLineT.SETRANGE("Test Status", QLotTestLineT."Test Status"::"Certified Final"); //QC80.1 Corrected "Test Status" value
                                                                                                                   //QC4SP1.2
                            QLotTestLineT.SETRANGE("Customer No.", SalesLineT."Sell-to Customer No.");
                            //
                            if QLotTestLineT.FINDLAST then begin //There IS a Customer-Specific Certified Test!
                                                                 //QC7.7 Start
                                                                 //TempGlobalEntrySummary."QC Test Exists" := TRUE;
                                TempGlobalEntrySummary."Cust Test Exists" := true; //Added "Cust Test Exists" Field, so use it!
                                                                                   //QC7.7 Finish
                                                                                   //QC80.1 - Added "Test Line Complete" term to line below
                                if ((QLotTestLineT."Actual Measure" <> 0) or (QLotTestLineT."Test Line Complete" = true)) then begin // Handle Numeric Test Line
                                    if QLotTestLineT."Non-Conformance" = true then begin
                                        TempGlobalEntrySummary."QC Non Compliance" := true;
                                        //QC7.7 Start
                                        TempGlobalEntrySummary."Cust Test Non Compliant" := true; //Added "Cust Test Passed" Field
                                                                                                  //TempGlobalEntrySummary."QC Compliance" := 'NO';
                                                                                                  //QC7.7 Finish
                                    end;
                                end else begin //Handle Result List Type
                                               //QC5.01 begin
                                    if QLotTestLineT.Result <> '' then begin
                                        if QLotTestLineT."Non-Conformance" = true then begin
                                            TempGlobalEntrySummary."QC Non Compliance" := true;
                                            //QC7.7 Start
                                            TempGlobalEntrySummary."Cust Test Non Compliant" := true; //Added "Cust Test Passed" Field
                                                                                                      //TempGlobalEntrySummary."QC Compliance" := 'NO';
                                                                                                      //QC7.7 Finish
                                        end;
                                    end;
                                end;
                                //QC5.01 end

                                //QC7.7 Start - REMoved the "ELSE" (left the BEGIN to make Code easier to Manage later), because we want to ALWAYS know if there was a "Company" (Item) Test!
                                //END ELSE BEGIN
                            end;
                            begin
                                //QC7.7 Finish

                                //Attempt to find a test for this Item, but without a customer no. (Company a/k/a "Item" Test

                                QLotTestLineT.RESET;
                                QLotTestLineT.SETRANGE("Item No.", TrackingSpecification."Item No.");
                                //QC37.05
                                if LookupMode = LookupMode::"Lot No." then
                                    QLotTestLineT.SETRANGE("Lot No./Serial No.", TempReservEntry."Lot No.");
                                if LookupMode = LookupMode::"Serial No." then
                                    QLotTestLineT.SETRANGE("Lot No./Serial No.", TempReservEntry."Serial No.");
                                //
                                QLotTestLineT.SETRANGE("Quality Measure", QSpecLineT."Quality Measure");
                                QLotTestLineT.SETRANGE("Test Status", QLotTestLineT."Test Status"::"Certified Final"); //QC80.1 Corrected "Test Status" value
                                                                                                                       //QC4SP1.2
                                QLotTestLineT.SETFILTER("Customer No.", '%1', ''); //Specifially look for ITEM Tests (rather than Item + Customer)
                                                                                   //
                                if QLotTestLineT.FINDLAST then begin
                                    TempGlobalEntrySummary."QC Test Exists" := true;
                                    //QC80.1 - Added "Test Line Complete" term to line below
                                    if ((QLotTestLineT."Actual Measure" <> 0) or (QLotTestLineT."Test Line Complete" = true)) then begin // Handle Numeric Test Line
                                                                                                                                         //QC4SP1.2
                                        if (QLotTestLineT."Actual Measure" < QSpecLineT."Lower Limit") and
                                           (QLotTestLineT."Actual Measure" > QSpecLineT."Upper Limit") then begin
                                            TempGlobalEntrySummary."QC Non Compliance" := true;
                                            //QC7.7 Start
                                            TempGlobalEntrySummary."Item Test Non Compliant" := true; // New Field Added
                                                                                                      //TempGlobalEntrySummary."QC Compliance" := 'NO';
                                                                                                      //QC7.7 Finish
                                        end;

                                        //QC7.7 Start - Add in apparently missing "Result List" Type
                                        //                END;

                                    end else begin //Handle Result List Type
                                        if QLotTestLineT.Result <> '' then begin
                                            if QLotTestLineT."Non-Conformance" = true then begin
                                                TempGlobalEntrySummary."QC Non Compliance" := true;
                                                //QC7.7 Start
                                                TempGlobalEntrySummary."Item Test Non Compliant" := true; //Added Field
                                                                                                          //TempGlobalEntrySummary."QC Compliance" := 'NO';
                                                                                                          //QC7.7 Finish
                                            end;
                                        end;
                                    end;

                                    //QC7.7 FInish

                                end else begin
                                    //QC4SP1.2 - test line not found
                                    TempGlobalEntrySummary."QC Test Exists" := false;
                                    TempGlobalEntrySummary."QC Non Compliance" := true;
                                    //QC7.7 Start
                                    TempGlobalEntrySummary."Cust Test Exists" := false;
                                    TempGlobalEntrySummary."Cust Test Non Compliant" := false;
                                    //TempGlobalEntrySummary."QC Compliance" := 'NO';
                                    //QC7.7 Finish
                                end;   //end
                            end;
                        until QSpecLineT.NEXT = 0;
                    end;

                    // new fields on Entry Summary table
                    TempGlobalEntrySummary."QC Option" := TempGlobalEntrySummary."QC Option"::Customer;
                    TempGlobalEntrySummary."Item No." := TrackingSpecification."Item No.";
                    TempGlobalEntrySummary."Customer No." := SalesLineT."Sell-to Customer No.";
                    TempGlobalEntrySummary."Version Code" := ActiveVersionCode;

                end;
            end;

        // -- END SALESLINE "CALL" ---

        //Process Item Journal Line "Call"

        if (TrackingSpecification."Source Type" = DATABASE::"Item Journal Line") then
            if ItemJnlLineT.GET(TrackingSpecification."Source ID", TrackingSpecification."Source Batch Name",
                                TrackingSpecification."Source Ref. No.")
            //Source Subtype = ??
            //Source ID      = Journal Template Name
            //Source Batch   = Journal Batch Name
            //Source Ref. No.= Line No.

            then begin
                if ItemT.GET(TrackingSpecification."Item No.") then begin
                    ItemT.CALCFIELDS("Has Quality Specifications");
                    TempGlobalEntrySummary."QC Specs Exist" := ItemT."Has Quality Specifications";  //Set "QC Specs Exist"
                end;

                GetCompanySpec := true;    //Default for item jnl line.. assume no customer so get companys specs

                if GetCompanySpec = true then begin
                    ActiveVersionCode := GetQCVersion(TrackingSpecification."Item No.", '', '', WORKDATE, 2);   //Origin = SalesLine

                    QSpecLineT.SETRANGE("Item No.", TrackingSpecification."Item No.");
                    QSpecLineT.SETRANGE("Customer No.", '');
                    QSpecLineT.SETRANGE(Type, '');
                    QSpecLineT.SETRANGE("Version Code", ActiveVersionCode);
                    if QSpecLineT.FINDSET then
                        repeat
                            QLotTestLineT.SETRANGE("Item No.", TrackingSpecification."Item No.");
                            //QC37.05
                            if LookupMode = LookupMode::"Lot No." then
                                QLotTestLineT.SETRANGE("Lot No./Serial No.", TempReservEntry."Lot No.");
                            if LookupMode = LookupMode::"Serial No." then
                                QLotTestLineT.SETRANGE("Lot No./Serial No.", TempReservEntry."Serial No.");
                            //
                            QLotTestLineT.SETRANGE("Quality Measure", QSpecLineT."Quality Measure");
                            QLotTestLineT.SETRANGE("Test Status", QLotTestLineT."Test Status"::"Certified Final"); //QC80.1 Corrected "Test Status" value
                                                                                                                   //QC4SP1.2
                            QLotTestLineT.SETFILTER("Customer No.", '%1', '');
                            //
                            if QLotTestLineT.FINDLAST then begin
                                TempGlobalEntrySummary."QC Test Exists" := true; //Set "QC Test Exists"
                                                                                 //QC80.1 - Added "Test Line Complete" term to line below
                                if ((QLotTestLineT."Actual Measure" <> 0) or (QLotTestLineT."Test Line Complete" = true)) then begin // Handle Numeric Test Line
                                    if QLotTestLineT."Non-Conformance" = true then begin
                                        TempGlobalEntrySummary."QC Non Compliance" := true;
                                        //QC7.7 Start
                                        TempGlobalEntrySummary."Item Test Non Compliant" := true; // New Field Added
                                                                                                  //TempGlobalEntrySummary."QC Compliance" := 'NO';
                                                                                                  //QC7.7 Finish
                                    end;
                                end else begin  //Else, it must be a Result List Test Line
                                                //QC5.01 begin
                                    if QLotTestLineT.Result <> '' then begin
                                        if QLotTestLineT."Non-Conformance" = true then begin
                                            TempGlobalEntrySummary."QC Non Compliance" := true;
                                            //QC7.7 Start
                                            TempGlobalEntrySummary."Item Test Non Compliant" := true; // New Field Added
                                                                                                      //TempGlobalEntrySummary."QC Compliance" := 'NO';
                                                                                                      //QC7.7 Finish
                                        end;
                                    end;
                                end;
                                //QC5.01 end
                            end;
                        until QSpecLineT.NEXT = 0;

                    // new fields on Entry Summary table
                    TempGlobalEntrySummary."QC Option" := TempGlobalEntrySummary."QC Option"::Company;
                    TempGlobalEntrySummary."Item No." := TrackingSpecification."Item No.";
                    TempGlobalEntrySummary."Customer No." := '';
                    TempGlobalEntrySummary."Version Code" := ActiveVersionCode;

                end;
            end;

        //Handle "Production Order Component" "Call"...

        //QC4SP
        if TrackingSpecification."Source Type" = DATABASE::"Prod. Order Component"
          /*IF ProdOrderCompLineT.GET(TrackingSpecification."Source ID",
                                    TrackingSpecification."Source Ref. No.") */
          //Source Subtype =
          //Source ID      = Document No.
          //Source Batch   =
          //Source Ref. No.= Line No.

          then begin
            if ItemT.GET(TrackingSpecification."Item No.") then begin
                ItemT.CALCFIELDS("Has Quality Specifications");
                TempGlobalEntrySummary."QC Specs Exist" := ItemT."Has Quality Specifications"; //Set "QC Specs Exist"
            end;

            GetCompanySpec := true;    //Default for Prod. Order.. assume no customer so get companys specs

            if GetCompanySpec = true then begin
                ActiveVersionCode := GetQCVersion(TrackingSpecification."Item No.", '', '', WORKDATE, 2);   //Origin = SalesLine

                QSpecLineT.SETRANGE("Item No.", TrackingSpecification."Item No.");
                QSpecLineT.SETRANGE("Customer No.", '');
                QSpecLineT.SETRANGE(Type, '');
                QSpecLineT.SETRANGE("Version Code", ActiveVersionCode);
                if QSpecLineT.FINDSET then
                    repeat
                        QLotTestLineT.SETRANGE("Item No.", TrackingSpecification."Item No.");
                        //QC37.05
                        if LookupMode = LookupMode::"Lot No." then
                            QLotTestLineT.SETRANGE("Lot No./Serial No.", TempReservEntry."Lot No.");
                        if LookupMode = LookupMode::"Serial No." then
                            QLotTestLineT.SETRANGE("Lot No./Serial No.", TempReservEntry."Serial No.");
                        //
                        QLotTestLineT.SETRANGE("Quality Measure", QSpecLineT."Quality Measure");
                        QLotTestLineT.SETRANGE("Test Status", QLotTestLineT."Test Status"::"Certified Final"); //QC80.1 Corrected "Test Status" value
                                                                                                               //QC4SP1.2
                        QLotTestLineT.SETFILTER("Customer No.", '%1', '');
                        //
                        if QLotTestLineT.FINDLAST then begin
                            TempGlobalEntrySummary."QC Test Exists" := true; //Set "QC Test Exists"
                                                                             //QC80.1 - Added "Test Line Complete" term to line below
                            if ((QLotTestLineT."Actual Measure" <> 0) or (QLotTestLineT."Test Line Complete" = true)) then begin // Handle Numeric Test Line
                                if QLotTestLineT."Non-Conformance" = true then begin
                                    TempGlobalEntrySummary."QC Non Compliance" := true;
                                    //QC7.7 Start
                                    TempGlobalEntrySummary."Item Test Non Compliant" := true; //Set new Field
                                                                                              //TempGlobalEntrySummary."QC Compliance" := 'NO';
                                                                                              //QC7.7 Finish
                                end;
                            end else begin  //Else, Handle Result List Test Line
                                            //QC5.01 begin
                                if QLotTestLineT.Result <> '' then begin
                                    if QLotTestLineT."Non-Conformance" = true then begin
                                        TempGlobalEntrySummary."QC Non Compliance" := true;
                                        //QC7.7 Start
                                        TempGlobalEntrySummary."Item Test Non Compliant" := true; //Set new Field
                                                                                                  //TempGlobalEntrySummary."QC Compliance" := 'NO';
                                                                                                  //QC7.7 Finish
                                    end;
                                end;
                            end;
                            //QC5.01 end
                        end;
                    until QSpecLineT.NEXT = 0;

                // new fields on Entry Summary table
                TempGlobalEntrySummary."QC Option" := TempGlobalEntrySummary."QC Option"::Company;
                TempGlobalEntrySummary."Item No." := TrackingSpecification."Item No.";
                TempGlobalEntrySummary."Customer No." := '';
                TempGlobalEntrySummary."Version Code" := ActiveVersionCode;


            end;
        end;

        //Handle "Transfer Line" "Call"...

        if TrackingSpecification."Source Type" = DATABASE::"Transfer Line" then
            if TransferLineT.GET(TrackingSpecification."Source ID",
                                 TrackingSpecification."Source Ref. No.")
            //Source Subtype =
            //Source ID      = Document No.
            //Source Batch   =
            //Source Ref. No.= Line No.

            then begin
                if ItemT.GET(TrackingSpecification."Item No.") then begin
                    ItemT.CALCFIELDS("Has Quality Specifications");
                    TempGlobalEntrySummary."QC Specs Exist" := ItemT."Has Quality Specifications"; //Set "QC Specs Exist"
                end;

                GetCompanySpec := true;    //Default for transfer line.. assume no customer so get companys specs

                if GetCompanySpec = true then begin
                    ActiveVersionCode := GetQCVersion(TrackingSpecification."Item No.", '', '', WORKDATE, 2);   //Origin = SalesLine

                    QSpecLineT.SETRANGE("Item No.", TrackingSpecification."Item No.");
                    QSpecLineT.SETRANGE("Customer No.", '');
                    QSpecLineT.SETRANGE(Type, '');
                    QSpecLineT.SETRANGE("Version Code", ActiveVersionCode);
                    if QSpecLineT.FINDSET then
                        repeat
                            QLotTestLineT.SETRANGE("Item No.", TrackingSpecification."Item No.");
                            //QC37.05
                            if LookupMode = LookupMode::"Lot No." then
                                QLotTestLineT.SETRANGE("Lot No./Serial No.", TempReservEntry."Lot No.");
                            if LookupMode = LookupMode::"Serial No." then
                                QLotTestLineT.SETRANGE("Lot No./Serial No.", TempReservEntry."Serial No.");
                            //
                            QLotTestLineT.SETRANGE("Quality Measure", QSpecLineT."Quality Measure");
                            QLotTestLineT.SETRANGE("Test Status", QLotTestLineT."Test Status"::"Certified Final"); //QC80.1 Corrected "Test Status" value
                                                                                                                   //QC4SP1.2
                            QLotTestLineT.SETFILTER("Customer No.", '%1', '');
                            //
                            if QLotTestLineT.FINDLAST then begin
                                TempGlobalEntrySummary."QC Test Exists" := true; //Set "QC Test Exists"
                                                                                 //QC80.1 - Added "Test Line Complete" term to line below
                                if ((QLotTestLineT."Actual Measure" <> 0) or (QLotTestLineT."Test Line Complete" = true)) then begin // Handle Numeric Test Line
                                    if QLotTestLineT."Non-Conformance" = true then begin
                                        TempGlobalEntrySummary."QC Non Compliance" := true;
                                        //QC7.7 Start
                                        TempGlobalEntrySummary."Item Test Non Compliant" := true; //Set new Field
                                                                                                  //TempGlobalEntrySummary."QC Compliance" := 'NO';
                                                                                                  //QC7.7 Finish
                                    end;
                                end else begin //Else, this is a Result List Test Line
                                               //QC5.01 begin
                                    if QLotTestLineT.Result <> '' then begin
                                        if QLotTestLineT."Non-Conformance" = true then begin
                                            TempGlobalEntrySummary."QC Non Compliance" := true;
                                            //QC7.7 Start
                                            TempGlobalEntrySummary."Item Test Non Compliant" := true; //Set new Field
                                                                                                      //TempGlobalEntrySummary."QC Compliance" := 'NO';
                                                                                                      //QC7.7 Finish
                                        end;
                                    end;
                                end;
                                //QC5.01 end
                            end;
                        until QSpecLineT.NEXT = 0;

                    // new fields on Entry Summary table
                    TempGlobalEntrySummary."QC Option" := TempGlobalEntrySummary."QC Option"::Company;
                    TempGlobalEntrySummary."Item No." := TrackingSpecification."Item No.";
                    TempGlobalEntrySummary."Customer No." := '';
                    TempGlobalEntrySummary."Version Code" := ActiveVersionCode;
                end;
            end;

        // End All "Call" Types - Now, Refine the "Boiled-Down" Decision...

        //QC7.7 Start - Now Apply the QC "Rules" to come up with a "Boiled-Down" "QC Compliance" Decision
        FinalizeConformanceDecision(TempGlobalEntrySummary); //Modify TempGlobalEntrySummary to comport with QC Rules
                                                             //QC7.7 Finish  -- This is also the end of all QC7.7 Changes to this Function

        //end QC

        //end QC

        //QC Finish - Huge Code Insertion

    end;

    procedure FinalizeConformanceDecision(var TempGlobalEntrySummary: Record "Entry Summary" temporary);
    var
        BCDComplianceConditions: Integer;
        CustNoExists: Boolean;
        BCDDiagText: Label 'Lot No. %9, BCD Options Are:\\CustNo %1\\QCSpecs %2\\QCTest %3\\QCFail %4\\CustSpecs %5\\CustTest %6\\CustFail %7''\\\\BCD = %8';
        YesText: Label 'YES';
        NoText: Label 'NO';
        NoSpecsText: Label 'NO SPECS';
        NoTestsText: Label 'NO TESTS';
        NoCoTestText: Label 'NO CO. TESTS';
        NoCustTestText: Label 'NO CUST TEST';
        FailedCustTestText: Label 'FAILED CUST TEST';
        DefaultText: Label 'CONTACT SUPV';
    begin
        //QC7.7 - Function Added
        //
        // Uses Compliance Rules to Set the FINAL Values of the "QC Compliance" Text Field and the "QC Non Compliance" Boolean
        // Called just before the TempGlobalEntrySummary Record is Inserted/Modified
        // Makes its Decision based on the following Fields:
        // "Customer No." (present or not)
        // "QC Specs Exist", "QC Test Exists", "Item Test Non Compliant", "Cust Specs Exist", "Cust Test Exists", "Cust Test Non Compliant"
        // Sets the Following Fields:
        // "QC Compliance", "QC Compliance"
        //
        // Uses BCD Values in a CASE Statement to "boil down" the 127 Possible Combinations into reasonably-set-and-modified "Rules"
        //
        // BCD Values are the Following:
        // 1  - "Cust Test Non Compliant"
        // 2  - "Item Test Non Compliant"
        // 4  - "Cust Test Exists"
        // 8  - "QC Test Exists" (Item Test)
        // 16 - "Cust Specs Exist"
        // 32 - "QC Specs Exist" (Item Specs)
        // 64 - "CustNoExists" (Local Boolean)
        //
        // So, the BCD Value of "BCDComplianceConditions" (Local Integer), which is used in the CASE Statement as the "Switch" is calculated thusly:
        // Add the "Values" for each TRUE "Condition" together (see above) to form a unique value for that Combination
        // e.g. if there is no Customer No, but there are Item and Customer Specs, an Item Test Exists, but no Customer Test, and the Item Test Passed we end up with:
        // So, the BCD Value would be: 32 + 16 + 8 = 56
        // This Number, along with the CASE Statement's unique "Expression Evaluator" Rules, allows the Developer to easily define the "Cares" and "Don't Cares" for each Combination
        // Bottom line: It looks unecessarily arcane at first, but it really is a lot better than a bunch of nested IF/THEN/ELSE statements!


        // Calculate BCD Value for BCDComplianceConditions
        BCDComplianceConditions := 0; //Initialize "Switch"


        CustNoExists := (TempGlobalEntrySummary."Customer No." <> ''); //Determine this all-important "highest-order bit"

        if CustNoExists then BCDComplianceConditions := 64;
        if TempGlobalEntrySummary."QC Specs Exist" then BCDComplianceConditions := BCDComplianceConditions + 32;
        if TempGlobalEntrySummary."Cust Specs Exist" then BCDComplianceConditions := BCDComplianceConditions + 16;
        if TempGlobalEntrySummary."QC Test Exists" then BCDComplianceConditions := BCDComplianceConditions + 8;
        if TempGlobalEntrySummary."Cust Test Exists" then BCDComplianceConditions := BCDComplianceConditions + 4;
        if TempGlobalEntrySummary."Item Test Non Compliant" then BCDComplianceConditions := BCDComplianceConditions + 2;
        if TempGlobalEntrySummary."Cust Test Non Compliant" then BCDComplianceConditions := BCDComplianceConditions + 1;


        //NOTE: Un-Comment the next "Diagnostic Section to see the BCD Value(s) being produced by your data

        //IF "Lot No." = 'L-411' THEN BEGIN //Beginning of "Diagnostic" Section - Change/REM the "IF" Statement to choose which Lot/SNs to see

        //  IF CONFIRM(BCDDiagText,TRUE,CustNoExists,"QC Specs Exist","QC Test Exists","Item Test Non Compliant","Cust Specs Exist",
        //    "Cust Test Exists","Cust Test Non Compliant" ,BCDComplianceConditions,"Lot No.") THEN;

        //END; //End of "Diagnostic" Section


        // Ok, now Apply the Rules...

        // TIP: Values BELOW 64 are when "calling" this WITHOUT a "Customer No.", Values 64 and ABOVE, are WITH a "Customer No."
        // ... Something to keep in mind, however, is that "CreateEntrySummary2", above, sometimes "supresses" the "Customer No." before this Func. is Called!!!
        // ... So, sometimes (depending on circumstances decided by "CreateEntrySummary2", the fact that there isn't a "Customer No.", even though...
        // ... you know this Codeunit is being called from a "Sales Line", the answer lies in the Function "CreateEntrySummary2"

        //The reason why there are so many "ranges" of Values, is to make some of the Boolean "Bits" into "Don't Cares" for a particular "Final Decision"
        //This DRASTICALLY reduces the number of CASEs, and also the number of "Contact Supv" (unknown "bit pattern" (BCD Value)) "Holes" in the CASEs
        //e.g., 0..3,64..67 means that Customer No. or not, if there are No Specs for BOTH Customer and Company (Item) Specs, it doesn't matter what the...
        //"Test Results" are, so we have "included" those "illegal" Results (theoretically, you should not see anything but a 0 OR a 64 value; but, things happen)
        //It makes the CASEs a little harder to understand; but it is worth it in "Robustness" of the Result

        case BCDComplianceConditions of

            0 .. 3, 64 .. 67:
                begin
                    TempGlobalEntrySummary."QC Non Compliance" := true; //Old-Style Result
                    TempGlobalEntrySummary."QC Compliance" := NoSpecsText; //No Specs
                end; //End No Specs Case

            // The next two CASEs should be considered the "Company" and "Customer" versions of the same "Range" of BCD Values

            96 .. 99:
                begin
                    TempGlobalEntrySummary."QC Non Compliance" := true; //Old-Style Result
                    TempGlobalEntrySummary."QC Compliance" := NoTestsText; //No Tests
                end; //End No Tests Case

            32 .. 37:
                begin
                    TempGlobalEntrySummary."QC Non Compliance" := true; //Old-Style Result
                    TempGlobalEntrySummary."QC Compliance" := NoCoTestText; //No Company Tests
                end; //End No Company (Item) Tests Case

            //

            16 .. 19, 24 .. 27, 48 .. 51, 56 .. 59, 80 .. 83, 88 .. 91, 112 .. 115, 120 .. 123:
                begin
                    TempGlobalEntrySummary."QC Non Compliance" := true; //Old-Style Result
                    TempGlobalEntrySummary."QC Compliance" := NoCustTestText; //No Cust Tests
                end; //End No Cust Tests Case

            20, 22, 28, 30, 40 .. 41, 52, 60, 84, 86, 92, 94, 104 .. 105, 116, 124:
                begin
                    TempGlobalEntrySummary."QC Non Compliance" := false; //Old-Style Result
                    TempGlobalEntrySummary."QC Compliance" := YesText; //Yes
                end; //End Yes Case

            21, 23, 29, 31, 42 .. 43, 63, 85, 87, 93, 95, 106 .. 107, 127:
                begin
                    TempGlobalEntrySummary."QC Non Compliance" := true; // Old-Style Result
                    TempGlobalEntrySummary."QC Compliance" := NoText; //No
                end; //End No Case

            61, 125:
                begin
                    TempGlobalEntrySummary."QC Non Compliance" := true; // Old-Style Result
                    TempGlobalEntrySummary."QC Compliance" := FailedCustTestText; //Failed Cust Test (But PASSED the Item Test!)
                end; //END Failed Cust Test Case

            //BCD "Bit Pattern" Not Found. Gotta Ask a Human!  (We SHOULD never see this, if the CASEs are all correct)

            else
                TempGlobalEntrySummary."QC Non Compliance" := true; //Better be Safe...
                TempGlobalEntrySummary."QC Compliance" := DefaultText; //Tell 'em to ask their boss...
        end; //END CASEs
    end;

    //QC13.01 Function Added to Return "Product Name"
    procedure GetProductName(): Text;
    begin
        exit('Quality Control');
    end;

    //QC200.01
    procedure LotOrSerialNoInformationExists(Source: Option Lot,Serial; ItemLedgEntry: Record "Item Ledger Entry"): Boolean;
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
    begin
        case Source of
            source::Lot:
                if LotNoInfo.GET(ItemLedgEntry."Item No.", ItemLedgEntry."Variant Code", ItemLedgEntry."Lot No.") then
                    exit(true);
            source::Serial:
                if SerialNoInfo.GET(ItemLedgEntry."Item No.", ItemLedgEntry."Variant Code", ItemLedgEntry."Serial No.") then
                    exit(true);
        end;

        exit(false);
    end;
    //QC200.01
    procedure CreateLotOrSerialNoInformation(Source: Option Lot,Serial; ItemLedgEntry: Record "Item Ledger Entry");
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
        Items: Record Item;
        ItemsVariant: Record "Item Variant";
        VarianDesc: Text[150];
    begin
        //Get info item & variant 
        Clear(VarianDesc);
        if ItemLedgEntry."Item No." <> '' then begin
            Clear(Items);
            Items.Reset();
            if Items.Get(ItemLedgEntry."Item No.") then;
        end;
        if ItemLedgEntry."Variant Code" <> '' then begin
            Clear(ItemsVariant);
            ItemsVariant.Reset();
            ItemsVariant.SetRange("Item No.", ItemLedgEntry."Item No.");
            ItemsVariant.SetRange(Code, ItemLedgEntry."Variant Code");
            if ItemsVariant.Find('-') then begin
                VarianDesc := ItemsVariant.Description;
            end
        end;
        //-
        case Source of
            source::Lot:
                begin
                    LotNoInfo.Init();
                    LotNoInfo."Item No." := ItemLedgEntry."Item No.";
                    LotNoInfo."Variant Code" := ItemLedgEntry."Variant Code";
                    LotNoInfo."Lot No." := ItemLedgEntry."Lot No.";
                    //Integration event
                    OnCreateLotOrSerialNoInformation(LotNoInfo, ItemLedgEntry);
                    //-
                    LotNoInfo.Description := ItemLedgEntry.Description;
                    LotNoInfo."CCS Expiration Date" := ItemLedgEntry."Expiration Date";
                    if ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Purchase then
                        LotNoInfo."CCS Date Received" := WorkDate;
                    LotNoInfo.Insert();
                end;
            source::Serial:
                begin
                    SerialNoInfo.Init();
                    SerialNoInfo."Item No." := ItemLedgEntry."Item No.";
                    SerialNoInfo."Variant Code" := ItemLedgEntry."Variant Code";
                    SerialNoInfo."Serial No." := ItemLedgEntry."Serial No.";
                    SerialNoInfo.Description := ItemLedgEntry.Description;
                    SerialNoInfo."CCS Expiration Date" := ItemLedgEntry."Expiration Date";
                    if ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Purchase then
                        SerialNoInfo."CCS Date Received" := WorkDate;
                    SerialNoInfo.Insert();
                end;
        end;
    end;

    procedure LotOrSerialNoInformationExists2(Source: Option Lot,Serial; TempTrackingSpec: Record "Tracking Specification" temporary): Boolean;
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
    begin
        case Source of
            source::Lot:
                if LotNoInfo.GET(TempTrackingSpec."Item No.", TempTrackingSpec."Variant Code", TempTrackingSpec."Lot No.") then
                    exit(true);
            source::Serial:
                if SerialNoInfo.GET(TempTrackingSpec."Item No.", TempTrackingSpec."Variant Code", TempTrackingSpec."Serial No.") then
                    exit(true);
        end;

        exit(false);
    end;

    procedure CreateLotOrSerialNoInformation2(Source: Option Lot,Serial; TempTrackingSpec: Record "Tracking Specification" temporary);
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
        Item: Record Item;
    begin
        case Source of
            source::Lot:
                begin
                    LotNoInfo.Init();
                    LotNoInfo."Item No." := TempTrackingSpec."Item No.";
                    LotNoInfo."Variant Code" := TempTrackingSpec."Variant Code";
                    LotNoInfo."Lot No." := TempTrackingSpec."Lot No.";
                    if Item.Get(TempTrackingSpec."Item No.") then
                        LotNoInfo.Description := Item.Description;
                    LotNoInfo."CCS Expiration Date" := TempTrackingSpec."Expiration Date";
                    LotNoInfo.Insert();
                end;
            source::Serial:
                begin
                    SerialNoInfo.Init();
                    SerialNoInfo."Item No." := TempTrackingSpec."Item No.";
                    SerialNoInfo."Variant Code" := TempTrackingSpec."Variant Code";
                    SerialNoInfo."Serial No." := TempTrackingSpec."Serial No.";
                    if Item.Get(TempTrackingSpec."Item No.") then
                        SerialNoInfo.Description := Item.Description;
                    SerialNoInfo."CCS Expiration Date" := TempTrackingSpec."Expiration Date";
                    SerialNoInfo.Insert();
                end;
        end;
    end;

    //QC200.01
    procedure BlockLotAndSerialNoInformation2(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; SerialNo: Code[50]; ExpirationDate: Date; Block: Boolean);
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
    begin
        if LotNoInfo.GET(ItemNo, VariantCode, LotNo) then begin
            if Block then
                LotNoInfo.Validate("CCS Status", LotNoInfo."CCS Status"::"In Quality Inspection")
            else
                if (LotNoInfo."CCS Status" = LotNoInfo."CCS Status"::Hold) or (LotNoInfo."CCS Status" = LotNoInfo."CCS Status"::"In Quality Inspection") then
                    LotNoInfo.Validate("CCS Status", LotNoInfo."CCS Status"::Unrestricted);
            if LotNoInfo."CCS Expiration Date" = 0D then
                LotNoInfo."CCS Expiration Date" := ExpirationDate;
            LotNoInfo.Modify();
        end;

        if SerialNoInfo.GET(ItemNo, VariantCode, SerialNo) then begin
            if Block then
                SerialNoInfo.Validate("CCS Status", SerialNoInfo."CCS Status"::"In Quality Inspection")
            else
                if (SerialNoInfo."CCS Status" = SerialNoInfo."CCS Status"::Hold) or (SerialNoInfo."CCS Status" = SerialNoInfo."CCS Status"::"In Quality Inspection") then
                    SerialNoInfo.Validate("CCS Status", SerialNoInfo."CCS Status"::Unrestricted);
            if SerialNoInfo."CCS Expiration Date" = 0D then
                SerialNoInfo."CCS Expiration Date" := ExpirationDate;
            SerialNoInfo.Modify();
        end;
    end;

    procedure BlockLotAndSerialNoInformation3(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; SerialNo: Code[50]; ExpirationDate: Date; Block: Boolean; TestNo: Code[20]);
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
        Items: Record Item;
    begin
        Items.Get(ItemNo);
        if LotNoInfo.GET(ItemNo, VariantCode, LotNo) then begin
            if Block then
                LotNoInfo.Validate("CCS Status", LotNoInfo."CCS Status"::Restricted)
            else
                if (LotNoInfo."CCS Status" = LotNoInfo."CCS Status"::Hold) or (LotNoInfo."CCS Status" = LotNoInfo."CCS Status"::"In Quality Inspection") then
                    LotNoInfo.Validate("CCS Status", LotNoInfo."CCS Status"::Unrestricted);
            if LotNoInfo."CCS Expiration Date" = 0D then
                LotNoInfo."CCS Expiration Date" := ExpirationDate;
            // add by rnd, requst by chz-san, 05 April 2024
            // if Items."Inventory Posting Group" = 'FG' then
            //     LotNoInfo.Validate("CCS Status", LotNoInfo."CCS Status"::Unrestricted);
            //-
            LotNoInfo."CCS Test No." := TestNo;
            LotNoInfo.Modify();
        end;

        if SerialNoInfo.GET(ItemNo, VariantCode, SerialNo) then begin
            if Block then
                SerialNoInfo.Validate("CCS Status", SerialNoInfo."CCS Status"::"In Quality Inspection")
            else
                if (SerialNoInfo."CCS Status" = SerialNoInfo."CCS Status"::Hold) or (SerialNoInfo."CCS Status" = SerialNoInfo."CCS Status"::"In Quality Inspection") then
                    SerialNoInfo.Validate("CCS Status", SerialNoInfo."CCS Status"::Unrestricted);
            if SerialNoInfo."CCS Expiration Date" = 0D then
                SerialNoInfo."CCS Expiration Date" := ExpirationDate;
            SerialNoInfo."CCS Test No." := TestNo;
            // add by rnd, requst by chz-san, 05 April 2024
            if Items."Inventory Posting Group" = 'FG' then
                SerialNoInfo.Validate("CCS Status", LotNoInfo."CCS Status"::Unrestricted);
            //-
            SerialNoInfo.Modify();
        end;
    end;

    procedure BlockLotAndSerialNoInformation(ItemLedgEntry: Record "Item Ledger Entry"; Block: Boolean);
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
    begin
        if LotNoInfo.GET(ItemLedgEntry."Item No.", ItemLedgEntry."Variant Code", ItemLedgEntry."Lot No.") then begin
            LotNoInfo.Blocked := Block;
            LotNoInfo.Modify();
        end;

        if SerialNoInfo.GET(ItemLedgEntry."Item No.", ItemLedgEntry."Variant Code", ItemLedgEntry."Serial No.") then begin
            SerialNoInfo.Blocked := Block;
            SerialNoInfo.Modify();
        end;
    end;

    //QC200.01
    procedure VerifyValidQualitySpecification2(ItemNo: Code[20]; CustNo: Code[20]; var QCRequired: Boolean; SpecificationNo: Code[20]): Boolean;
    var
        QCSpecification: Record QCSpecificationHeader_PQ;
        QCSpecificationLines: Record QCSpecificationLine_PQ;
        ActiveVersionCode: Code[20];
    begin
        if QCSpecification.Get(ItemNo, CustNo, SpecificationNo) then begin
            ActiveVersionCode := GetQCVersion(ItemNo, CustNo, SpecificationNo, WORKDATE, 2);   //Origin = Salesline

            if (QCSpecification.Status = QCSpecification.Status::Certified) then begin
                QCRequired := QCSpecification."QC Required";
                QCSpecificationLines.SETRANGE("Item No.", ItemNo);
                QCSpecificationLines.SETRANGE("Customer No.", CustNo);
                QCSpecificationLines.SETRANGE(Type, QCSpecification.Type);
                QCSpecificationLines.SETRANGE("Version Code", ActiveVersionCode);
                if QCSpecificationLines.FINDSET() then
                    exit(true);
            end;
        end;

        exit(false);
    end;

    procedure VerifyValidQualitySpecification(ItemLedgEntry: Record "Item Ledger Entry"; var QCRequired: Boolean): Boolean;
    var
        QCSpecification: Record QCSpecificationHeader_PQ;
        QCSpecificationLines: Record QCSpecificationLine_PQ;
        ActiveVersionCode: Code[20];
    begin
        if QCSpecification.GET(ItemLedgEntry."Item No.", '', '') then begin
            ActiveVersionCode := GetQCVersion(ItemLedgEntry."Item No.", ItemLedgEntry."Source No.", '', WORKDATE, 2);   //Origin = Salesline

            if (QCSpecification.Status = QCSpecification.Status::Certified) then begin
                QCRequired := QCSpecification."QC Required";
                QCSpecificationLines.SETRANGE("Item No.", ItemLedgEntry."Item No.");
                QCSpecificationLines.SETRANGE("Customer No.", '');
                QCSpecificationLines.SETRANGE(Type, '');
                QCSpecificationLines.SETRANGE("Version Code", ActiveVersionCode);
                if QCSpecificationLines.FINDSET() then
                    exit(true);
            end;
        end;

        exit(false);
    end;

    //QC200.01
    procedure GetSpecificQualityHeader(ItemNo: Code[20]; SpecificationNo: Code[20]): Code[20]
    var
        QualityTestHeader: Record QualityTestHeader_PQ;
    begin
        QualityTestHeader.SetRange("Item No.", ItemNo);
        QualityTestHeader.SetRange("Specification Type", SpecificationNo);
        if QualityTestHeader.FindFirst() then
            exit(QualityTestHeader."Test No.");

        exit('');
    end;

    procedure GetSpecificQualityHeader2(ItemNo: Code[20]; SpecificationNo: Code[20]; ProdOrderNo: Code[20]; RoutingNo: Code[10]): Code[20]
    var
        QualityTestHeader: Record QualityTestHeader_PQ;
    begin
        QualityTestHeader.SetRange("Item No.", ItemNo);
        QualityTestHeader.SetRange("Specification Type", SpecificationNo);
        QualityTestHeader.SetRange("Prod. Order No.", ProdOrderNo);
        QualityTestHeader.SetRange("Routing No.", RoutingNo);
        if QualityTestHeader.FindFirst() then
            exit(QualityTestHeader."Test No.");

        exit('');
    end;

    //QC200.01
    procedure CreateQualityTestAndSpecifications(ItemNo: code[20]; UoM: Code[20]; LotNo: Code[50]; SerialNo: Code[50]; SpecificationNo: Code[20]; ProdOrderNo: Code[20]; SourceType: Enum QCSourceType_PQ; SourceNo: Code[20]; SourceLineNo: Integer; VendorNo: Code[20]; TestQty: Decimal; SourceNoTracing: Code[20]; RoutingNo: Code[10]; LocationCode: Code[20]): Code[20]
    var
        QualityTestHeader: Record QualityTestHeader_PQ;
        QCSpecificationLines: Record QCSpecificationLine_PQ;
        LotSeriaNo: Code[101];
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
        ValidateLotNo: Boolean;
        ProdOrder: Record "Production Order";
        TrackingType: Option "Lot No.","Serial No.";
        QCSetup: Record QCSetup_PQ;
        QualityTestHeader2: Record QualityTestHeader_PQ;
    begin
        QCSetup.Get();
        if not QCSetup."Create QT per Item Tracking" then begin
            QualityTestHeader2.Reset();
            QualityTestHeader2.SetRange("Source Type", SourceType);
            QualityTestHeader2.SetRange("Source No.", SourceNo);
            QualityTestHeader2.SetRange("Source Line No.", SourceLineNo);
            if (SourceType = SourceType::"Item Journal") OR (SourceType = SourceType::"Output Journal") then begin
                QualityTestHeader2.SetRange("Multiple Tracking", true);
            end;
            if (LotNo = '') and (SerialNo = '') then        //case of not assigning Item tracking => out
                QualityTestHeader2.SetRange("Test No.", '__Temp123456');

            if QualityTestHeader2.FindFirst() then begin
                if ((LotNo <> '') and (QualityTestHeader2."Lot No." <> LotNo)) or ((SerialNo <> '') and (QualityTestHeader2."Serial No." <> SerialNo)) then begin   //case posted partial => out
                    QualityTestHeader2."Multiple Tracking" := true;
                    QualityTestHeader2."Lot No./Serial No." := '';
                    QualityTestHeader2."Test Qty" := QualityTestHeader2."Test Qty" + TestQty;
                    QualityTestHeader2.Modify();
                    exit(QualityTestHeader2."Test No.");
                end;
            end;
        end;

        ValidateLotNo := false;
        QualityTestHeader.Init();
        QualityTestHeader."Test No." := '';
        QualityTestHeader.Insert(true);

        QualityTestHeader."Specification Type" := SpecificationNo;
        QualityTestHeader.Validate("Item No.", ItemNo);
        QualityTestHeader.Validate("Unit of Measure", UoM);
        if LotNo <> '' then begin
            LotSeriaNo := LotNo;
            QualityTestHeader."Lot No." := LotNo;
        end;

        if (LotNo <> '') and (SerialNo <> '') then
            LotSeriaNo += ',';

        if SerialNo <> '' then begin
            LotSeriaNo += SerialNo;
            QualityTestHeader."Serial No." := SerialNo;
        end;

        LotNoInfo.Reset();
        LotNoInfo.SetRange("Lot No.", LotSeriaNo);
        if LotNoInfo.FindFirst() then begin
            ValidateLotNo := true;
            QualityTestHeader.setTrackingType(TrackingType::"Lot No.");
        end;

        SerialNoInfo.Reset();
        SerialNoInfo.SetRange("Serial No.", LotSeriaNo);
        if SerialNoInfo.FindFirst() then begin
            ValidateLotNo := true;
            QualityTestHeader.setTrackingType(TrackingType::"Serial No.");
        end;

        if ValidateLotNo then
            QualityTestHeader.Validate("Lot No./Serial No.", LotSeriaNo)
        else
            QualityTestHeader."Lot No./Serial No." := LotSeriaNo;

        QualityTestHeader.Modify(true);

        GetSpecification(QualityTestHeader);

        QualityTestHeader.Validate("Test Status", QualityTestHeader."Test Status"::"Ready for Testing");
        QualityTestHeader."Source No." := GlobalSourceNo;
        QualityTestHeader."Source Line No." := GlobalSourceLineNo;
        QualityTestHeader."Test Qty" := GlobalTestQty;
        if ProdOrderNo <> '' then begin
            if ProdOrder.Get(ProdOrder.Status::Released, ProdOrderNo) then
                QualityTestHeader."Test Qty" := ProdOrder.Quantity;
        end;
        QualityTestHeader."Prod. Order No." := ProdOrderNo;
        QualityTestHeader."Source Type" := SourceType;
        QualityTestHeader."Source No." := SourceNo;
        QualityTestHeader."Source Line No." := SourceLineNo;
        QualityTestHeader."Vendor No." := VendorNo;
        QualityTestHeader."Test Qty" := TestQty;
        QualityTestHeader."Source No. Tracing" := SourceNoTracing;
        QualityTestHeader."Routing No." := RoutingNo;
        if (not QCSetup."Create QT per Item Tracking") and ((SourceType = SourceType::"Item Journal") OR (SourceType = SourceType::"Output Journal")) then
            QualityTestHeader."Multiple Tracking" := true;
        QualityTestHeader.Modify(true);
        exit(QualityTestHeader."Test No.");

    end;

    procedure CreateQualityTestAndSpecifications(ItemNo: code[20]; VariantCode: Code[20]; UoM: Code[20]; LotNo: Code[50]; SerialNo: Code[50]; SpecificationNo: Code[20]; ProdOrderNo: Code[20]; SourceType: Enum QCSourceType_PQ; SourceNo: Code[20]; SourceLineNo: Integer; VendorNo: Code[20]; TestQty: Decimal; SourceNoTracing: Code[20]; RoutingNo: Code[10]; iBinCode: Code[20]): Code[20]
    var
    begin
        CreateQualityTestAndSpecifications(ItemNo, VariantCode, '', UoM, LotNo, SerialNo, SpecificationNo, ProdOrderNo, SourceType, SourceNo, SourceLineNo, '', VendorNo, TestQty, SourceNoTracing, RoutingNo, iBinCode);
    end;

    procedure CreateQualityTestAndSpecifications(ItemNo: code[20]; VariantCode: Code[20]; LocationCode: Code[10]; UoM: Code[20]; LotNo: Code[50]; SerialNo: Code[50]; SpecificationNo: Code[20]; ProdOrderNo: Code[20]; SourceType: Enum QCSourceType_PQ; SourceNo: Code[20]; SourceLineNo: Integer; CustomerNo: Code[20]; VendorNo: Code[20]; TestQty: Decimal; SourceNoTracing: Code[20]; RoutingNo: Code[10]; iBinCode: Code[20]): Code[20]
    var
        QualityTestHeader: Record QualityTestHeader_PQ;
        QCSpecificationLines: Record QCSpecificationLine_PQ;
        LotSeriaNo: Code[101];
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
        ValidateLotNo: Boolean;
        ProdOrder: Record "Production Order";
        TrackingType: Option "Lot No.","Serial No.";
        QCSetup: Record QCSetup_PQ;
        QualityTestHeader2: Record QualityTestHeader_PQ;
        ItemQualityReq: Record ItemQualityRequirement_PQ;
    begin
        QCSetup.Get();
        if not QCSetup."Create QT per Item Tracking" then begin
            QualityTestHeader2.Reset();
            QualityTestHeader2.SetRange("Source Type", SourceType);
            QualityTestHeader2.SetRange("Source No.", SourceNo);
            QualityTestHeader2.SetRange("Source Line No.", SourceLineNo);
            QualityTestHeader2.SetRange("Source No. Tracing", SourceNoTracing);
            if (SourceType = SourceType::"Item Journal") OR (SourceType = SourceType::"Output Journal") then begin
                QualityTestHeader2.SetRange("Multiple Tracking", true);
            end;
            if (LotNo = '') and (SerialNo = '') then        //case of not assigning Item tracking => out
                QualityTestHeader2.SetRange("Test No.", '__Temp123456');

            if QualityTestHeader2.FindFirst() then begin
                if ((LotNo <> '') and (QualityTestHeader2."Lot No." <> LotNo)) or ((SerialNo <> '') and (QualityTestHeader2."Serial No." <> SerialNo)) then begin   //case posted partial => out
                    QualityTestHeader2."Multiple Tracking" := true;
                    QualityTestHeader2."Lot No./Serial No." := '';
                    QualityTestHeader2."Test Qty" := QualityTestHeader2."Test Qty" + Abs(TestQty);
                    QualityTestHeader2.Modify();
                    exit(QualityTestHeader2."Test No.");
                end;
            end;
        end;

        ValidateLotNo := false;
        QualityTestHeader.Init();
        QualityTestHeader."Test No." := '';
        QualityTestHeader.Insert(true);

        QualityTestHeader."Specification Type" := SpecificationNo;
        //-new upd by rnd, 23 may 25
        QualityTestHeader.IsPrimary := true;
        //-
        QualityTestHeader.Validate("Item No.", ItemNo);
        QualityTestHeader.Validate("Variant Code", VariantCode);
        QualityTestHeader.Validate("Unit of Measure", UoM);
        if LotNo <> '' then begin
            LotSeriaNo := LotNo;
            QualityTestHeader."Lot No." := LotNo;
        end;

        if iBinCode <> '' then
            QualityTestHeader."Bin Code" := iBinCode;

        if (LotNo <> '') and (SerialNo <> '') then
            LotSeriaNo += ',';

        if SerialNo <> '' then begin
            LotSeriaNo += SerialNo;
            QualityTestHeader."Serial No." := SerialNo;
        end;

        LotNoInfo.Reset();
        LotNoInfo.SetRange("Lot No.", LotSeriaNo);
        if LotNoInfo.FindFirst() then begin
            ValidateLotNo := true;
            QualityTestHeader.setTrackingType(TrackingType::"Lot No.");
        end;

        SerialNoInfo.Reset();
        SerialNoInfo.SetRange("Serial No.", LotSeriaNo);
        if SerialNoInfo.FindFirst() then begin
            ValidateLotNo := true;
            QualityTestHeader.setTrackingType(TrackingType::"Serial No.");
        end;

        if ValidateLotNo then
            QualityTestHeader.Validate("Lot No./Serial No.", LotSeriaNo)
        else
            QualityTestHeader."Lot No./Serial No." := LotSeriaNo;

        QualityTestHeader.Modify(true);

        GetSpecification(QualityTestHeader);

        QualityTestHeader.Validate("Test Status", QualityTestHeader."Test Status"::"Ready for Testing");
        QualityTestHeader."Source No." := GlobalSourceNo;
        QualityTestHeader."Source Line No." := GlobalSourceLineNo;
        QualityTestHeader."Test Qty" := Abs(GlobalTestQty);
        if ProdOrderNo <> '' then begin
            if ProdOrder.Get(ProdOrder.Status::Released, ProdOrderNo) then
                QualityTestHeader."Test Qty" := ProdOrder.Quantity;
        end;
        QualityTestHeader."Prod. Order No." := ProdOrderNo;
        QualityTestHeader."Source Type" := SourceType;
        QualityTestHeader."Source No." := SourceNo;
        QualityTestHeader."Source Line No." := SourceLineNo;
        QualityTestHeader."Vendor No." := VendorNo;
        QualityTestHeader."Customer No." := CustomerNo;
        QualityTestHeader."Test Qty" := Abs(TestQty);
        QualityTestHeader."Source No. Tracing" := SourceNoTracing;
        QualityTestHeader."Routing No." := RoutingNo;
        if (not QCSetup."Create QT per Item Tracking") and ((SourceType = SourceType::"Item Journal") OR (SourceType = SourceType::"Output Journal")) then
            QualityTestHeader."Multiple Tracking" := true;

        //Update by rnd, 17 feb 2025
        Clear(ItemQualityReq);
        ItemQualityReq.SetRange("Item No.", QualityTestHeader."Item No.");
        ItemQualityReq.SetCurrentKey(Type, "Item No.", "Variant Code", "Starting Date");
        ItemQualityReq.SetFilter("Starting Date", '<=%1', Today);
        case
            QualityTestHeader."Source Type" of
            QualityTestHeader."Source Type"::"Output Journal":
                begin
                    ItemQualityReq.SetRange(Type, ItemQualityReq.Type::"Item Output");
                end;
            QualityTestHeader."Source Type"::"Purchase Order":
                begin
                    ItemQualityReq.SetRange(Type, ItemQualityReq.Type::"Purchase Receipt");
                end;
        end;
        if ItemQualityReq.FindFirst() then begin
            if LocationCode = '' then
                QualityTestHeader.Validate("Location Code", ItemQualityReq."Location Code")
            else
                QualityTestHeader.Validate("Location Code", LocationCode);
        end;
        //-

        QualityTestHeader.Modify(true);
        exit(QualityTestHeader."Test No.");
    end;


    //QC200.01 - Moved functions from Page 50711 to Function Library
    procedure GetSpecification(var QualityHeader: Record QualityTestHeader_PQ);
    var
        QCSpecHeader: Record QCSpecificationHeader_PQ;
        QCSpecList: Page QCSpecificationList_PQ;
    begin
        if QualityHeader."Specification Type" = '' then
            QualityHeader."Specification Type" := QCSpecHeader.GetSpecNoFromNonOutputSpecification(QualityHeader."Item No.", QualityHeader."Customer No.", QualityHeader."Category Code");
        QCSpecHeader.SetRange(Status, QCSpecHeader.Status::Certified);
        QCSpecHeader.SetRange("Item No.", QualityHeader."Item No.");
        QCSpecHeader.SetRange("Customer No.", QualityHeader."Customer No.");
        QCSpecHeader.SetRange(Type, QualityHeader."Specification Type");

        if QualityHeader."Customer No." <> '' then
            GetCustSpecs(QualityHeader)
        else
            GetCurrSpecs(QualityHeader);

        QualityHeader.GET(QualityHeader."Test No."); //QC80.1 Added to avoid "Must Reread" Error
        QualityHeader."Test Status" := QualityHeader."Test Status"::New;
        QualityHeader.MODIFY;
    end;
    //QC200.01 - Moved functions from Page 14004601 to Function Library
    procedure GetCurrSpecs(var QualityHeader: Record QualityTestHeader_PQ);
    var
        GetAllSpecs: Boolean;
        QCSetup: Record QCSetup_PQ;
        VersionCode: Code[20];
    begin
        //QC7.3 - Function Added (transferred from original "Action" Code)
        QualityHeader.TESTFIELD("Item No.");

        GetAllSpecs := true; //QC200.01
        VersionCode := GetQCVersion(QualityHeader."Item No.", '', QualityHeader."Specification Type", WORKDATE, 0);  //Origin=0 QCTestCopy
        TestGetSpecs2(QualityHeader, VersionCode, QualityHeader."Specification Type", GetAllSpecs);  //QC71.1 - Added GetAllSpecs Argument
    end;
    //QC200.01 - Moved functions from Page 14004601 to Function Library
    procedure GetCustSpecs(var QualityHeader: Record QualityTestHeader_PQ);
    var
        GetAllSpecs: Boolean;
        QCSetup: Record QCSetup_PQ;
        VersionCode: Code[20];
    begin
        //QC7.3 - Function Added (transferred from original "Action" Code)
        QualityHeader.TESTFIELD("Item No.");
        QualityHeader.TESTFIELD("Customer No.");

        GetAllSpecs := true; //QC200.01
        VersionCode := GetQCVersion(QualityHeader."Item No.", QualityHeader."Customer No.", QualityHeader."Specification Type", WORKDATE, 2);
        TestGetCustSpecs2(QualityHeader, VersionCode, QualityHeader."Specification Type", GetAllSpecs); //QC71.1 - Added GetAllSpecs Argument
    end;

    procedure UpdateExpirationDateOnLotOrSerialNoInformation(Source: Option Lot,Serial; ItemLedgEntry: Record "Item Ledger Entry");
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: Record "Serial No. Information";
    begin
        case Source of
            source::Lot:
                if LotNoInfo.Get(ItemLedgEntry."Item No.", ItemLedgEntry."Variant Code", ItemLedgEntry."Lot No.") then begin
                    LotNoInfo."CCS Expiration Date" := ItemLedgEntry."Expiration Date";
                    LotNoInfo.Modify(false);
                end;
            source::Serial:
                if SerialNoInfo.Get(ItemLedgEntry."Item No.", ItemLedgEntry."Variant Code", ItemLedgEntry."Serial No.") then begin
                    SerialNoInfo."CCS Expiration Date" := ItemLedgEntry."Expiration Date";
                    SerialNoInfo.Modify(false);
                end;
        end;
    end;

    procedure UpdateILEExpirationDateFromLotNoInformation(LotNoInfo: Record "Lot No. Information")
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.SetRange("Item No.", LotNoInfo."Item No.");
        ItemLedgEntry.SetRange("Variant Code", LotNoInfo."Variant Code");
        ItemLedgEntry.SetRange("Lot No.", LotNoInfo."Lot No.");
        ItemLedgEntry.SetFilter("Expiration Date", '<>%1', 0D);
        if ItemLedgEntry.FindSet() then
            ItemLedgEntry.ModifyAll("Expiration Date", LotNoInfo."CCS Expiration Date");
    end;

    procedure UpdateILEExpirationDateFromSerialNoInformation(SerialNoInfo: Record "Serial No. Information")
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.SetRange("Item No.", SerialNoInfo."Item No.");
        ItemLedgEntry.SetRange("Variant Code", SerialNoInfo."Variant Code");
        ItemLedgEntry.SetRange("Serial No.", SerialNoInfo."Serial No.");
        ItemLedgEntry.SetFilter("Expiration Date", '<>%1', 0D);
        if ItemLedgEntry.FindSet() then
            ItemLedgEntry.ModifyAll("Expiration Date", SerialNoInfo."CCS Expiration Date");
    end;

    procedure InitQualityTestData(SourceNo: Code[20]; SourceLineNo: Integer; TestQty: Decimal)
    begin
        GlobalSourceNo := SourceNo;
        GlobalSourceLineNo := SourceLineNo;
        GlobalTestQty := TestQty;
    end;

    procedure QualityTestExistsForSalesLine(SourceNo: Code[20]; SourceLineNo: Integer; ItemNo: Code[20]; LotNo: Code[50]; SerialNo: Code[50]): Boolean
    var
        QCTestHeader: Record QualityTestHeader_PQ;
    begin
        QCTestHeader.SetRange("Source No.", SourceNo);
        QCTestHeader.SetRange("Source Line No.", SourceLineNo);
        QCTestHeader.SetRange("Item No.", ItemNo);
        if (LotNo <> '') and (SerialNo <> '') then begin
            QCTestHeader.SetRange("Lot No./Serial No.", LotNo + ',' + SerialNo);
        end else begin
            if LotNo <> '' then
                QCTestHeader.SetRange("Lot No./Serial No.", LotNo);
            if SerialNo <> '' then
                QCTestHeader.SetRange("Lot No./Serial No.", SerialNo);
        end;
        if QCTestHeader.FindFirst() then
            exit(true);

        exit(false);
    end;

    procedure QualityTestExistsForSalesLine2(SourceNo: Code[20]; SourceLineNo: Integer; ItemNo: Code[20]; LotNo: Code[50]; SerialNo: Code[50]; RoutingNo: Code[10]): Boolean
    var
        QCTestHeader: Record QualityTestHeader_PQ;
    begin
        QCTestHeader.SetRange("Source No.", SourceNo);
        QCTestHeader.SetRange("Source Line No.", SourceLineNo);
        QCTestHeader.SetRange("Item No.", ItemNo);
        QCTestHeader.SetRange("Routing No.", RoutingNo);
        if LotNo <> '' then
            QCTestHeader.SetRange("Lot No.", LotNo);
        if SerialNo <> '' then
            QCTestHeader.SetRange("Serial No.", SerialNo);

        if QCTestHeader.FindFirst() then
            exit(true);

        exit(false);
    end;

    procedure VerifyAndCreateQualityTestsForSales(SourceNo: Code[20]; SourceLineNo: Integer)
    var
        SalesLine: Record "Sales Line";
        ReservEntry: Record "Reservation Entry";
        //QCTransactionArea: Record "AM Transaction Area";
        QCSpecHeader: Record QCSpecificationHeader_PQ;
        TempLotAndSerials: Record "User Preference" temporary;
        SpecificationNo: Code[20];
        LotOrSerialNo: Code[101];
        QCRequired: Boolean;
        QualityType: Enum ItemQualityRequirement_PQ;
        CodeunitSubscribers: Codeunit QCCodeunitSubscribers_PQ;
    begin
        if not SalesLine.Get(SalesLine."Document Type"::Order, SourceNo, SourceLineNo) then
            exit;
        /*
        QCTransactionArea.SetRange("Transaction Area", QCTransactionArea."Transaction Area"::Sales);
        if not QCTransactionArea.FindFirst() then
            exit;
        */
        /*
        SpecificationNo := QCSpecHeader.GetSpecNoFromNonOutputSpecification(SalesLine."No.", SalesLine."Bill-to Customer No.", Format(QualityType::"Sales Shipment"));

        if SpecificationNo = '' then
            SpecificationNo := QCSpecHeader.GetSpecNoFromNonOutputSpecification(SalesLine."No.", '', Format(QualityType::"Sales Shipment"));

        if SpecificationNo = '' then
            exit;
        */
        SpecificationNo := CodeunitSubscribers.GetSpecificationFromItemQualityRequirement(QualityType::"Sales Shipment", SalesLine."No.", SalesLine."Variant Code", SalesLine."Location Code");
        if SpecificationNo = '' then
            exit;

        if VerifyValidQualitySpecification2(SalesLine."No.", '', QCRequired, SpecificationNo) and (QCRequired) then begin
            ReservEntry.SetRange("Source Type", Database::"Sales Line");
            ReservEntry.SetRange("Source Subtype", SalesLine."Document Type");
            ReservEntry.SetRange("Source ID", SalesLine."Document No.");
            ReservEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
            ReservEntry.SetRange("Item No.", SalesLine."No.");
            ReservEntry.SetRange("Variant Code", SalesLine."Variant Code");
            ReservEntry.SetFilter(Quantity, '<%1', 0);
            ReservEntry.SetFilter("Item Tracking", '%1|%2|%3', ReservEntry."Item Tracking"::"Lot and Serial No.", ReservEntry."Item Tracking"::"Lot No.", ReservEntry."Item Tracking"::"Serial No.");
            if ReservEntry.FindSet() then
                repeat
                    // 1. Verify if a quality test already exists for the specified lot or serial no. DONE
                    // 2. if it doesn't exist, then create one.  DONE
                    // 3. save all the lot and serial no. found, so we can detect if a lot or serial has been deleted, so we can delete the quality test associated
                    // 4. when we create the quality test, we need to send the source no. so it gets linked to the original sales order  DONE
                    LotOrSerialNo := '';

                    InitQualityTestData(SalesLine."Document No.", SalesLine."Line No.", Abs(ReservEntry.Quantity));
                    if not QualityTestExistsForSalesLine(SalesLine."Document No.", SalesLine."Line No.", SalesLine."No.", ReservEntry."Lot No.", ReservEntry."Serial No.") then
                        CreateQualityTestAndSpecifications(SalesLine."No.", SalesLine."Variant Code", SalesLine."Unit of Measure Code", ReservEntry."Lot No.", ReservEntry."Serial No.", SpecificationNo,
                         '', QCSourceType_PQ::"Sales Order", SalesLine."Document No.", SalesLine."Line No.", '', Abs(ReservEntry.Quantity), SalesLine."Document No.", '', '');

                    if (ReservEntry."Lot No." <> '') and (ReservEntry."Serial No." <> '') then begin
                        LotOrSerialNo := ReservEntry."Lot No." + ',' + ReservEntry."Serial No.";
                    end else begin
                        if ReservEntry."Lot No." <> '' then
                            LotOrSerialNo := ReservEntry."Lot No.";
                        if ReservEntry."Serial No." <> '' then
                            LotOrSerialNo := ReservEntry."Serial No.";
                    end;

                    if not TempLotAndSerials.Get(LotOrSerialNo, '') then begin
                        TempLotAndSerials.Init;
                        TempLotAndSerials."User ID" := LotOrSerialNo;
                        TempLotAndSerials.Insert;
                    end;

                    // Block Lot/Serial No. Information Card
                    if QCRequired then
                        BlockLotAndSerialNoInformation3(ReservEntry."Item No.", ReservEntry."Variant Code", ReservEntry."Lot No.", ReservEntry."Serial No.", ReservEntry."Expiration Date", true, '');
                until ReservEntry.Next = 0;

            VerifyAndUpdateRelatedQualityTests(SalesLine, TempLotAndSerials);

        end;
    end;

    procedure VerifyAndUpdateRelatedQualityTests(SalesLine: Record "Sales Line"; var TempLotAndSerials: Record "User Preference" temporary)
    var
        QCTestHeader: Record QualityTestHeader_PQ;
        QCTestLines: Record QualityTestLines_PQ;
        QCTestComments: Record QCTestHeaderComment_PQ;
        QCTestLineComments: Record QCTestLineComment_PQ;
    begin
        QCTestHeader.SetRange("Source No.", SalesLine."Document No.");
        QCTestHeader.SetRange("Source Line No.", SalesLine."Line No.");
        QCTestHeader.SetFilter("Test Status", '<%1', QCTestHeader."Test Status"::Certified);
        if QCTestHeader.FindSet() then
            repeat
                if (not TempLotAndSerials.Get(QCTestHeader."Lot No./Serial No.", '')) and (not QCTestHeader."Multiple Tracking") then begin
                    QCTestLines.SetRange("Test No.", QCTestHeader."Test No.");
                    if QCTestLines.FindSet() then
                        QCTestLines.DeleteAll(false);

                    QCTestComments.SetRange("Test No.", QCTestHeader."Test No.");
                    if QCTestComments.FindSet() then
                        QCTestComments.DeleteAll(false);

                    QCTestLineComments.SetRange("Test No.", QCTestHeader."Test No.");
                    if QCTestLineComments.FindSet() then
                        QCTestLineComments.DeleteAll(false);

                    RestoreLatestLotAndSerialStatus(SalesLine, QCTestHeader);

                    QCTestHeader.Delete;
                end;
            until QCTestHeader.Next() = 0;
    end;

    local procedure RestoreLatestLotAndSerialStatus(SalesLine: Record "Sales Line"; QCTestHeader: Record QualityTestHeader_PQ)
    var
        LotNoInfo: Record "Lot No. Information";
        SerialNoInfo: REcord "Serial No. Information";
    begin
        if StrPos(QCTestHeader."Lot No./Serial No.", ',') = 0 then begin
            if LotNoInfo.Get(SalesLine."No.", SalesLine."Variant Code", QCTestHeader."Lot No./Serial No.") then begin
                LotNoInfo.Validate("CCS Status", LotNoInfo."CCS Latest Status");
                LotNoInfo.Modify();
            end else begin
                if SerialNoInfo.Get(SalesLine."No.", SalesLine."Variant Code", QCTestHeader."Lot No./Serial No.") then begin
                    SerialNoInfo.Validate("CCS Status", SerialNoInfo."CCS Latest Status");
                    SerialNoInfo.Modify();
                end;
            end;
        end else begin
            if LotNoInfo.Get(SalesLine."No.", SalesLine."Variant Code", SelectStr(1, QCTestHeader."Lot No./Serial No.")) then begin
                LotNoInfo.Validate("CCS Status", LotNoInfo."CCS Latest Status");
                LotNoInfo.Modify();
            end;
            if SerialNoInfo.Get(SalesLine."No.", SalesLine."Variant Code", SelectStr(2, QCTestHeader."Lot No./Serial No.")) then begin
                SerialNoInfo.Validate("CCS Status", SerialNoInfo."CCS Latest Status");
                SerialNoInfo.Modify();
            end;
        end;
    end;

    procedure VerifyAndCreateQualityTestsForSalesPicking(WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        SalesLine: Record "Sales Line";
        //QCTransactionArea: Record "AM Transaction Area";
        QCSpecHeader: Record QCSpecificationHeader_PQ;
        SpecificationNo: Code[20];
        QCRequired: Boolean;
        QualityType: Enum ItemQualityRequirement_PQ;
    begin
        if not SalesLine.Get(WarehouseActivityLine."Source Subtype", WarehouseActivityLine."Source No.", WarehouseActivityLine."Source Line No.") then
            exit;
        /*
        QCTransactionArea.SetRange("Transaction Area", QCTransactionArea."Transaction Area"::Sales);
        if not QCTransactionArea.FindFirst() then
            exit;
        */

        SpecificationNo := QCSpecHeader.GetSpecNoFromNonOutputSpecification(SalesLine."No.", SalesLine."Bill-to Customer No.", Format(QualityType::"Sales Shipment"));

        if SpecificationNo = '' then
            SpecificationNo := QCSpecHeader.GetSpecNoFromNonOutputSpecification(SalesLine."No.", '', Format(QualityType::"Sales Shipment"));

        if SpecificationNo = '' then
            exit;

        if VerifyValidQualitySpecification2(SalesLine."No.", '', QCRequired, SpecificationNo) and (QCRequired) then begin
            InitQualityTestData(SalesLine."Document No.", SalesLine."Line No.", Abs(WarehouseActivityLine."Qty. to Handle"));
            if not QualityTestExistsForSalesLine(SalesLine."Document No.", SalesLine."Line No.", SalesLine."No.", WarehouseActivityLine."Lot No.", WarehouseActivityLine."Serial No.") then
                CreateQualityTestAndSpecifications(SalesLine."No.", SalesLine."Variant Code", SalesLine."Unit of Measure Code", WarehouseActivityLine."Lot No.", WarehouseActivityLine."Serial No.", SpecificationNo,
                '', QCSourceType_PQ::"Sales Order", SalesLine."Document No.", SalesLine."Line No.", '', Abs(WarehouseActivityLine."Qty. to Handle"), SalesLine."Document No.", '', '');

            // Block Lot/Serial No. Information Card
            if QCRequired then
                BlockLotAndSerialNoInformation3(WarehouseActivityLine."Item No.", WarehouseActivityLine."Variant Code", WarehouseActivityLine."Lot No.", WarehouseActivityLine."Serial No.", WarehouseActivityLine."Expiration Date", true, '');

            // this line doesn't go here because of the situational event, it will go on the OnValidate "Lot No." or "Serial No." from the activity line
            //VerifyAndUpdateRelatedQualityTests(SalesLine, TempLotAndSerials);
        end;
    end;

    procedure VerifyAndUpdateRelatedQualityTestsForPicking(WhseActivityLine: Record "Warehouse Activity Line"; LotNo: Code[50]; SerialNo: Code[50])
    var
        QCTestHeader: Record QualityTestHeader_PQ;
        QCTestLines: Record QualityTestLines_PQ;
        QCTestComments: Record QCTestHeaderComment_PQ;
        QCTestLineComments: Record QCTestLineComment_PQ;
        SalesLine: Record "Sales Line";
        LotOrSerialNo: Code[101];
    begin
        if (LotNo <> '') and (SerialNo <> '') then begin
            LotOrSerialNo := LotNo + ',' + SerialNo;
        end else begin
            if LotNo <> '' then
                LotOrSerialNo := LotNo;
            if SerialNo <> '' then
                LotOrSerialNo := SerialNo;
        end;

        /* Add by rnd 22 Jan 26, this is old code and what the puspose (?)
        QCTestHeader.SetRange("Source No.", WhseActivityLine."Source No.");
        QCTestHeader.SetRange("Source Line No.", WhseActivityLine."Source Line No.");
        QCTestHeader.SetFilter("Test Status", '<%1', QCTestHeader."Test Status"::Certified);
        QCTestHeader.SetRange("Lot No./Serial No.", LotOrSerialNo);
        if QCTestHeader.FindSet() then begin
            QCTestLines.SetRange("Test No.", QCTestHeader."Test No.");
            if QCTestLines.FindSet() then
                QCTestLines.DeleteAll(false);

            QCTestComments.SetRange("Test No.", QCTestHeader."Test No.");
            if QCTestComments.FindSet() then
                QCTestComments.DeleteAll(false);

            QCTestLineComments.SetRange("Test No.", QCTestHeader."Test No.");
            if QCTestLineComments.FindSet() then
                QCTestLineComments.DeleteAll(false);

            SalesLine.Get(WhseActivityLine."Source Subtype", WhseActivityLine."Source No.", WhseActivityLine."Source Line No.");

            QCTestHeader.Delete;
        end;
        */
    end;

    [IntegrationEvent(false, false)]
    local procedure TestGetSpecs2OnBeforeInsertQCTestLines(var QltyTestLines: Record QualityTestLines_PQ; QCSpecLn: Record QCSpecificationLine_PQ)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateLotOrSerialNoInformation(var LotInformation: Record "Lot No. Information"; var ItemLedgEntry: Record "Item Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure TestGetCustSpecs2OnBeforeInsertQCTestLines(var QltyTestLines: Record QualityTestLines_PQ; QCSpecLn: Record QCSpecificationLine_PQ)
    begin
    end;
}
