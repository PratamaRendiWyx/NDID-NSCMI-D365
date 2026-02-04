tableextension 50113 ItemCharge_FT extends "Item Charge"
{
    fields
    {
        field(50200; "WHT Prod. Posting Group"; Code[20])
        {
            Caption = 'WHT Prod. Posting Group';
            TableRelation = WHTProductPostingGroup_FT.Code;
        }
    }
}
