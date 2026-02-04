table 50710 QCTestHeaderComment_PQ
{
    // version QC7.4

    // //QC37.05  Removed the word Lot out of the table name.
    // 
    // QC7.4
    //   - Increased "Entered By" Field Length to 50

    Caption = 'Quality Test Header Comment';

    fields
    {
        field(1; "Test No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Entered By"; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(5; "Comment"; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Code"; Code[10])
        {
            DataClassification = CustomerContent;
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

    trigger OnInsert();
    begin
        "Entered By" := USERID;
    end;
}

