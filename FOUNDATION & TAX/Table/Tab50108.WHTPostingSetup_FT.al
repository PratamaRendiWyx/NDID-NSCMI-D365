table 50108 WHTPostingSetup_FT
{
    Caption = 'WHT Posting Setup';

    fields
    {
        field(1; "WHT Business Posting Group"; Code[20])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = WHTBusinessPostinGroup_FT;
        }
        field(2; "WHT Product Posting Group"; Code[20])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = WHTProductPostingGroup_FT;
        }
        field(3; "WHT %"; Decimal)
        {
            Caption = 'WHT %';
        }

        //add by rnd, 21 August 2023, related re-design WHT Posting PO & Purchase Invoice
        field(4; "PPH Sales Account."; code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; "PPH Purchase Account."; code[20])
        {
            TableRelation = "G/L Account";
        }
    }
    keys
    {
        key(Key1; "WHT Business Posting Group", "WHT Product Posting Group")
        {
            Clustered = true;
        }
    }

}
