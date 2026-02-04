/*page 51102 "Alt. Employee Posting Groups"
{
    Caption = 'Alternative Employee Posting Groups';
    DataCaptionFields = "Alt. Employee Posting Group";
    PageType = List;
    SourceTable = "Alt. Employee Posting Group";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Alt. Employee Posting Group"; Rec."Alt. Employee Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Employee group for posting business transactions to general general ledger accounts.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control2; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control3; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
    }
}
*/