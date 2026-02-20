table 50746 QCTestLineCommentArch_PQ
{
    // version QC7.4

    // //QC37.05  Removed the word Lot out of the table name.
    // //QC6  Added lookup and drilldown Page properties (for flowfield lookups)
    // 
    // QC7.4
    //   - Increased "Entered By" Field Length to 50

    Caption = 'Quality Test Line Comment';
    DrillDownPageID = QCTestLineCommentsArch_PQ;
    LookupPageID = QCTestLineCommentsArch_PQ;

    fields
    {
        field(1; "Test No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Test Line"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Entered By"; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(6; "Comment"; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Test No.", "Test Line", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}
