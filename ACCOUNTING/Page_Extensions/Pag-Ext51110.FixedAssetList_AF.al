namespace ACCOUNTING.ACCOUNTING;

using Microsoft.FixedAssets.FixedAsset;

pageextension 51110 FixedAssetList_AF extends "Fixed Asset List"
{
    layout
    {
        addafter("FA Location Code")
        {
            field("FA Location Name"; Rec."FA Location Name")
            {
                ApplicationArea = All;
            }
            field(Inactive; Rec.Inactive)
            {
                ApplicationArea = All;
            }
            field("Asset Group"; Rec."Asset Group")
            {
                ApplicationArea = All;
            }
            field("Asset Type"; Rec."Asset Type")
            {
                ApplicationArea = All;
            }
            field("FA Posting Group"; Rec."FA Posting Group")
            {
                ApplicationArea = All;
            }
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = All;
            }
        }
        addafter("Responsible Employee")
        {
            field("Responsible Employee Name"; Rec."Responsible Employee Name")
            {
                ApplicationArea = All;
            }
        }
    }
}
