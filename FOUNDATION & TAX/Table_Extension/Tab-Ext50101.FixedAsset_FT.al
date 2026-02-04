tableextension 50101 FixedAsset_FT extends "Fixed Asset"
{
    fields
    {
        field(50112; "WHT Product Posting Group"; Code[20])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = WHTProductPostingGroup_FT;
        }
    }
}