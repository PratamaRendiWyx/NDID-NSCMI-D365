table 50702 QCSpecificationLine_PQ
{
    // version QC10.1

    // //QC   Display (field) init value set to YES
    // //QC3.7b  QC37.05b     Changed the Upper, Lower, Nominal and Actual values
    //                        to a decimal setting of 2:5
    // //QC4  Added code so you could delete the line if status was under development
    // //QC4.3 Added field 25 Result Type
    // //qc5.01  Fixed code on OnDelete Trigger to use correct Header
    // 
    // //QC7.2
    //   - Added Fields "Conditions" and "UOM Description"
    //   - Added Lookup Code to OnLookup() of "Testing UOM" field
    // 
    // QC71.1 
    //  - Added new Fields "Last Test Date", "Outside Testing" and "Mandatory"
    // 
    // QC71.3 
    //   - Renumbered Fields 50k to 60k down to the 100-? Range

    Caption = 'Quality Specification Line';
    DataCaptionFields = "Item No.", "Customer No.", Type, "Version Code", "Line No.";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Item;
            DataClassification = CustomerContent;
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
            DataClassification = CustomerContent;
        }
        field(5; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Quality Measure"; Code[20])
        {
            Description = 'Table Rel';
            TableRelation = QualityControlMeasures_PQ;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
                QCMeasuresT.GET("Quality Measure");
                "Measure Description" := QCMeasuresT.Description;

                //QC4.30
                "Result Type" := QCMeasuresT."Result Type";
            end;
        }
        field(8; "Measure Description"; Text[30])
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(9; "Lower Limit"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(10; "Upper Limit"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(11; "Nominal Value"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(12; "Testing UOM"; Code[10])
        {
            Caption = 'Testing Unit of Measure';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;

            trigger OnLookup();
            begin
                //QC7.2 Added Lookup to UOM Table
                if PAGE.RUNMODAL(0, UOM) = ACTION::LookupOK then begin
                    VALIDATE("Testing UOM", UOM.Code);
                    VALIDATE("UOM Description", UOM.Description);
                end;
            end;

            trigger OnValidate();
            begin
                UoM.Reset;
                if UoM.Get("Testing UoM") then
                    Validate("UOM Description", Uom.Description)
                else
                    Validate("UOM Description", '');

                TestStatus;
            end;
        }
        field(13; "Display"; Boolean)
        {
            InitValue = true;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(15; "Method"; Code[20])
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
        field(16; "Method Description"; Text[30])
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TestStatus;
            end;
        }
        field(22; "Comment"; Boolean)
        {
            CalcFormula = Exist(QCLinesCommentLine_PQ WHERE("Table Name" = CONST("QC Lines"),
                                                                   "Item No." = FIELD("Item No."),
                                                                   "Customer No." = FIELD("Customer No."),
                                                                   Type = FIELD(Type),
                                                                   "Version Code" = FIELD("Version Code"),
                                                                   "QC Line No." = FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Result Type"; Option)
        {
            OptionMembers = Numeric,List;
            DataClassification = CustomerContent;
        }
        field(53; "UOM Description"; Text[30])
        {
            Caption = 'Unit of Measure Description';
            Description = 'QC7.2 Added';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(54; "Conditions"; Text[30])
        {
            Description = 'QC7.2 Added';
            DataClassification = CustomerContent;
        }
        field(100; "Frequency Code"; Integer)
        {
            BlankZero = true;
            Description = 'QC71.1 Added - Freq. in Months';
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
            DataClassification = CustomerContent;
        }
        field(103; "Outside Testing"; Boolean)
        {
            Description = 'QC71.1 Added';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Mandatory then begin
                    if "Outside Testing" then
                        "Outside Testing" := CONFIRM(Text001);
                end;
            end;
        }
        field(104; "Mandatory"; Boolean)
        {
            Description = 'QC71.1 Added';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "Outside Testing" then begin
                    if Mandatory then
                        Mandatory := CONFIRM(Text001);
                end;
            end;
        }
        field(109; "Check Sum. (?)"; Boolean) { }
        field(110; Standart; Text[150])
        {

        }
        field(111; IsInteger; Boolean)
        {

        }
        field(112; "Sampling to"; Integer)
        {

        }
        field(113; "Display Report Seq."; Integer)
        {

        }
    }

    keys
    {
        key(Key1; "Item No.", "Customer No.", Type, "Version Code", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if "Version Code" = '' then begin
            QCHeaderT.SETRANGE("Item No.", "Item No.");
            QCHeaderT.SETRANGE("Customer No.", "Customer No.");
            QCHeaderT.SETRANGE(Type, Type);
            if QCHeaderT.FIND('-') then
                if (QCHeaderT.Status <> QCHeaderT.Status::Closed) and
                   (QCHeaderT.Status <> QCHeaderT.Status::"Under Development") then  //QC4
                    QCHeaderT.FIELDERROR(Status);
        end else begin
            QCVersionHT.SETRANGE("Item No.", "Item No.");
            QCVersionHT.SETRANGE("Customer No.", "Customer No.");
            QCVersionHT.SETRANGE(Type, Type);
            QCVersionHT.SETRANGE("Version Code", "Version Code");
            if QCVersionHT.FIND('-') then
                if (QCVersionHT.Status <> QCVersionHT.Status::Closed) and  //QC5
                   (QCVersionHT.Status <> QCVersionHT.Status::"Under Development") then  //QC4
                    QCVersionHT.FIELDERROR(Status);
        end;

        QCComment.SETRANGE("Table Name", QCComment."Table Name"::"QC Lines");
        QCComment.SETRANGE("Item No.", "Item No.");
        QCComment.SETRANGE("Customer No.", "Customer No.");
        QCComment.SETRANGE(Type, Type);
        QCComment.SETRANGE("Version Code", "Version Code");
        QCComment.DELETEALL;
    end;

    trigger OnInsert();
    begin
        TestStatus;
        Mandatory := true;

        if GETFILTER("Customer No.") <> '' then
            if GETRANGEMIN("Customer No.") = GETRANGEMAX("Customer No.") then
                "Customer No." := GETRANGEMIN("Customer No.");

        if GETFILTER(Type) <> '' then
            if GETRANGEMIN(Type) = GETRANGEMAX(Type) then
                Type := GETRANGEMIN(Type);

        if GETFILTER("Version Code") <> '' then
            if GETRANGEMIN("Version Code") = GETRANGEMAX("Version Code") then
                "Version Code" := GETRANGEMIN("Version Code");
    end;

    trigger OnModify();
    begin
        TestStatus;
    end;

    trigger OnRename();
    begin
        //ERROR(Text002);
    end;

    var
        QCMeasuresT: Record QualityControlMeasures_PQ;
        QCMethodsT: Record QualityControlMethods_PQ;
        QCComment: Record QCLinesCommentLine_PQ;
        QCHeaderT: Record QCSpecificationHeader_PQ;
        QCVersionHT: Record QCSpecificationVersions_PQ;
        UOM: Record "Unit of Measure";
        QCLibrary: Codeunit QCFunctionLibrary_PQ;
        Text001: Label 'Warning!\\Declaring a Test both ''Mandatory'' and ''Outside Testing'' may cause a Conflict\when attempting to place a Test into ''Certified'' Status, if the Test Line is Incomplete.\\Do you wish to Proceed?';
        Text002: Label 'You are not allowed to rename this record.';

    procedure TestStatus();
    begin
        if "Version Code" = '' then begin
            QCHeaderT.SETRANGE("Item No.", "Item No.");
            QCHeaderT.SETRANGE("Customer No.", "Customer No.");
            QCHeaderT.SETRANGE(Type, Type);
            if QCHeaderT.FIND('-') then
                if (QCHeaderT.Status = QCHeaderT.Status::Certified) or
                   (QCHeaderT.Status = QCHeaderT.Status::Closed) then
                    QCHeaderT.FIELDERROR(Status);
        end else begin
            QCVersionHT.SETRANGE("Item No.", "Item No.");
            QCVersionHT.SETRANGE("Customer No.", "Customer No.");
            QCVersionHT.SETRANGE(Type, Type);
            QCVersionHT.SETRANGE("Version Code", "Version Code");
            if QCVersionHT.FIND('-') then
                if (QCVersionHT.Status = QCVersionHT.Status::Certified) or
                   (QCVersionHT.Status = QCVersionHT.Status::Closed) then
                    QCVersionHT.FIELDERROR(Status);
        end;
    end;
}