table 50705 QCHeaderCommentLine_PQ
{
    // version QC7

    Caption = 'Quality Comment Line';
    DataCaptionFields = "Item No.", "Customer No.", Type, "Version Code";

    fields
    {
        field(1; "Table Name"; Option)
        {
            OptionCaption = 'Quality Control Header,Quality Control Version';
            OptionMembers = "QC Header","QC Version";
            DataClassification = CustomerContent;
        }
        field(2; "Item No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(3; "Customer No."; Code[20])
        {
            TableRelation = Customer;
            DataClassification = CustomerContent;
        }
        field(4; "Type"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Version Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(12; "Comment"; Text[80])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(13; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Table Name", "Item No.", "Customer No.", Type, "Version Code", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure SetUpNewLine();
    var
        QCComment: Record QCHeaderCommentLine_PQ;
    begin
        QCComment.SETRANGE("Table Name", "Table Name");
        QCComment.SETRANGE("Item No.", "Item No.");
        QCComment.SETRANGE("Customer No.", "Customer No.");
        QCComment.SETRANGE(Type, Type);
        QCComment.SETRANGE("Version Code", "Version Code");
        if not QCComment.FIND('-') then
            Date := WORKDATE;
    end;

    procedure Caption(): Text[100];
    var
        QCHeader: Record QCSpecificationHeader_PQ;
    begin
        if GETFILTERS = '' then
            exit('');

        if not QCHeader.GET("Table Name") then
            exit('');

        exit(
          STRSUBSTNO('%1 %2 %3',
            "Table Name", QCHeader."Test Description", "Item No."));
    end;
}

