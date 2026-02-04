page 50121 WHTPostingSetup_FT
{
    ApplicationArea = Basic, Suite;
    Caption = 'WHT Posting Setup';
    PageType = List;
    SourceTable = WHTPostingSetup_FT;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                ShowCaption = false;

                field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a WHT Business Posting group code.';
                }
                field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a WHT Product Posting group code.';
                }

                field("WHT %"; Rec."WHT %")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the relevant WHT rate for the particular combination of WHT Business Posting group and WHT Product Posting group.';
                }
                field("PPH Purchase Account."; Rec."PPH Purchase Account.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("PPH Sales Account."; Rec."PPH Sales Account.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

}
