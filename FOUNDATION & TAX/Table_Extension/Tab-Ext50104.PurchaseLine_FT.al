tableextension 50104 PurchaseLine_FT extends "Purchase Line"
{
    fields
    {

        field(50110; "WHT Business Posting Group"; Code[20])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = WHTBusinessPostinGroup_FT;
        }
        field(50111; "WHT Product Posting Group"; Code[20])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = WHTProductPostingGroup_FT;
        }

        field(50112; "No. Bukti Potong"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'No. Bukti Potong';
        }
        field(50113; "WHT Amount PO"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'WHT Amount PO';
        }
    }

}