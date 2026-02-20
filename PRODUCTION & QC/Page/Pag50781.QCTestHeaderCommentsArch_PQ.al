page 50781 QCTestHeaderCommentsArch_PQ
{
    // version QC10.1

    // //QC37.05  Changed the object name

    AutoSplitKey = true;
    Caption = 'Quality Test Header Comments (Archived)';
    PageType = List;
    SourceTable = QCTestHeaderCommentArch_PQ;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Date; Rec.Date)
                {
                    ToolTip = 'Enter the date for the Test Header Comment';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Enter the text for the comment related to this Quality Test header';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

