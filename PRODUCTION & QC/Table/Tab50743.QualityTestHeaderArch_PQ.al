table 50743 QualityTestHeaderArch_PQ
{
    // version QC10.2

    // Key: Lot No.,Test Date  added for R14004593
    // Key: Item No.,Lot No.   added for R14004594
    //
    // //QC37.05   Adding Serial No.
    //             Added new field called Tracking Type
    //             Changed the Table Relationship for the Lot No. field.
    //             Changed the name of Lot No. field to Lot No./Serial No.
    //             Added Code on the Item No. field to set the Tracking Type field behind the scenes.
    //             Added Code to Tracking Qty. ... serial No.s should be one
    //             Removed the word Lot out of the table name.
    //
    // //QC4SP1.2  Added Customer No.
    //             Used when on Test Header and want to copy the Customer Specifications
    //
    // //QC3.70  Added field 50 Tracking Type
    // //QC5.01  Added code on the Test Status field OnValidate
    //
    // QC7.2
    //   - Changed Field Name "Qty Inspected" to "Test Qty"
    //   - Changed Fields "Test Date" and "Test Time" to FlowFields, and changed Names to "Test Start Date" and "Test Start Time"
    //   - Added "Failed" Flowfield
    //
    // QC7.3
    //   - Added "Test Description", "Test Description 2" Fields (see Specification Header table)
    //   - Added "Item Description" and "Customer Name" FlowFields
    //   - Changed "Item No." and "Customer No." to NON-Editable
    //
    // QC7.4
    //   - Removed Test/Error for Deleting Test if Not "Rejected" Status
    //
    // //QC7.4
    //   - Updated "Test Status" to handle "New" Status Options
    //     - Options Were:
    //       - New,In-Process,Certified,Rejected,Closed
    //     - Options Are Now:
    //       - New,Ready for Testing,In-Process,Ready for Review,Certified,Certified with Waiver,Certified Final,,,,,,,Rejected,Closed
    //   - Created Function to Create a Test Header Comment when "Test Status" is Changed
    //
    // QC71.1
    //   - Added Field "Expected Blend Test Date" (Is this redundant with the above?)
    //   - Created New Functions "CheckLineStatuses" and "ChangeTestStatus", then placed Re-worked Logic from "Test Status" OnValidate in there
    //   - Incorporated new User Setup Boolean "Quality Manager" and CheckLineStatuses Result into the "ChangeTestStatus" Function
    //   - Created new Function "CheckStatusRules", and Modified "Test Status" OnValidate, plus Functions "CheckLineStatuses" and "ChangeTestStatus" to use this this
    //   - Increased all "User Name" fields to 50 length
    //   - Added new Field "Test Type" (from Spec. Header)
    //
    // QC7.7
    //   - REMoved a couple of lines in the OnValidate Trigger of "Lot No./Ser. No.". Seemed to be getting wiped out on Item-Only Lot Tests
    //
    // QC71.3
    //   - Renumbered Fields 50k to 60k down to the 100-? Range
    //
    // QC80.1
    //   - Changes to Allow "Test Line Complete" to permit an "Actual Measure" of Zero for a "Completed" Test Line
    //     - Added Code to "CheckLineStatuses" Function
    //
    // QC10.2
    //   - Changed OnLookup of "Lot No./Serial No." Field to use Item Ledger Entry Table
    // QC200.1
    //   - Update "Test Status" for unblocking the "Lot No." or "Serial No." information card

    Caption = 'Quality Test Header';
    DataCaptionFields = "Test No.", "Item No.", "Lot No.";
    DrillDownPageID = QCTestListArch_PQ;
    LookupPageID = QCTestListArch_PQ;

    fields
    {
        field(1; "Test No."; Code[20])
        {
            Description = 'Key';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Test No." <> xRec."Test No." then begin
                    QCSetup.GET;
                    NoSeriesMgt.TestManual(QCSetup."QC Test No. Series");
                    "No. Series" := '';
                end;

                "Entered By" := USERID;
            end;
        }
        field(2; "Item No."; Code[20])
        {
            TableRelation = Item."No." WHERE("Has Quality Specifications" = FILTER(true));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
                if "Item No." <> xRec."Item No." then begin
                    TestLinesT.SETRANGE("Test No.", "Test No.");
                    if TestLinesT.FIND('-') then
                        repeat
                            TestLinesT."Item No." := "Item No.";
                            TestLinesT.MODIFY;
                        until TestLinesT.NEXT = 0;
                end;

                //QC37.05
                ItemT.GET("Item No.");
                if ItemT."Serial Nos." <> '' then
                    "Tracking Type" := "Tracking Type"::"Serial No.";     //..else defaults in as Lot No.

                if "Tracking Type" = "Tracking Type"::"Serial No." then
                    "Test Qty" := 1;

                if "Unit of Measure" = '' then
                    "Unit of Measure" := ItemT."Base Unit of Measure";
                //end QC37.05

                if "Item No." <> '' then
                    "Spec Version Used" := QualitySpecsCopy.GetQCVersion("Item No.", '', "Specification Type", WORKDATE, 1);  //Origin=1=PrimarySpecCard

                "Test Description" := ItemT.Description;
            end;
        }
        field(3; "Lot No./Serial No."; Code[101])
        {
            TableRelation = IF ("Tracking Type" = CONST("Lot No.")) "Lot No. Information"."Lot No." WHERE("Item No." = FIELD("Item No."))
            ELSE
            IF ("Tracking Type" = CONST("Serial No.")) "Serial No. Information"."Serial No." WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;

            trigger OnLookup();
            var
                LotSNLookup: Page ItemLotandSerialLookup_PQ;
                ItemLedgEntry: Record "Item Ledger Entry";
                LotNoInfo: Record "Lot No. Information";
                SerialNoInfo: Record "Serial No. Information";
                ValidateLotNo: Boolean;
            begin
                //QC10.2 Code Added
                ValidateLotNo := false;
                CLEAR(LotSNLookup);
                if "Item No." <> '' then begin
                    ItemLedgEntry.SETRANGE("Item No.", "Item No.");
                    ItemLedgEntry.SETFILTER("Item Tracking", '<>%1', ItemLedgEntry."Item Tracking"::None);
                    if ItemLedgEntry.FINDFIRST then;
                    LotSNLookup.LOOKUPMODE(true);
                    LotSNLookup.SETTABLEVIEW(ItemLedgEntry);
                    LotSNLookup.SETRECORD(ItemLedgEntry);
                    if LotSNLookup.RUNMODAL = ACTION::LookupOK then begin
                        LotSNLookup.GETRECORD(ItemLedgEntry);
                        "Lot No./Serial No." := ItemLedgEntry."Lot No.";
                        if (("Lot No./Serial No." <> '') and (ItemLedgEntry."Serial No." <> '')) then
                            "Lot No./Serial No." := "Lot No./Serial No." + ', ';
                        "Lot No./Serial No." := "Lot No./Serial No." + ItemLedgEntry."Serial No.";

                        LotNoInfo.Reset();
                        LotNoInfo.SetRange("Lot No.", "Lot No./Serial No.");
                        if LotNoInfo.FindFirst() then
                            ValidateLotNo := true;

                        SerialNoInfo.Reset();
                        SerialNoInfo.SetRange("Serial No.", "Lot No./Serial No.");
                        if SerialNoInfo.FindFirst() then
                            ValidateLotNo := true;

                        if ValidateLotNo then
                            Validate("Lot No./Serial No.")
                        else begin
                            TestStatus;
                            TestLinesT.SETRANGE("Test No.", "Test No.");
                            if TestLinesT.FIND('-') then
                                repeat
                                    TestLinesT."Lot No./Serial No." := "Lot No./Serial No.";
                                    TestLinesT.MODIFY;
                                until TestLinesT.NEXT = 0;

                            if "Test Status" = "Test Status"::New then
                                UpdateLotOrSerialInformation2(true, false);
                        end;
                    end;
                end;
            end;

            trigger OnValidate();
            begin
                TestStatus;
                TestLinesT.SETRANGE("Test No.", "Test No.");
                if TestLinesT.FIND('-') then
                    repeat
                        TestLinesT."Lot No./Serial No." := "Lot No./Serial No.";
                        TestLinesT.MODIFY;
                    until TestLinesT.NEXT = 0;

                //QC10.2 REM-OUT
                // // Variant Code is set for a range because current QC does not use Variant Codes.
                // // The following code is designed to capture all Variant Codes.
                // // Even though one Lot No. should generally be of one Variant Code, that Variant Code may not be blank.
                // // The premise is: for every unique Item# / Lot# combination, there should only be one Variant Code.
                // "Qty at Test-Time" := 0;
                // LotNumInfo.SETFILTER("Item No.","Item No.");
                // LotNumInfo.SETFILTER("Lot No.","Lot No./Serial No.");
                // IF LotNumInfo.FIND('-') THEN
                //  REPEAT
                //   LotNumInfo.CALCFIELDS("Qty on Hand");
                //   "Qty at Test-Time" := "Qty at Test-Time" + LotNumInfo."Qty on Hand";
                //  UNTIL LotNumInfo.NEXT = 0;

                //QC200.1 Update the lot/serial no. information if it is a new "manual" Quality test
                if "Test Status" = "Test Status"::New then
                    UpdateLotOrSerialInformation2(true, false);
            end;
        }
        field(4; "Test Start Date"; Date)
        {
            CalcFormula = Min(QualityTestLines_PQ."Date Inspected" WHERE("Test No." = FIELD("Test No."),
                                                                               "Date Inspected" = FILTER(<> '')));
            Description = 'QC7.2 Changed to FlowField';
            FieldClass = FlowField;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(5; "Test Start Time"; Time)
        {
            CalcFormula = Min(QualityTestLines_PQ."Time Inspected" WHERE("Test No." = FIELD("Test No."),
                                                                               "Date Inspected" = FILTER(<> '')));
            Description = 'QC7.2 Changed to FlowField';
            FieldClass = FlowField;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(6; "Test Qty"; Decimal)
        {
            Caption = 'Qty. to Test';
            Description = 'QC7.2 Name Changed from Qty Inspected';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
                //QC37.05
                if "Test Qty" > 1 then
                    if "Tracking Type" = "Tracking Type"::"Serial No." then
                        ERROR(Text004);
            end;
        }
        field(7; "Unit of Measure"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(8; "Tested By"; Code[50])
        {
            Description = 'User ID';
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(9; "Entered By"; Code[50])
        {
            Description = 'User ID Auto Stamp';
            Editable = false;
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(10; "Test Status"; Option)
        {
            OptionCaption = 'New,Ready for Testing,In-Process,Ready for Review,Certified,,,,,,,Rejected,Closed,Hold';
            OptionMembers = New,"Ready for Testing","In-Process","Ready for Review",Certified,,,,,,,Rejected,Closed,Hold;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin

                //QC71.1 Start
                ChangeTestStatus("Test Status"); //Check and Change Status (on Lines, too), if Requirements are met, else, Roll-Back the Change
                //QC71.1 Finish
                //QC200.1 Start
                case "Test Status" of
                    "Test Status"::New, "Test Status"::"In-Process", "Test Status"::"Ready for Review", "Test Status"::Hold, "Test Status"::Rejected, "Test Status"::"Ready for Testing":
                        begin
                            UpdateLotOrSerialInformation2(true, false);
                            if "Test Status" = "Test Status"::"In-Process" then
                                UpdateProdRoutingLineStatus(2);
                        end;
                    "Test Status"::Certified, "Test Status"::Closed:
                        begin
                            if "Test Status" <> "Test Status"::Closed then begin
                                checkNonConformance(Rec."Test No.");
                                UpdateLotOrSerialInformation2(false, true);
                            end else
                                UpdateLotOrSerialInformation2(false, false);
                            UpdateProdRoutingLineStatus(3); // OptionMembers = " ",Planned,"In Progress",Finished;
                        end;
                end;
                //QC200.1 Finish
            end;
        }
        field(11; "No. Series"; Code[10])
        {
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(20; "Customer No."; Code[20])
        {
            Description = 'QC4SP1.2';
            Editable = false;
            TableRelation = Customer."No.";
            DataClassification = CustomerContent;
        }
        field(22; "Comment"; Boolean)
        {
            CalcFormula = Exist(QCTestHeaderComment_PQ WHERE("Test No." = FIELD("Test No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Creation Date"; Date)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(43; "Last Date Modified"; Date)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(44; "Spec Version Used"; Code[20])
        {
            Description = 'Non editable';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(45; "Qty at Test-Time"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Tracking Type"; Option)
        {
            OptionMembers = "Lot No.","Serial No.";
            DataClassification = CustomerContent;
        }
        field(51; "Failed"; Boolean)
        {
            CalcFormula = Exist(QualityTestLines_PQ WHERE("Test No." = FIELD(FILTER("Test No.")),
                                                                "Non-Conformance" = CONST(true)));
            Description = 'QC7.2 FlowField Added';
            FieldClass = FlowField;
        }
        field(52; "Test Description"; Text[100])
        {
            Description = 'QC7.3 Added';
            DataClassification = CustomerContent;
        }
        field(53; "Test Description 2"; Text[100])
        {
            Description = 'QC7.3 Added';
            DataClassification = CustomerContent;
        }
        field(54; "Item Description"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Description = 'QC7.3 FlowField Added';
            FieldClass = FlowField;
        }
        field(55; "Customer Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Description = 'QC7.3 FlowField Added';
            FieldClass = FlowField;
        }
        field(100; "Test Control Date"; Date)
        {
            Description = 'NP1 Added';
            DataClassification = CustomerContent;
        }
        field(101; "Expected Blend Date"; Date)
        {
            Description = 'NP1 Added';
            DataClassification = CustomerContent;
        }
        field(102; "Test Type"; Option)
        {
            Description = 'QC71.1 Added';
            OptionMembers = "Lot/SN",,,,,"In-Line";
            DataClassification = CustomerContent;
        }
        field(103; "Has Specifications"; Boolean)
        {
            CalcFormula = Lookup(Item."Has Quality Specifications" WHERE("No." = FIELD("Item No.")));
            Description = 'Flowfield to Item';
            FieldClass = FlowField;
        }
        field(104; "Status"; Option)
        {
            CalcFormula = Lookup(Item."QC Spec Status" WHERE("No." = FIELD("Item No.")));
            Description = 'flowfield to Item';
            FieldClass = FlowField;
            OptionMembers = New,Certified,"Under Development",Closed;
        }
        field(105; "Specification Type"; Code[20])
        {
            Caption = 'Specification No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(106; "Category Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Category Code';
            TableRelation = SpecificationCategory_PQ;
        }
        field(107; "Source Type"; Enum QCSourceType_PQ)
        {
            DataClassification = CustomerContent;
            Caption = 'Source Type';
            // Editable = false;
        }
        field(108; "Source No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Source No.';
            // Editable = false;
        }
        field(109; "Source Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Source Line No.';
            Editable = false;
        }
        field(110; "Prod. Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Prod. Order No.';
            Editable = false;
        }
        field(111; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';
            Editable = false;
        }
        field(112; "Multiple Tracking"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Multiple Tracking';
            Editable = false;
        }
        field(113; "Source No. Tracing"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Source No. Tracing';
            Editable = false;
        }
        field(114; "Lot No."; Code[50])
        {
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Item No."));
            DataClassification = CustomerContent;
            Caption = 'Lot No.';
            Editable = true;
        }
        field(115; "Serial No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Serial No.';
            Editable = false;
        }
        field(116; "Operation No."; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Prod. Order Routing Line"."Operation No." WHERE("Prod. Order No." = field("Source No."),
                                                                                "CCS Spec. Type ID" = field("Specification Type"),
                                                                                "Operation No." = field("Routing No.")));
            Caption = 'Operation No';
            Editable = false;
        }
        field(117; "Operation Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Prod. Order Routing Line".Description WHERE("Prod. Order No." = field("Source No."),
                                                                                "CCS Spec. Type ID" = field("Specification Type"),
                                                                                "Operation No." = field("Routing No.")));
            Caption = 'Description';
            Editable = false;
        }
        field(118; "Routing No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Routing No.';
            Editable = false;
        }
        field(119; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ItemVariant: Record "Item Variant";
            begin
                ItemVariant.SetRange("Item No.", "Item No.");
                ItemVariant.SetRange(Code, "Variant Code");
                if ItemVariant.FindFirst() then begin
                    "Test Description" := ItemVariant.Description;
                end;
            end;
        }
        // field(120; "Certified Quantity"; Decimal)
        // {
        //     DataClassification = CustomerContent;
        //     Caption = 'Certified Quantity';
        //     Editable = false;

        //     trigger OnValidate();
        //     var
        //         NegativeErr: Label 'Please ensure this Certified Quantity field is non-negative';
        //     begin
        //         TestStatus();
        //         if "Certified Quantity" < 0 then
        //             Error(NegativeErr);
        //     end;
        // }
        field(121; "Qty. on Transf. Order"; Decimal)
        {
            Caption = 'Qty. on Transf. Order';
            CalcFormula = lookup("Transfer Line".Quantity where("Document No." = field("Transfer No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(122; "Qty. on Return Order"; Decimal)
        {
            Caption = 'Qty. on Return Order';
            CalcFormula = lookup("Purchase Line".Quantity where("Document Type" = field("Purchase Document Type"),
                                                                "Document No." = field("Purchase Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(123; "Qty. on Scrap Line"; Decimal)
        {
            Caption = 'Qty. on Scrap Line';
            CalcFormula = lookup("Item Journal Line".Quantity where("Journal Template Name" = field("Item Journal Template Name"),
                                                                    "Journal Batch Name" = field("Item Journal Batch Name"),
                                                                    "Line No." = field("Item Journal Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(124; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            CalcFormula = LOOKUP(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(125; "Purchase Document Type"; Enum "Purchase Document Type")
        {
            DataClassification = CustomerContent;
        }
        field(126; "Purchase Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(127; "Transfer No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(128; "Item Journal Template Name"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(129; "Item Journal Batch Name"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(130; "Item Journal Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(131; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(132; "Qty. to Transfer"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. to Transfer';

            trigger OnValidate()
            var
                TransferHeader: Record "Transfer Header";
            begin
                TestStatus();
                CheckQuantityExceeded();

                if TransferHeader.Get("Transfer No.") then begin
                    Error(Text016, FieldCaption("Qty. to Transfer"), TransferHeader.TableCaption);
                end;
            end;
        }
        field(133; "Qty. to Return"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. to Return';

            trigger OnValidate()
            var
                PurchaseHeader: Record "Purchase Header";
            begin
                TestStatus();
                CheckQuantityExceeded();

                PurchaseHeader.SetRange("Document Type", "Purchase Document Type");
                PurchaseHeader.SetRange("No.", "Purchase Document No.");
                if PurchaseHeader.FindFirst() then begin
                    Error(Text016, FieldCaption("Qty. to Return"), PurchaseHeader."Document Type"::"Return Order");
                end;
            end;
        }
        field(134; "Qty. to Scrap"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. to Scrap';

            trigger OnValidate()
            var
                ItemJournalLine: Record "Item Journal Line";
            begin
                TestStatus();
                CheckQuantityExceeded();

                if ItemJournalLine.Get("Item Journal Template Name", "Item Journal Batch Name", "Item Journal Line No.") then begin
                    Error(Text016, FieldCaption("Qty. to Scrap"), ItemJournalLine.TableCaption);
                end;
            end;
        }
        //additional coloumn 
        field(135; "Qty. Hold"; Decimal) { }
        field(136; "Qty. Test Shift 1"; Decimal) { }
        field(137; "Qty. Test Shift 2"; Decimal) { }
        field(138; "Qty. Sample"; Decimal) { }
        field(139; "Qty. Actual Test"; Decimal) { }
        field(140; "Qty. NG"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("New Detail NG QT V1 PQ".Quantity where("QT No." = field("Test No.")));
            Editable = false;
        }
        field(141; "Production Line"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Production Order"."Production Line" where("No." = field("Source No.")));
        }
        field(142; "Qty. Repair"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detail Repair QT PQ".Quantity where("QT No." = field("Test No.")));
            Editable = false;
        }
        field(143; "Status Transfer"; Enum "Status Trasfer QT")
        {

        }
        field(144; "Sample Scrap Status"; Boolean)
        {

        }
        field(145; "NG Scrap Status"; Boolean)
        {

        }
        field(146; "Cycle"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Production Order"."Vacum Cycle" where("No." = field("Source No.")));
        }
        field(147; IsPrimary; Boolean)
        {
            Caption = 'Primary (?)';
        }
        field(148; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
        }
        //-
    }

    keys
    {
        key(Key1; "Test No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.", "Lot No./Serial No.")
        {
        }
        key(Key3; "Lot No./Serial No.")
        {
        }
        key(Key4; "Item No.", "Test No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Test No.", "Item No.", "Item Description")
        {
        }
    }

    trigger OnDelete();
    begin
        //QC71.1 Start

        if QualityFunctions.TestQCMgr then begin
            if (("Test Status" = "Test Status"::Rejected) or ("Test Status" = "Test Status"::Closed)) then begin
                TestLinesT.SETRANGE("Test No.", "Test No.");
                if TestLinesT.FindSet() then
                    TestLinesT.DELETEALL(true);

                TestHeaderComments.SETRANGE("Test No.", "Test No.");
                if TestHeaderComments.FindSet() then
                    TestHeaderComments.DELETEALL;
            end else
                ERROR(Text010); //Abort the Delete
        end else
            ERROR(Text011); //Abort if Not Quality Manager
        //QC71.1 Finish
    end;

    trigger OnInsert();
    begin
        if "Test No." = '' then begin
            QCSetup.GET;
            QCSetup.TESTFIELD("QC Test No. Series");
            // NoSeriesMgt.InitSeries(QCSetup."QC Test No. Series", xRec."No. Series", 0D, "Test No.", "No. Series");
            "Test No." := NoSeriesMgt.GetNextNo(QCSetup."QC Test No. Series", 0D, true);
        end;

        if GETFILTER("Item No.") <> '' then
            if GETRANGEMIN("Item No.") = GETRANGEMAX("Item No.") then
                VALIDATE("Item No.", GETRANGEMIN("Item No."));

        if GETFILTER("Lot No./Serial No.") <> '' then
            if GETRANGEMIN("Lot No./Serial No.") = GETRANGEMAX("Lot No./Serial No.") then
                VALIDATE("Lot No./Serial No.", GETRANGEMIN("Lot No./Serial No."));

        "Entered By" := USERID;
        "Creation Date" := WORKDATE;
        AssignLotSerialRelationship();
    end;

    trigger OnModify();
    begin
        "Last Date Modified" := WORKDATE;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        QCSetup: Record QCSetup_PQ;
        TestT: Record QualityTestHeaderArch_PQ;
        TestLinesT: Record QualityTestLines_PQ;
        TestHeaderComments: Record QCTestHeaderComment_PQ;
        ItemT: Record Item;
        QualitySpecsCopy: Codeunit QCFunctionLibrary_PQ;
        LotNumInfo: Record "Lot No. Information";
        StatusQuestion: Boolean;
        Text001: Label 'Some test lines do not have Actual Measurments. \\';
        Text002: Label 'Do you wish to continue?';
        Text003: Label 'Change of status has been aborted.';
        Text004: Label 'Serial No. Items can only be a quantity of one.';
        Text005: Label 'You must be a Quality Manager to Change to the %1 Status.\\';
        Text006: Label 'There are Mandatory Tests that do not have Actual Measurements.\';
        Text010: Label 'Status must be Closed to Delete';
        "-QC71.1---": Integer;
        QualityFunctions: Codeunit QCFunctionLibrary_PQ;
        Text011: Label 'You must be a Quality Manager to Delete. Aborted!';
        Text012: Label '%1 is already in the Certified Final Status.\\';
        Text013: Label 'There can only be ONE Certified Final Test per Item/Customer/Lot.\\';
        Text014: Label 'If you contnue, the current Test will Replace %1 as Certified Final.\\';
        [InDataSet]
        CoAAvailable: Boolean;
        QCStatusRules: Record QCStatusRules_PQ;
        QCStatusRuleResult: Text;
        Text015: Label 'Some mandatory test lines have not been completed.';
        TempTrackingSpec: Record "Tracking Specification" temporary;

        Text016: Label 'The %1 field cannot be modify if %2 have already been created.', Comment = '%1: Field Caption; %2: Table Caption';

    procedure AssistEdit(OldTest: Record QualityTestHeaderArch_PQ): Boolean;
    begin
        with TestT do begin
            TestT := Rec;
            QCSetup.GET;
            QCSetup.TESTFIELD("QC Test No. Series");
            // if NoSeriesMgt.SelectSeries(QCSetup."QC Test No. Series", OldTest."No. Series", "No. Series") then begin
            //     QCSetup.GET;
            //     QCSetup.TESTFIELD("QC Test No. Series");
            //     NoSeriesMgt.SetSeries("Test No.");
            //     Rec := TestT;
            //     exit(true);
            // end;
            QCSetup.GET;
            QCSetup.TESTFIELD("QC Test No. Series");
            Rec := TestT;
            exit(true);
        end;

    end;

    procedure TestStatus();
    begin
        if "Test Status" > "Test Status"::"In-Process" then
            FIELDERROR("Test Status");
    end;

    procedure CheckLineStatuses(ExcludeOutsideTests: Boolean; OnlyMandatoryTests: Boolean) StatusQuestion: Boolean;
    begin
        //QC71.1 Function Added

        StatusQuestion := false;
        TestLinesT.SETRANGE("Test No.", "Test No.");

        if ExcludeOutsideTests then begin
            TestLinesT.SETRANGE("Outside Testing", false); //Exclude lines marked "Outside Testing"
        end;

        if OnlyMandatoryTests then begin
            TestLinesT.SETRANGE(Mandatory, true); //Only Include MANDATORY Tests
        end;

        if TestLinesT.FINDSET then
            repeat
                //JM5.01 begin
                if TestLinesT."Result Type" = TestLinesT."Result Type"::Numeric then begin
                    if ((TestLinesT."Actual Measure" = 0) and (TestLinesT."Test Line Complete" = false)) and //QC80.1 - Added "Test Line Complete" Term
                       ("Test Status" > "Test Status"::"In-Process") then
                        StatusQuestion := true;
                end else
                    if TestLinesT."Result Type" = TestLinesT."Result Type"::List then begin
                        if (TestLinesT.Result = '') and
                           ("Test Status" > "Test Status"::"In-Process") then
                            StatusQuestion := true;
                    end;

                if TestLinesT."Result Type" = TestLinesT."Result Type"::Numeric then begin
                    if (TestLinesT."Actual Measure" <> 0) and
                       ("Test Status" > "Test Status"::"In-Process") then
                        TestLinesT."Test Line Complete" := true;
                    //      TestLinesT."Test Status" := "Test Status";
                    TestLinesT.MODIFY;
                end else
                    if TestLinesT."Result Type" = TestLinesT."Result Type"::List then begin
                        if (TestLinesT.Result <> '') and
                           ("Test Status" > "Test Status"::"In-Process") then
                            TestLinesT."Test Line Complete" := true;
                        //        TestLinesT."Test Status" := "Test Status";
                        TestLinesT.MODIFY;
                    end;
            //JM5.01 end
            until TestLinesT.NEXT = 0;

        TestLinesT.SETRANGE("Outside Testing"); //Make sure these Filters are not carried into other functions
    end;

    procedure ChangeTestStatus(NewStatus: Integer);
    var
        UserSetup: Record "User Setup";
        OkToChange: Boolean;
    begin
        //QC71.1 Function Added

        if "Test Status" <> xRec."Test Status" then begin //Keep Function from double-firing upon "Status Rollback"...
            OkToChange := CheckStatusRules(Rec, NewStatus); //Passed all the Requirements, CHANGE the Status!
            if OkToChange then begin
                // if NewStatus = "Test Status"::"Certified Final" then
                //     OkToChange := HandleCertifiedFinal; //Handle "Certified Final" Status Change Extra-Special
                if OkToChange then begin
                    "Test Status" := NewStatus;
                    MODIFY(false); //First, modify the Header...
                    CreateStatusComment(Rec, NewStatus); //Create Header Comment for Status Change
                    TestLinesT.SETRANGE("Test No.", "Test No.");
                    if TestLinesT.FINDSET then
                        repeat
                            TestLinesT."Test Status" := NewStatus; //Now the Lines...
                            TestLinesT.MODIFY(false);
                        until TestLinesT.NEXT = 0;
                    if (NewStatus = "Test Status"::Certified) then
                        ;//QualityFunctions.UpdateSpecNextTestDates(Rec); //(Possibly) Update the Last Test Date/Next Test Date on the Specification Lines
                end;
            end;
            if not OkToChange then begin  //Else, Revert Header to Previous (non-changed) Status (Lines weren't changed to New Status yet)
                "Test Status" := xRec."Test Status";
                MODIFY(false);
            end;
        end;
    end;

    procedure CheckStatusRules(TestHeader: Record QualityTestHeaderArch_PQ; NewStatus: Integer) OkToChange: Boolean;
    var
        TempTestLines: Record QualityTestLines_PQ;
        UserIsQCMgr: Boolean;
        BlankLinesExist: Boolean;
        FoundLines: Boolean;
        MsgText: Text;
    begin
        //QC71.1 - Function Added to implement "Status" Change Rules
        // Returns TRUE if Status Change IS Allowed, FALSE if NOT
        // This is the big CASE Statement you've been looking for!
        // Actual Status Change is Done in "ChangeTestStatus()"
        // Calls QualityFunctions.TestQCMgr to test for "Quality Manager"-ness of Current User

        UserIsQCMgr := QualityFunctions.TestQCMgr; //Get this over with to save time in each CASE
        BlankLinesExist := CheckLineStatuses(false, true); //Are there ANY "Incomplete" Lines?
        OkToChange := false; //Start out Assuming Test Status Change NOT Allowed

        case NewStatus of

            TestHeader."Test Status"::New:
                begin
                    if not UserIsQCMgr then begin //Quality Managers can Always do this
                        TempTestLines.SETRANGE("Test No.", TestHeader."Test No.");
                        OkToChange := not TempTestLines.FINDSET; //Not Allowed if there are Test Lines (this basically allows the Create New Test action to work ok)
                        if not OkToChange then
                            MESSAGE(Text005 + Text003); //Tell User that Change has been Aborted
                    end else begin
                        OkToChange := true; //QC Managers can Always Change to this Status
                    end;
                end; //End "New" Case

            TestHeader."Test Status"::"Ready for Testing":
                begin
                    //IF UserIsQCMgr THEN BEGIN //Start out with this test
                    OkToChange := true; //Always Allowed (UN-REM the Lines around this to Require QC Mgr. to change to this)
                                        //END ELSE BEGIN
                                        //  MESSAGE(Text005 + Text003,"Test Status"); //Tell User that they must be Quality Mgr for this Change
                                        //END;
                end; //End "Ready For Testing" Case

            TestHeader."Test Status"::"Ready for Review":
                begin
                    if xRec."Test Status" < NewStatus then begin //Don't bother User if coming from a "Higher" Status
                        if BlankLinesExist then begin //If ANY "Incomplete" Lines...
                            //OkToChange := CONFIRM(Text001 + Text002, false); //Warn, but allow...
                            //if not OkToChange then
                            //    MESSAGE(Text003); //Tell User that Change has been Aborted
                            Error(Text015);
                        end else
                            OkToChange := true; //IF No Blank Lines, it is ok
                    end else
                        OkToChange := true; //If coming from "Higher" Status, then ALWAYS ok to Change to this Status
                end; //End "Ready for Review" Case

            TestHeader."Test Status"::Certified:
                begin
                    if UserIsQCMgr then begin //Start out with this test
                        if BlankLinesExist then begin //If ANY "Incomplete" Lines...
                                                      /*
                                                          if CONFIRM(Text001 + Text002, false) then begin // Warn...
                                                              if not CheckLineStatuses(true, true) then //Allow Change ONLY if no MANDATORY, NON-Outside Test" Lines are incomplete
                                                                  OkToChange := true; //Change is Ok
                                                              if not OkToChange then
                                                                  MsgText := Text006; //Tell User there are "Incomplete" MANDATORY Tests
                                                          end else
                                                              OkToChange := false; //Make Sure No Change Allowed!
                                                          if not OkToChange then begin
                                                              MsgText := MsgText + Text003; //Tell User that Change has been Aborted
                                                              MESSAGE(MsgText);
                                                          end;
                                                      */
                            Error(Text015);
                        end else
                            OkToChange := true; //Ok if NO "Incomplete" Lines
                    end else begin
                        MESSAGE(Text005 + Text003, "Test Status"); //Tell User that they must be Quality Mgr for this Change
                    end;
                end; //End "Certified" Case

            /*TestHeader."Test Status"::"Certified with Waiver":
                begin
                    if UserIsQCMgr then begin //Start out with this test
                        if BlankLinesExist then begin //If ANY "Incomplete" Lines...
                            //OkToChange := CONFIRM(Text001 + Text002, false); //Warn, but allow...
                            Error(Text015);
                        end else
                            OkToChange := true; //If NO "Incomplete LInes", then OK
                        if not OkToChange then
                            MESSAGE(Text003); //Tell User that Change has been Aborted
                    end else begin
                        MESSAGE(Text005 + Text003, "Test Status"); //Tell User that they must be Quality Mgr for this Change
                    end;
                end; //End "Certified with Waiver" Case
            */
            /*TestHeader."Test Status"::"Certified Final":
                begin
                    if UserIsQCMgr then begin //Start out with this test
                        if BlankLinesExist then begin //If ANY "Incomplete" Lines...
                            //OkToChange := false; //No way, no how!
                            //MESSAGE(Text001 + Text003); //Inform User that Change is ABORTED
                            Error(Text015);
                        end else begin //No "Incomplete" Lines...
                            OkToChange := true; //Allow Change of Status
                        end;
                    end else begin
                        MESSAGE(Text005 + Text003, "Test Status"); //Tell User that they must be Quality Mgr for this Change
                    end;
                end; //End "Certified Final" Case (but there will be (much) more Logic to handle this Case "Special")
            */
            TestHeader."Test Status"::Rejected:
                begin
                    if UserIsQCMgr then begin //Start out with this test
                        OkToChange := true; //Always Allowed if QC Manager
                    end else begin
                        MESSAGE(Text005 + Text003, "Test Status"); //Tell User that they must be Quality Mgr for this Change
                    end;
                end; //End "Rejected" Case

            TestHeader."Test Status"::Closed:
                begin
                    if UserIsQCMgr then begin //Start out with this test
                        OkToChange := true; //Always Allowed if QC Manager
                    end else begin
                        MESSAGE(Text005 + Text003, "Test Status"); //Tell User that they must be Quality Mgr for this Change
                    end;
                end; //End "Rejected" Case

            //Default
            else begin //Default Case
                OkToChange := true; //No Restrictions on other Status Changes
            end; //End Default Case
        end; //END of CASE NewStatus OF...
    end;

    /*procedure HandleCertifiedFinal() Changed: Boolean;
    var
        TempHeader: Record QualityTestHeaderArch_PQ;
        TempLines: Record QualityTestLines_PQ;
    begin
        //QC71.1 Function Added
        //Makes sure there is only ONE "Certified Final" Test for this Item No/Customer No./Lot No. combination

        Changed := false;

        TempHeader.SETRANGE("Test Status", "Test Status"::"Certified Final");
        TempHeader.SETRANGE("Item No.", "Item No.");
        TempHeader.SETRANGE("Customer No.", "Customer No.");
        TempHeader.SETRANGE("Lot No./Serial No.", "Lot No./Serial No.");

        if TempHeader.FINDFIRST then begin
            if CONFIRM(Text012 + Text013 + Text014 + Text002, false, TempHeader."Test No.") then begin
                Changed := true;
                TempHeader."Test Status" := TempHeader."Test Status"::Certified;
                TempHeader.MODIFY(false);
                CreateStatusComment(TempHeader, TempHeader."Test Status"); //Record Status Change in Comments
                TempLines.SETRANGE("Test No.", TempHeader."Test No.");
                if TempLines.FINDSET then
                    repeat
                        TempLines."Test Status" := TempLines."Test Status"::Certified;
                        TempLines.MODIFY(false);
                    until TempLines.NEXT = 0;
            end else begin
                Changed := false;
                MESSAGE(Text003); //Change Aborted!
            end;
        end else
            Changed := true; //No other Certifed Finals found, so OK to Change

    end;
    */

    procedure CreateStatusComment(TempTestHeader: Record QualityTestHeaderArch_PQ; ChangedStatus: Integer);
    var
        UserT: Record User;
        HeaderCommentT: Record QCTestHeaderComment_PQ;
        CommentText: Text;
        StatusText: Text;
        LineNo: Integer;
        CmtText001: Label 'User %1 Changed the Test Status to %2';
        DummyTestHeader: Record QualityTestHeaderArch_PQ temporary;
    begin
        //QC7.4 Function Added - Create Test Header Comment when "Test Status" is Changed

        LineNo := 10000;
        DummyTestHeader."Test Status" := ChangedStatus; //Only here so we can get the "Caption" of the Status...
        StatusText := FORMAT(DummyTestHeader."Test Status"); //...into this variable

        HeaderCommentT.SETRANGE(HeaderCommentT."Test No.", TempTestHeader."Test No.");
        if HeaderCommentT.FINDLAST then
            LineNo := HeaderCommentT."Line No." + 10000;
        UserT.SETRANGE(UserT."User Name", USERID);
        if UserT.FINDFIRST then begin
            CommentText := STRSUBSTNO(CmtText001, UserT."Full Name", StatusText);

            if STRLEN(CommentText) > 80 then begin
                CommentBreak(CommentText, TempTestHeader."Test No.");
            end else begin
                HeaderCommentT."Test No." := TempTestHeader."Test No.";
                HeaderCommentT."Line No." := LineNo;
                HeaderCommentT.Date := WORKDATE;
                HeaderCommentT."Entered By" := USERID;
                HeaderCommentT.Comment := CommentText;
                HeaderCommentT.INSERT;
            end;
        end;
    end;

    local procedure CommentBreak(CommentText: Text; TestNo: Code[20])
    var
        CommentText80: Text[80];
        CommentSplit: List of [Text];
        Position: Integer;
        IsFirstLine: Boolean;
        TestHdrCmt: Record QCTestHeaderComment_PQ;
        NewLineNo: Integer;
    begin
        CommentSplit := CommentText.Split(' ');
        IsFirstLine := true;
        Position := 0;

        TestHdrCmt.SETRANGE(TestHdrCmt."Test No.", TestNo);
        if TestHdrCmt.FindLast() then
            NewLineNo += TestHdrCmt."Line No.";

        TestHdrCmt."Test No." := TestNo;
        TestHdrCmt.Date := WORKDATE;
        TestHdrCmt."Entered By" := USERID;
        repeat begin
            NewLineNo += 10000;
            CommentText80 := '';

            repeat begin
                Position += 1;
                CommentText80 := CommentText80 + CommentSplit.Get(Position) + ' ';
            end until CheckIfNextWordNotAvailable(CommentText80, CommentSplit, Position);

            if not IsFirstLine then
                TestHdrCmt.Date := 0D;
            IsFirstLine := false;

            TestHdrCmt."Line No." := NewLineNo;
            TestHdrCmt.Comment := CommentText80;
            TestHdrCmt.INSERT;
        end until Position = CommentSplit.Count;
    end;

    local procedure AssignLotSerialRelationship()
    var
        LotNoInformation: Record "Lot No. Information";
        SerialNoInformation: Record "Serial No. Information";
    begin
        if "Tracking Type" = "Tracking Type"::"Serial No." then begin
            if "Serial No." = '' then
                if SerialNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No./Serial No.") then begin
                    Rec."Serial No." := SerialNoInformation."Serial No.";
                    SerialNoInformation."CCS Test No." := Rec."Test No.";
                    SerialNoInformation."CCS Status" := SerialNoInformation."CCS Status"::"In Quality Inspection";
                    SerialNoInformation.Blocked := true;
                    SerialNoInformation.Modify();
                end;
        end else begin
            if "Lot No." = '' then
                if LotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No./Serial No.") then begin
                    Rec."Lot No." := LotNoInformation."Lot No.";
                    LotNoInformation."CCS Test No." := Rec."Test No.";
                    LotNoInformation."CCS Status" := LotNoInformation."CCS Status"::"In Quality Inspection";
                    LotNoInformation.Blocked := true;
                    LotNoInformation.Modify();
                end;
        end;
    end;

    local procedure CheckIfNextWordNotAvailable(Cmt80: Text; CmtSplit: List of [Text]; Position: Integer): Boolean
    begin
        if Position >= CmtSplit.Count then
            exit(true);
        if StrLen(Cmt80 + CmtSplit.Get(Position + 1) + ' ') > 80 then
            exit(true);
        exit(false);
    end;

    procedure CheckCoAAvailable(): Boolean;
    begin
        //Check to see if CoA should be Allowed

        CoAAvailable := false;
        //QCStatusRuleResult := QCStatusRules.CheckCoAAvail(Rec); //This is the actual Option Text Returned
        CoAAvailable := ((QCStatusRuleResult = 'Yes') or (QCStatusRuleResult = 'Confirm')); //This will enable the Action button
        exit(CoAAvailable);
    end;

    //QC200.1
    procedure UpdateLotOrSerialInformation(Blocked: Boolean);
    var
        LotOrSerialNo: array[2] of code[20];
        SerialInformation: record "Serial No. Information";
        TotalCodes: Integer;
        nX: Integer;
    begin
        //Unblock the related serial or lot information card, if needed.
        if "Lot No./Serial No." = '' then
            exit;

        GetLotAndSerialCodes(LotOrSerialNo, TotalCodes);

        For nX := 1 TO TotalCodes do begin
            UpdateBlockLotInfo("Item No.", '', LotOrSerialNo[nX], Blocked);
            UpdateBlockSerialInfo("Item No.", '', LotOrSerialNo[nX], Blocked);
        end;
    end;

    procedure UpdateLotOrSerialInformation2(Blocked: Boolean; IsCertified: Boolean);
    var
        LotOrSerialNo: array[2] of code[20];
        SerialInformation: record "Serial No. Information";
        TotalCodes: Integer;
        nX: Integer;
        PurchLine: Record "Purchase Line";
        ProdOrderLine: Record "Prod. Order Line";
    begin

        if ("Multiple Tracking") and ("Source Type" = "Source Type"::"Purchase Order") then begin
            PurchLine.Reset();
            PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
            PurchLine.SetRange("Document No.", "Source No.");
            PurchLine.SetRange("Line No.", "Source Line No.");
            if PurchLine.FindFirst() then begin
                GetTempTrackingSpecPurchOrder(PurchLine);
                if TempTrackingSpec.FindSet() then
                    repeat
                        UpdateBlockLotInfo2("Item No.", '', TempTrackingSpec."Lot No.", Blocked, IsCertified);
                        UpdateBlockSerialInfo2("Item No.", '', TempTrackingSpec."Serial No.", Blocked, IsCertified);
                    until TempTrackingSpec.Next() = 0;
            end;
            exit;
        end;

        if ("Multiple Tracking") and ("Source Type" = "Source Type"::"Output Journal") then begin
            ProdOrderLine.Reset();
            ProdOrderLine.SetRange(Status, ProdOrderLine.Status::Released);
            ProdOrderLine.SetRange("Prod. Order No.", "Source No.");
            if ProdOrderLine.FindFirst() then begin
                GetTempTrackingSpecProdOrder(ProdOrderLine);
                if TempTrackingSpec.FindSet() then
                    repeat
                        UpdateBlockLotInfo2("Item No.", '', TempTrackingSpec."Lot No.", Blocked, IsCertified);
                        UpdateBlockSerialInfo2("Item No.", '', TempTrackingSpec."Serial No.", Blocked, IsCertified);
                    until TempTrackingSpec.Next() = 0;
            end;
            exit;
        end;

        //Unblock the related serial or lot information card, if needed.
        if "Lot No." = '' then
            exit;

        GetLotAndSerialCodes(LotOrSerialNo, TotalCodes);

        For nX := 1 TO TotalCodes do begin
            UpdateBlockLotInfo2("Item No.", '', LotOrSerialNo[nX], Blocked, IsCertified);
            UpdateBlockSerialInfo2("Item No.", '', LotOrSerialNo[nX], Blocked, IsCertified);
        end;
    end;

    //QC200.1
    procedure GetLotAndSerialCodes(var LotOrSerialNo: array[2] of Code[50]; var TotalCodes: Integer);
    var
    begin
        TotalCodes := 1;
        if StrPos("Lot No.", ',') <> 0 then begin
            LotOrSerialNo[1] := SelectStr(1, "Lot No.");
            LotOrSerialNo[2] := SelectStr(2, "Lot No.");
            TotalCodes := 2;
        end else
            LotOrSerialNo[1] := "Lot No.";
    end;
    //QC200.1
    procedure UpdateBlockLotInfo(ItemNo: Code[20]; VariantCode: Code[20]; LotNo: Code[50]; Blocked: Boolean);
    var
        LotNoInfo: record "Lot No. Information";
    begin
        if LotNoInfo.Get(ItemNo, VariantCode, LotNo) then begin
            LotNoInfo.Blocked := Blocked;
            LotNoInfo.Modify(true);
        end;
    end;

    local procedure checkNonConformance(itestNo: Code[20])
    var
        qualitytestLine: Record QualityTestLines_PQ;
    begin
        Clear(qualitytestLine);
        qualitytestLine.Reset();
        qualitytestLine.SetRange("Test No.", itestNo);
        qualitytestLine.SetRange("Non-Conformance", true);
        if qualitytestLine.Find('-') then
            Error('Can`t change status to Certified cause Non-Conformance exists in QT Line');
    end;

    procedure UpdateBlockLotInfo2(ItemNo: Code[20]; VariantCode: Code[20]; LotNo: Code[50]; Blocked: Boolean; IsCertified: Boolean);
    var
        LotNoInfo: record "Lot No. Information";
    begin
        if LotNoInfo.Get(ItemNo, VariantCode, LotNo) then begin
            LotNoInfo.Blocked := Blocked;
            if Blocked then begin
                if Rec."Test Status" <> Rec."Test Status"::Hold then
                    LotNoInfo."CCS Status" := LotNoInfo."CCS Status"::Restricted
                else
                    LotNoInfo."CCS Status" := LotNoInfo."CCS Status"::Hold
            end
            else begin
                LotNoInfo."CCS Status" := LotNoInfo."CCS Status"::Unrestricted;
                if Rec."Test Status" = Rec."Test Status"::New then begin
                    LotNoInfo."CCS Status" := LotNoInfo."CCS Status"::Restricted;
                    LotNoInfo.Blocked := Blocked;
                end;
            end;

            if IsCertified then
                LotNoInfo."CCS Date Certified" := WORKDATE;

            LotNoInfo.Modify(true);
        end;
    end;

    //QC200.1
    procedure UpdateBlockSerialInfo(ItemNo: Code[20]; VariantCode: Code[20]; SerialNo: Code[50]; Blocked: Boolean);
    var
        SerialNoInfo: record "Serial No. Information";
    begin
        if SerialNoInfo.Get(ItemNo, VariantCode, SerialNo) then begin
            SerialNoInfo.Blocked := Blocked;
            SerialNoInfo.Modify(true);
        end;
    end;

    procedure UpdateBlockSerialInfo2(ItemNo: Code[20]; VariantCode: Code[20]; SerialNo: Code[50]; Blocked: Boolean; IsCertified: Boolean);
    var
        SerialNoInfo: record "Serial No. Information";
    begin
        if SerialNoInfo.Get(ItemNo, VariantCode, SerialNo) then begin
            SerialNoInfo.Blocked := Blocked;
            if Blocked then
                SerialNoInfo."CCS Status" := SerialNoInfo."CCS Status"::Hold
            else
                SerialNoInfo."CCS Status" := SerialNoInfo."CCS Status"::Unrestricted;

            if IsCertified then
                SerialNoInfo."CCS Date Certified" := WORKDATE;

            SerialNoInfo.Modify(true);
        end;
    end;

    procedure UpdateProdRoutingLineStatus(RoutingStatus: Integer);
    var
        ProdRoutingLine: Record "Prod. Order Routing Line";
        QCSetup: Record QCSetup_PQ;
    begin
        QCSetup.Get();
        if QCSetup."Dont update Routing Status" then
            exit;

        if "Specification Type" = '' then
            exit;

        ProdRoutingLine.SetRange(Status, ProdRoutingLine.Status::Released);
        ProdRoutingLine.SetRange("CCS Quality Test No.", "Test No.");
        if ProdRoutingLine.FindSet() then
            repeat
                ProdRoutingLine."CCS QC Updated" := true;
                ProdRoutingLine.Validate("Routing Status", RoutingStatus);
                ProdRoutingLine."CCS QC Updated" := false;
                ProdRoutingLine.Modify(true);
            until ProdRoutingLine.Next() = 0
    end;

    procedure setTrackingType(NewTrackingType: Option)
    begin
        "Tracking Type" := NewTrackingType;
    end;

    procedure GetTempTrackingSpecPurchOrder(PurchLine: Record "Purchase Line")
    var
        TrackingSpecification: Record "Tracking Specification";
        ItemTrackingLines: Page "Item Tracking Lines";
    begin
        TempTrackingSpec.RESET;
        TempTrackingSpec.DELETEALL;

        CLEAR(ItemTrackingLines);

        TrackingSpecification.InitFromPurchLine(PurchLine);
        ItemTrackingLines.SETRECORD(TrackingSpecification);
        ItemTrackingLines.SetSourceSpec(TrackingSpecification, PurchLine."Expected Receipt Date");
        ItemTrackingLines.GetTempTrackingSpec(TempTrackingSpec);
    end;

    procedure GetTempTrackingSpecProdOrder(ProdOrderLine: Record "Prod. Order Line")
    var
        TrackingSpecification: Record "Tracking Specification";
        ItemTrackingLines: Page "Item Tracking Lines";
    begin
        TempTrackingSpec.RESET;
        TempTrackingSpec.DELETEALL;

        CLEAR(ItemTrackingLines);

        TrackingSpecification.InitFromProdOrderLine(ProdOrderLine);
        ItemTrackingLines.SETRECORD(TrackingSpecification);
        ItemTrackingLines.SetSourceSpec(TrackingSpecification, ProdOrderLine."Due Date");
        ItemTrackingLines.GetTempTrackingSpec(TempTrackingSpec);
    end;

    local procedure CheckQuantityExceeded()
    var
        ExceededQuantityErr: Label 'The %1, %2, and %3 fields have exceeded the quantity on the %4 field. Currently the total is %5', Comment = '%1, %2, %3, %4: fields caption; %5: total quantity';
        TotalQuantityToCreate: Decimal;
    begin
        TotalQuantityToCreate := "Qty. to Transfer" + "Qty. to Return" + "Qty. to Scrap";
        if "Test Qty" - TotalQuantityToCreate < 0 then
            Error(ExceededQuantityErr, Rec.FieldCaption("Qty. to Return"), Rec.FieldCaption("Qty. to Scrap"), Rec.FieldCaption("Qty. to Transfer"), Rec.FieldCaption("Test Qty"), TotalQuantityToCreate);
    end;

    procedure QuantityToCertify(): Decimal
    begin
        exit(Rec."Test Qty" - (Rec."Qty. to Return" + Rec."Qty. to Transfer" + Rec."Qty. to Scrap"))
    end;
}
