tableextension 50107 PurchInvLine_FT extends "Purch. Inv. Line"
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
    }

}