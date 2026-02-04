page 50716 QCTestHeaderComments_PQ
{
    // version QC10.1

    // //QC37.05  Changed the object name

    AutoSplitKey = true;
    Caption = 'Quality Test Header Comments';
    PageType = List;
    SourceTable = QCTestHeaderComment_PQ;

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

