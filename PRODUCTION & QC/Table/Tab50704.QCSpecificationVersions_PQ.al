table 50704 QCSpecificationVersions_PQ
{
    // version QC7

    // //QC4.01  Added Error to not allow Rename
    // //QC5.01  Added code to Status Onlookup trigger
    //             Corrected the situation where you could not delete just after setting the
    //             status to Close.
    //           Added Code to OnInsert to correct the situation that errored upon insert

    Caption = 'Quality Specification Header Versions';
    DataCaptionFields = "Item No.", "Customer No.", Type, "Version Code";
    DrillDownPageID = QCSpecVersionList_PQ;
    LookupPageID = QCSpecVersionList_PQ;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            TableRelation = Item."No." WHERE("Item Tracking Code" = FILTER(<> ''));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Item No." <> xRec."Item No." then begin
                    QCLine.SETRANGE("Item No.", xRec."Item No.");
                    QCLine.SETRANGE("Customer No.", "Customer No.");
                    QCLine.SETRANGE(Type, Type);
                    QCLine.SETRANGE("Version Code", "Version Code");
                    if QCLine.FIND('-') then
                        ERROR(Text007, FIELDNAME("Item No."));
                end;

                if QCHeader.GET("Item No.") then begin
                    "Unit of Measure Code" := QCHeader."Unit of Measure Code";
                end;


                "Version Code" := QualitySpecsCopy.GetQCVersion("Item No.", "Customer No.", Type, WORKDATE, 1);  //Origin=1=PrimarySpecCard
                //IF "Version Code" < 'A' THEN "Version Code" := 'Original';
            end;
        }
        field(2; "Customer No."; Code[20])
        {
            TableRelation = Customer;
            DataClassification = CustomerContent;
        }
        field(3; "Type"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Version Code"; Code[10])
        {
            NotBlank = false;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("Version Code" <> xRec."Version Code") and (xRec."Version Code" <> '') then begin
                    QCLine.SETRANGE("Item No.", "Item No.");
                    QCLine.SETRANGE("Customer No.", "Customer No.");
                    QCLine.SETRANGE(Type, Type);
                    QCLine.SETRANGE("Version Code", xRec."Version Code");
                    if QCLine.FIND('-') then
                        ERROR(Text007, FIELDNAME("Version Code"));
                end;
            end;
        }
        field(5; "Effective Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
                if (Status = Status::Certified) and ("Effective Date" <> 0D) then begin
                    QCVersion.SETCURRENTKEY("Item No.", "Customer No.", Type, "Effective Date");
                    QCVersion.SETRANGE("Item No.", "Item No.");
                    QCVersion.SETRANGE("Customer No.", "Customer No.");
                    QCVersion.SETRANGE(Type, Type);
                    QCVersion.SETRANGE("Effective Date", "Effective Date");
                    QCVersion.SETFILTER("Version Code", '<>%1', "Version Code");
                    if QCVersion.FIND('-') then
                        ERROR(Text002)
                end;

                if ("Effective Date" = 0D) and (xRec."Effective Date" <> 0D) and
                   (Status = Status::Certified) then
                    ERROR(Text003);
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
        field(10; "Description"; Text[50])
        {
            Caption = 'Description';
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
            CalcFormula = Exist(QCHeaderCommentLine_PQ WHERE("Table Name" = CONST("QC Version"),
                                                                    "Item No." = FIELD("Item No."),
                                                                    "Customer No." = FIELD("Customer No."),
                                                                    Type = FIELD(Type),
                                                                    "Version Code" = FIELD("Version Code")));
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

            trigger OnLookup();
            begin
                //QC5.01 begin
                VALIDATE(Status);
                //QC5.01 end
            end;

            trigger OnValidate();
            var
                PlanningAssignment: Record "Planning Assignment";
                ProdBOMCheck: Codeunit "Production BOM-Check";
            begin
                if (Status = Status::Certified) and ("Effective Date" <> 0D) then begin
                    QCVersion.SETCURRENTKEY("Item No.", "Customer No.", Type, "Effective Date");
                    QCVersion.SETRANGE("Item No.", "Item No.");
                    QCVersion.SETRANGE("Customer No.", "Customer No.");
                    QCVersion.SETRANGE(Type, Type);
                    QCVersion.SETRANGE("Effective Date", "Effective Date");
                    QCVersion.SETFILTER(Status, '%1', Status::Certified);
                    QCVersion.SETFILTER("Version Code", '<>%1', "Version Code");
                    if QCVersion.FIND('-') then
                        ERROR(Text002);
                end;

                if ("Effective Date" = 0D) and
                   (Status = Status::Certified) then
                    ERROR(Text003);
            end;
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
    }

    keys
    {
        key(Key1; "Item No.", "Customer No.", Type, "Version Code")
        {
        }
        key(Key2; "Item No.", "Customer No.", Type, "Effective Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if Status <> Status::Closed then
            ERROR(Text008);

        QCLine.SETRANGE("Item No.", "Item No.");
        QCLine.SETRANGE("Customer No.", "Customer No.");
        QCLine.SETRANGE(Type, Type);
        QCLine.SETRANGE("Version Code", "Version Code");
        QCLine.DELETEALL(true);


        QCComment.SETRANGE("Table Name", QCComment."Table Name"::"QC Version");
        QCComment.SETRANGE("Item No.", "Item No.");
        QCComment.SETRANGE("Customer No.", "Customer No.");
        QCComment.SETRANGE(Type, Type);
        QCComment.SETRANGE("Version Code", "Version Code");
        QCComment.DELETEALL;
    end;

    trigger OnInsert();
    begin
        //QC5.01 begin
        "Version Code" := '';
        Status := Status::New;
        //QC5.01 end

        QCHeader.GET("Item No.", "Customer No.", Type);
        if "Version Code" = '' then
            QCHeader.TESTFIELD("Version Nos.");

        // NoSeriesMgt.InitSeries(QCHeader."Version Nos.", xRec."No. Series", 0D, "Version Code", "No. Series");
        "No. Series" := NoSeriesMgt.GetNextNo(QCHeader."Version Nos.", 0D, true);

        "Creation Date" := TODAY;
    end;

    trigger OnModify();
    begin
        "Last Date Modified" := TODAY;
    end;

    trigger OnRename();
    begin
        //QC4.01
        ERROR(Text009);
    end;

    var
        Text000: Label 'This Quality Control Spec is being used on Items.';
        Text001: Label 'All versions attached to the Quality Specification will be closed. Close QC Spec.?';
        QCHeader: Record QCSpecificationHeader_PQ;
        QCVersion: Record QCSpecificationVersions_PQ;
        QCLine: Record QCSpecificationLine_PQ;
        QCComment: Record QCHeaderCommentLine_PQ;
        NoSeriesMgt: Codeunit "No. Series";
        Text002: Label 'You cannot have more than one certified version with the same Effective Date.';
        Text003: Label 'A Certified Version must have an effective date.';
        Text007: Label 'You must delete the lines to rename the %1 field.';
        Text008: Label 'Status must be Closed to be able to delete.';
        QualitySpecsCopy: Codeunit QCFunctionLibrary_PQ;
        Text009: Label 'Renaming is not allowed.  You need to create a new record with the correct values.';

    procedure AssistEdit(OldQCVersion: Record QCSpecificationVersions_PQ): Boolean;
    begin

        QCVersion := Rec;
        QCHeader.GET("Item No.", "Customer No.", Type);
        QCHeader.TESTFIELD("Version Nos.");
        // if NoSeriesMgt.SelectSeries(QCHeader."Version Nos.", OldQCVersion."No. Series", "No. Series") then begin
        //     QCHeader.GET("Item No.", "Customer No.", Type);
        //     QCHeader.TESTFIELD("Version Nos.");
        //     NoSeriesMgt.SetSeries("Version Code");
        //     Rec := QCVersion;
        //     exit(true);
        // end;
    end;

    procedure TestStatus();
    begin
        if (Status = Status::Certified) or
           (Status = Status::Closed) then
            FIELDERROR(Status);
    end;

    procedure Caption(): Text[100];
    var
        ProdBOMHeader: Record "Production BOM Header";
    begin
        if GETFILTERS = '' then
            exit('');

        if not QCHeader.GET("Item No.", "Customer No.", Type) then
            exit('');

    end;
}

