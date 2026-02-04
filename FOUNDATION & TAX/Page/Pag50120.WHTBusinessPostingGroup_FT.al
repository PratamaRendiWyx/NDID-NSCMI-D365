page 50120 WHTBusinessPostingGroup_FT
{
    ApplicationArea = Basic, Suite;
    Caption = 'WHT Business Posting Group';
    PageType = List;
    SourceTable = WHTBusinessPostinGroup_FT;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                ShowCaption = false;

                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for the group.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description for the WHT business posting group.';
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("&Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page WHTPostingSetup_FT;
                RunPageLink = "WHT Business Posting Group"=FIELD(Code);
                ToolTip = 'View or edit the withholding tax (WHT) posting setup information. This includes posting groups, revenue types, and accounts.';
            }
        }
    }
}
