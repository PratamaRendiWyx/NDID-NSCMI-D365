pageextension 51104 FixedAssetCard_AF extends "Fixed Asset Card"
{
    layout
    {
        addafter(Description)
        {
            field("Asset Type"; Rec."Asset Type")
            {
                ApplicationArea = All;
            }
            field("Asset Group"; Rec."Asset Group")
            {
                ApplicationArea = All;
            }
            field("Expiration Calibration"; Rec."Expiration Calibration")
            {
                ApplicationArea = All;
            }
        }

    }
}