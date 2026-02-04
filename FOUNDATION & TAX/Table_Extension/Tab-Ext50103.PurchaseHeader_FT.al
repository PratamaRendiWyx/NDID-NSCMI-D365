tableextension 50103 PurchaseHeader_FT extends "Purchase Header"
{
    fields
    {
        field(50100; "Tax Number_FT"; Code[40])
        {
            Caption = 'Tax Number';
        }
        field(50101; "Tax Date_FT"; Date)
        {
            Caption = 'Tax Date';
        }
        field(50102; ReturnTaxNo_FT; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'RecID';
        }
        field(50103; ReturnDocNo_FT; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'ReturnDocNo';
        }
        field(50104; ReturnDate_FT; Date)
        {
            Caption = 'ReturnDate';
        }
        field(50111; "WHT Business Posting Group"; Code[20])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = WHTBusinessPostinGroup_FT;
        }

        field(50112; "Assign Status"; Code[20])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = WHTBusinessPostinGroup_FT;
        }

    }

}
