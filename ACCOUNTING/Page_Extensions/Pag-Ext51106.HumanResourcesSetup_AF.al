namespace ACCOUNTING.ACCOUNTING;

using Microsoft.HumanResources.Setup;

pageextension 51106 HumanResourcesSetup_AF extends "Human Resources Setup"
{
    layout
    {
        addbefore(Numbering)
        {
            group(General)
            {
                // field("Allow Multiple Posting Groups"; Rec."Allow Multiple Posting Groups")
                // {
                //     Importance = Additional;
                //     ApplicationArea = Basic, Suite;
                // }
                // field("Check Multiple Posting Groups"; Rec."Check Multiple Posting Groups")
                // {
                //     ApplicationArea = Basic, Suite;
                //     Importance = Additional;
                //     ToolTip = 'Specifies implementation method of checking which posting groups can be used for the vendor.';
                // }
            }
        }
    }
}
