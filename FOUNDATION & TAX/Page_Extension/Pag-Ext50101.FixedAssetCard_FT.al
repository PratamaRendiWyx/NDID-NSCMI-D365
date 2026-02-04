pageextension 50101 FixedAssetCard_FT extends "Fixed Asset Card"
{
    layout
    {
        addafter(Blocked)
        {
            group("Tax")
            {
                field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}