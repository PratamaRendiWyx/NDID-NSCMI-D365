table 50721 QCCue_PQ
{
    // version QC11.01

    // QC11.01
    //   - Removed Fields:
    //     - "Rejected", "Closed"
    //     - "Blocked Items", "Blocked Prod. Orders"

    Caption = 'Quality Control Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(5; "QC Location"; Code[20])
        {
            Caption = 'Location';
            DataClassification = CustomerContent;
        }
        field(10; "Ready For Testing"; Integer)
        {
            CalcFormula = Count(QualityTestHeader_PQ WHERE("Test Status" = CONST("Ready for Testing")));
            FieldClass = FlowField;
        }
        field(11; "In-Process"; Integer)
        {
            CalcFormula = Count(QualityTestHeader_PQ WHERE("Test Status" = CONST("In-Process")));
            FieldClass = FlowField;
        }
        field(12; "Ready For Review"; Integer)
        {
            CalcFormula = Count(QualityTestHeader_PQ WHERE("Test Status" = CONST("Ready for Review")));
            FieldClass = FlowField;
        }
        field(13; "Certified"; Integer)
        {
            CalcFormula = Count(QualityTestHeader_PQ WHERE("Test Status" = CONST(Certified)));
            FieldClass = FlowField;
        }
        /*field(14; "Certified Final"; Integer)
        {
            CalcFormula = Count(QualityTestHeader_PQ WHERE("Test Status" = CONST("Certified Final")));
            FieldClass = FlowField;
        }*/
        field(40; "PO Lines with QC Required"; Integer)
        {
            Caption = 'PO Lines with Quality Control Required';
            CalcFormula = Count("Purchase Line" WHERE("CCS QC Required" = CONST(true)));
            FieldClass = FlowField;
        }
        field(41; "Purch Receipt Lines QC Req"; Integer)
        {
            Caption = 'Purch. Receipt Lines Quality Control Required';
            CalcFormula = Count("Purch. Rcpt. Line" WHERE("CCS QC Required" = CONST(true)));
            FieldClass = FlowField;
        }
        field(44; "Items in QC Quarantine"; Integer)
        {
            Caption = 'Items in Quality Control Quarantine';
            DataClassification = CustomerContent;
        }
        field(50; "Upcoming Calibration"; Integer)
        {
            Description = 'Future';
            DataClassification = CustomerContent;
        }
        field(51; "At Calibration Lab"; Integer)
        {
            Description = 'Future';
            DataClassification = CustomerContent;
        }
        field(52; "Specification New"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(QCSpecificationHeader_PQ where(Status = filter(New)));
            Editable = false;
        }
        field(53; "Specification Certified"; Integer)
        {
            CalcFormula = Count(QCSpecificationHeader_PQ WHERE(Status = CONST(Certified)));
            FieldClass = FlowField;
        }
        field(54; "Specification UnderDevelopment"; Integer)
        {
            CalcFormula = Count(QCSpecificationHeader_PQ WHERE(Status = CONST("Under Development")));
            FieldClass = FlowField;
        }
        field(55; "Rejected"; Integer)
        {
            CalcFormula = Count(QualityTestHeader_PQ WHERE("Test Status" = CONST(Rejected)));
            FieldClass = FlowField;
        }
        field(56; "Closed Quality Tests"; Integer)
        {
            CalcFormula = Count(QualityTestHeader_PQ WHERE("Test Status" = CONST(Closed)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    var
        QCSetup: Record QCSetup_PQ;

    procedure CalcItemsInQCQuarantine(var Item: Record Item);
    begin
        if QCSetup.GET then begin
            Item.SETRANGE("Location Filter", QCSetup."Default QC Location");
            Item.CALCFIELDS(Inventory);
            Item.SETFILTER(Inventory, '>0');
            "Items in QC Quarantine" := Item.COUNT;
        end;
    end;
}

