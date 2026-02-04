table 50701 QCSpecificationHeader_PQ
{
    // version QC11.01

    // //QC4.01  Removed code on Rename and added an Error to not allow rename.
    // //QC4.02  Added code to auto flag Auto-enter SN Master if specs are entered
    //             on Item that has Serial No. Series.
    //
    // //QC7.2
    //   - Changed Length ot Description Field from 30 to 50 to comport with Item Table
    //   - Changed so the Delete can happen in all Statuses
    //
    // //QC7.3
    //   - Change Name of "Description" and "Description 2" Fields to "Test Description" and "Test Description 2" to minimize confusion
    //
    // QC71.1
    //   - Added "Tests on File" FlowField from Specification Header
    //   - Added "Test Type" Field (may obsolete this field) (also added to Test Header Table)
    //   - Added "Last Used Date" FlowField from Test Header Creation Date
    //
    // QC80.4
    //   - Added FlowField "QC Required"
    //
    // QC11.01
    //   - Added FlowField 61, "Active Tests", to Count Tests in < "Ready For Review" Status
    //   - In OnRename Trigger, Added Test for Status to ALLOW Renaming unless in "Certified" Status

    Caption = 'Quality Specification Header';
    DataCaptionFields = "Item No.", "Customer No.", Type;
    DrillDownPageID = QCSpecificationList_PQ;
    LookupPageID = "QCSpecificationList_PQ";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            TableRelation = Item."No." WHERE("Item Tracking Code" = FILTER(<> ''));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("Item No." <> xRec."Item No.") and (xRec."Item No." <> '') then begin
                    QCLine.SETRANGE("Item No.", xRec."Item No.");
                    QCLine.SETRANGE("Customer No.", "Customer No.");
                    QCLine.SETRANGE(Type, Type);
                    QCLine.SETRANGE("Version Code", '');   //Ver is blank
                    if QCLine.FIND('-') then
                        ERROR(Text007, FIELDNAME("Item No."));
                end;

                if "Item No." <> '' then
                    if ItemT.GET("Item No.") then begin
                        VALIDATE("Test Description", ItemT.Description);
                        "Search Name" := ItemT.Description;
                        if ItemT."Has Quality Specifications" = false then begin
                            //QC4.02
                            if ItemT."Serial Nos." <> '' then
                                ItemT."CCS Auto Enter Ser No. Master" := true;
                            //end qc4.02
                            ItemT.MODIFY;
                        end;
                    end;
            end;
        }
        field(3; "Customer No."; Code[20])
        {
            TableRelation = Customer;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                Cust: Record Customer;
            begin
                if ("Customer No." <> xRec."Customer No.") and (xRec."Customer No." <> '') then begin
                    QCLine.SETRANGE("Item No.", "Item No.");
                    QCLine.SETRANGE("Customer No.", xRec."Customer No.");
                    QCLine.SETRANGE(Type, Type);
                    QCLine.SETRANGE("Version Code", '');   //Ver is blank
                    if QCLine.FIND('-') then
                        ERROR(Text007, FIELDNAME("Customer No."));
                end;
            end;
        }
        field(4; "Type"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';

            trigger OnValidate();
            var
                QCLine2: Record QCSpecificationLine_PQ;
            begin
                if "Type" <> xRec."Type" then begin
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                end;

                if (Type <> xRec.Type) then begin
                    QCLine.SETRANGE("Item No.", "Item No.");
                    QCLine.SETRANGE("Customer No.", "Customer No.");
                    QCLine.SETRANGE(Type, xRec.Type);
                    QCLine.SETRANGE("Version Code", '');   //Ver is blank
                    if QCLine.FIND('-') then
                        repeat
                            QCLine2 := QCLine;
                            QCLine2.Rename(QCLine2."Item No.", QCLine2."Customer No.", Rec.Type, QCLine2."Version Code", QCLine2."Line No.");
                        until QCLine.Next() = 0;
                end;


            end;
        }
        field(6; "Item Description"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Description = 'Lookup flow field';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Customer Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Description = 'Lookup flow field';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Test Description"; Text[100])
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "Search Name" := "Test Description";
            end;
        }
        field(11; "Test Description 2"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Search Name"; Code[100])
        {
            Caption = 'Search Name';
            DataClassification = CustomerContent;
        }
        field(21; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Status = Status::Certified then
                    FIELDERROR(Status);
            end;
        }
        field(25; "Comment"; Boolean)
        {
            CalcFormula = Exist(QCHeaderCommentLine_PQ WHERE("Table Name" = CONST("QC Header"),
                                                                    "Item No." = FIELD("Item No."),
                                                                    "Customer No." = FIELD("Customer No."),
                                                                    Type = FIELD(Type),
                                                                    "Version Code" = CONST('')));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(43; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(45; "Status"; Option)
        {
            Caption = 'Status';
            OptionCaption = 'New,Certified,Under Development,Closed';
            OptionMembers = New,Certified,"Under Development",Closed;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                PlanningAssignment: Record "Planning Assignment";
                ProdBOMCheck: Codeunit "Production BOM-Check";
                QCSpecLine: Record QCSpecificationLine_PQ;
            begin
                if (xRec.Status = Status::Closed) and (Status <> xRec.Status) then
                    error(Text005);

                if (Status <> xRec.Status) and (Status = Status::Closed) then begin
                    if CONFIRM(
                         Text001, false)
                    then begin
                        QCVersion.SETRANGE("Item No.", "Item No.");
                        QCVersion.SETRANGE("Customer No.", "Customer No.");
                        QCVersion.SETRANGE(Type, Type);
                        if QCVersion.FIND('-') then
                            repeat
                                QCVersion.Status := QCVersion.Status::Closed;
                                QCVersion.MODIFY;

                            until QCVersion.NEXT = 0;

                    end else
                        ERROR(Text006);
                end;

                if (Status <> xRec.Status) and (Status = Status::Certified) then begin
                    QCSpecLine.Reset();
                    QCSpecLine.SetRange("Item No.", "Item No.");
                    QCSpecLine.SetRange("Customer No.", "Customer No.");
                    QCSpecLine.SetRange(Type, Type);
                    QCSpecLine.SetRange("Version Code", '');
                    if not QCSpecLine.FindFirst() then
                        Error(Text012);
                end;

                //if (Status <> xRec.Status) and (Status = Status::Certified) then
                //    TestUniqueSpecification("Category Code");

                MODIFY(true);
                COMMIT;
            end;
        }
        field(50; "Version Nos."; Code[10])
        {
            Caption = 'Version Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(51; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(52; "Blocked"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(53; "Versions Exist"; Boolean)
        {
            CalcFormula = Exist(QCSpecificationVersions_PQ WHERE("Item No." = FIELD("Item No."),
                                                                        "Customer No." = FIELD("Customer No."),
                                                                        Type = FIELD(Type)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "Test Type"; Option)
        {
            Description = 'QC71.1';
            OptionMembers = "Lot/SN",,,,,"In-Line";
            DataClassification = CustomerContent;
        }
        field(55; "Tests on File"; Integer)
        {
            CalcFormula = Count(QualityTestHeader_PQ WHERE("Item No." = FIELD("Item No."),
                                                                 "Customer No." = FIELD("Customer No."),
                                                                 "Category Code" = field("Category Code")));
            Description = 'QC71.1';
            FieldClass = FlowField;
        }
        field(56; "Last Used"; Date)
        {
            CalcFormula = Max(QualityTestHeader_PQ."Creation Date");
            Description = 'QC71.1';
            FieldClass = FlowField;
        }
        field(60; "QC Required"; Boolean)
        {
            Caption = 'Quality Test Mandatory';
            Description = 'QC80.4';
            DataClassification = CustomerContent;
        }
        field(61; "Active Tests"; Integer)
        {
            CalcFormula = Count(QualityTestHeader_PQ WHERE("Item No." = FIELD("Item No."),
                                                                 "Customer No." = FIELD("Customer No."),
                                                                 "Category Code" = field("Category Code"),
                                                                 "Test Status" = FILTER(< "Ready for Review")));
            Description = 'QC11.01';
            FieldClass = FlowField;
        }
        field(62; "Category Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Category Code';
            TableRelation = SpecificationCategory_PQ;

            trigger OnValidate()
            begin
                TestField("Output Specification", false);
            end;
        }
        field(63; "Output Specification"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Output Specification';
        }
        field(100; "Purchase Lines"; Integer)
        {
            CalcFormula = count("Purchase Line" WHERE(Type = CONST(Item),
                                                    "No." = FIELD("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Sales Lines"; Integer)
        {
            CalcFormula = count("Sales Line" WHERE(Type = CONST(Item),
                                                    "No." = FIELD("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "Active Quality Tests"; Integer)
        {
            CalcFormula = Count(QualityTestHeader_PQ WHERE("Item No." = FIELD("Item No."),
                                                                 "Customer No." = FIELD("Customer No."),
                                                                 "Specification Type" = field(Type),
                                                                 "Test Status" = FILTER("Ready for Testing" | "In-Process" | "Ready for Review")));
            Description = 'QC11.01';
            FieldClass = FlowField;
        }
        field(103; "Certified Quality Tests"; Integer)
        {
            CalcFormula = Count(QualityTestHeader_PQ WHERE("Item No." = FIELD("Item No."),
                                                                 "Customer No." = FIELD("Customer No."),
                                                                 "Specification Type" = field(Type),
                                                                 "Test Status" = FILTER(Certified)));
            Description = 'QC11.01';
            FieldClass = FlowField;
        }
        field(104; "Archived Quality Tests"; Integer)
        {
            CalcFormula = Count(QualityTestHeader_PQ WHERE("Item No." = FIELD("Item No."),
                                                                 "Customer No." = FIELD("Customer No."),
                                                                 "Specification Type" = field(Type),
                                                                 "Test Status" = FILTER(Rejected | Closed)));
            Description = 'QC11.01';
            FieldClass = FlowField;
        }
        field(105; "Operations"; Integer)
        {
            CalcFormula = Count("Prod. Order Routing Line" WHERE("CCS Spec. Type ID" = FIELD(Type)));
            Description = 'QC11.01';
            FieldClass = FlowField;
        }

        field(106; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;
        }
        field(121; "Check Sum. Value"; Decimal) { }
    }

    keys
    {
        key(Key1; "Item No.", "Customer No.", Type)
        {
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; "Customer No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Type, "Test Description", "Category Code", Status)
        {
        }
    }

    trigger OnDelete();
    var
        OkToDelete: Boolean;
    begin

        QCLine.SETRANGE("Item No.", "Item No.");
        QCLine.SETRANGE("Customer No.", "Customer No.");
        QCLine.SETRANGE(Type, Type);
        QCLine.SETRANGE("Version Code", '');
        QCLine.DELETEALL(true);

        QCComment.SETRANGE("Table Name", QCComment."Table Name"::"QC Header");
        QCComment.SETRANGE("Item No.", "Item No.");
        QCComment.SETRANGE("Customer No.", "Customer No.");
        QCComment.SETRANGE(Type, Type);
        QCComment.SETRANGE("Version Code", '');
        QCComment.DELETEALL;

        QCVersions.SETRANGE("Item No.", "Item No.");
        QCVersions.SETRANGE("Customer No.", "Customer No.");
        QCVersions.SETRANGE(Type, Type);
        QCVersions.DELETEALL(true);
    end;

    trigger OnInsert();
    var
        AMQCSetup: Record QCSetup_PQ;
        NoSeriesMgt: Codeunit "No. Series";
        NullValue: Code[10];
    begin
        "Creation Date" := TODAY;
        //TestField("Item No.");
        AMQCSetup.Get;
        AMQCSetup.TestField("Specification Type Nos.");

        if Type = '' then
            // NoSeriesMgt.InitSeries(AMQCSetup."Specification Type Nos.", NullValue, 0D, Type, NullValue);
          Type := NoSeriesMgt.GetNextNo(AMQCSetup."Specification Type Nos.", 0D, true);
    end;

    trigger OnModify();
    begin
        "Last Date Modified" := TODAY;
    end;

    var
        Item: Record Item;

        QCVersion: Record QCSpecificationVersions_PQ;
        QCLine: Record QCSpecificationLine_PQ;
        QCComment: Record QCHeaderCommentLine_PQ;
        QCVersions: Record QCSpecificationVersions_PQ;
        NoSeriesMgt: Codeunit "No. Series";
        CustT: Record Customer;
        ItemT: Record Item;
        QCSetup: Record QCSetup_PQ;
        Text001: Label 'All versions attached to this Specification will be closed. Close Specification?';
        Text005: Label 'You cannot reopen closed specifications.';
        Text006: Label 'Status change has be aborted.';
        Text007: Label 'You must delete the lines to rename the %1 field.';
        Text009: Label 'Renaming in the ''Certified'' Status is not allowed.  Change Status to ''Under Development''.';
        Text010: Label 'A transaction area of type Output must exist before creating an Output specification.';
        Text011: Label 'You cannot certify this Quality Specification because another Specification with the same Item and Category already exists.';
        Text012: Label 'You cannot certify a Specification without Lines.';

    procedure TestStatus();
    begin
        if (Status = Status::Certified) or
           (Status = Status::Closed) then
            FIELDERROR(Status);
    end;


    procedure GetSpecNoFromNonOutputSpecification(ItemNo: Code[20]; CustomerNo: Code[20]; CategoryCode: Code[20]): Code[20]
    var
        AMSpecHeader: Record QCSpecificationHeader_PQ;
    begin
        AMSpecHeader.SetRange("Item No.", ItemNo);
        AMSpecHeader.SetRange("Customer No.", CustomerNo);
        if CategoryCode <> '' then
            AMSpecHeader.SetRange("Category Code", CategoryCode);
        AMSpecHeader.SetRange("Output Specification", false);
        AMSpecHeader.SetRange(Status, AMSpecHeader.Status::Certified);
        if AMSpecHeader.FindFirst() then
            exit(AMSpecHeader.Type);

        exit('');
    end;

    procedure GetNoSeriesCode(): Code[20]
    var
        NoSeriesCode: Code[20];
        AMQCSetup: Record QCSetup_PQ;
    begin
        AMQCSetup.Get();

        NoSeriesCode := AMQCSetup."Specification Type Nos.";

        // exit(NoSeriesMgt.GetNoSeriesWithCheck(NoSeriesCode, true, "No. Series"));
        exit(NoSeriesCode);
    end;

    procedure AssistEdit(OldSpecification: Record QCSpecificationHeader_PQ): Boolean;
    begin
        QCSetup.GET;
        QCSetup.TESTFIELD("Specification Type Nos.");
        // if NoSeriesMgt.SelectSeries(QCSetup."Specification Type Nos.", OldSpecification."No. Series", "No. Series") then begin
        //     NoSeriesMgt.SetSeries(Type);
        // end;
    end;
}