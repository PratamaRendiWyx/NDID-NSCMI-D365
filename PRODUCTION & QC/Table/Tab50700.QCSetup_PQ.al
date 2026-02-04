table 50700 QCSetup_PQ
{
    // version QC80.4

    // //QC4  Navigational Pane Information:
    //            Company: Manufacturing
    //               Add Menu Group:  Quality Control  (Below Execution)
    //                  Add Menu Item:  Quality Specifications
    //                  Add Menu Item:  Specifications by Item
    //                  Add Menu Item:  Specificatiions by Customer
    //                  Add Menu Item:  Lot Information
    //                  Add Menu Item:  Serial No. Information
    //                  Add Menu Item:  Lot/Serial No. Testing
    //                  //QC4.3
    //                  Add Menu Item: Quality Test Wizard
    //                    //
    //                  Add Menu Group:  Reports
    //                     Add Menu Item:  Quality Specification
    //                     Add Menu Item:  Lot Number Activity
    //                     Add Menu Item:  Test Results by Lot Number
    //                     Add Menu Item:  Test Results by Item Number
    //                  Add Menu Group:  Setup
    //                     Add Menu Item:  Quality Control Setup
    //
    //
    // //QC71.1
    //   - Added Fields:
    //     - "Update [using] Actual Last Test Dates"
    //     - "Default Value for Ignore"
    //     - "Update [Last Test Date] on Certified"(Status)
    //     - "Update [Last Test Date] on Certified with Waiver"(Status)
    //     - "Update [Last Test Date] on Certified Final"(Status)
    //     - "Auto Test Line Comments"
    //
    //
    // QC71.3
    //   - Renumbered Fields 50k to 60k down to the 100-? Range
    //
    // QC80.4
    //   - Added Field "QCMgr Non Mand"

    Caption = 'Quality Control Setup';

    fields
    {
        field(1; "Primary Key"; Code[2])
        {
            DataClassification = CustomerContent;
        }
        field(2; "QC Test No. Series"; Code[10])
        {
            Caption = 'Quality Test No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(3; "QC Requirements"; Boolean)
        {
            Caption = 'Quality Requirements';
            DataClassification = CustomerContent;
        }
        field(4; "Default QC Location"; Code[20])
        {
            Caption = 'Default Location';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(5; "Auto Test Line Comments"; Boolean)
        {
            Description = 'QC71.1';
            DataClassification = CustomerContent;
        }
        field(100; "Update Actual Last Test Dates"; Boolean)
        {
            Description = 'QC71.1';
            DataClassification = CustomerContent;
        }
        field(101; "Update on Certified"; Boolean)
        {
            Description = 'QC71.1';
            DataClassification = CustomerContent;
        }
        field(102; "Update on Cert with Waiver"; Boolean)
        {
            Description = 'QC71.1';
            DataClassification = CustomerContent;
        }
        field(103; "Update on Certified Final"; Boolean)
        {
            Description = 'QC71.1';
            DataClassification = CustomerContent;
        }
        field(104; "Default Value for Ignore"; Boolean)
        {
            Description = 'QC71.1';
            DataClassification = CustomerContent;
        }
        field(105; "QCMgr Non Mand"; Boolean)
        {
            Caption = 'Only Quality Mgr Gets Non-Mandatory Tests';
            Description = 'QC80.4';
            DataClassification = CustomerContent;
        }
        field(106; "Autom. Create Quality Test"; Boolean)
        {
            Caption = 'Automatically create Quality Test';
            Description = 'QC200.1';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(115; "Specification Type Nos."; Code[10])
        {
            Caption = 'Specification No. Series';
            Description = 'QC200.2';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(116; "Dont update Routing Status"; Boolean)
        {
            Caption = 'Don''t update Routing Status';
            DataClassification = CustomerContent;
        }
        field(117; "Create QT per Item Tracking"; Boolean)
        {
            Caption = 'Create Quality Test per Item Tracking';
            DataClassification = CustomerContent;
        }
        field(118; "Item Jnl Template for Scrap"; Code[10])
        {
            Caption = 'Item Journal Template for Scrap';
            TableRelation = "Item Journal Template";
            DataClassification = CustomerContent;
        }
        field(119; "Item Jnl Batch for Scrap"; Code[10])
        {
            Caption = 'Item Journal Batch for Scrap';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Item Jnl Template for Scrap"));
            DataClassification = CustomerContent;
        }
        field(120; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            DataClassification = CustomerContent;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(121; "Qty. to Test Editable"; Boolean)
        {
            Caption = 'Qty. to Test Editable';
            DataClassification = CustomerContent;
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

    trigger OnModify()
    begin
        RecordHasBeenRead := false;
    end;

    var
        RecordHasBeenRead: Boolean;

    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;
        Get();
        RecordHasBeenRead := true;
    end;
}
