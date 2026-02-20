page 50783 QCTestLineCommentsArch_PQ
{
    // version QC10.1

    // //QC37.05  Changed the object name

    AutoSplitKey = true;
    Caption = 'Quality Test Line Comments Archived';
    DataCaptionFields = "Test No.", "Test Line";
    PageType = List;
    SourceTable = QCTestLineCommentArch_PQ;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Date; Rec.Date)
                {
                    ToolTip = 'Enter the date for the Test Line  Comment';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Enter the text for the Test Line Comment';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

