page 50710 QCHeaderComments_PQ
{
    // version QC10.1

    AutoSplitKey = true;
    Caption = 'Quality Header Comments';
    DataCaptionFields = "Item No.", "Customer No.";
    PageType = List;
    SourceTable = QCHeaderCommentLine_PQ;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Date; Rec.Date)
                {
                    ToolTip = 'Enter the date for this comment';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Enter the text for the Quality Control header comments';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

