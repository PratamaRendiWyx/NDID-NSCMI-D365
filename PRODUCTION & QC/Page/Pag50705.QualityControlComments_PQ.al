page 50705 QualityControlComments_PQ
{

    AutoSplitKey = true;
    Caption = 'Quality Control Comments';
    DataCaptionFields = "QC Line No.","Line No.","Version Code";
    PageType = List;
    SourceTable = QCLinesCommentLine_PQ;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Date;Rec.Date)
                {
                    ToolTip = 'Specifies the date the comment was entered';
                    ApplicationArea = All;
                }
                field(Comment;Rec.Comment)
                {
                    ToolTip = 'Enter the comment for this Quality Control entry';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

