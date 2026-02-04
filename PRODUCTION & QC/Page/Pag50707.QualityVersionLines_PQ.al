page 50707 QualityVersionLines_PQ
{
    // version QC10.1

    AutoSplitKey = true;
    Caption = 'Quality Specification Lines';
    DataCaptionFields = "Item No.";
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = QCSpecificationLine_PQ;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Quality Measure";Rec."Quality Measure")
                {
                    ApplicationArea = All;
                }
                field("Measure Description";Rec."Measure Description")
                {
                    ApplicationArea = All;
                }
                field(Method;Rec.Method)
                {
                    ApplicationArea = All;
                }
                field("Method Description";Rec."Method Description")
                {
                    ApplicationArea = All;
                }
                field("Lower Limit";Rec."Lower Limit")
                {
                    ApplicationArea = All;
                }
                field("Upper Limit";Rec."Upper Limit")
                {
                    ApplicationArea = All;
                }
                field("Nominal Value";Rec."Nominal Value")
                {
                    ApplicationArea = All;
                }
                field("Testing UOM";Rec."Testing UOM")
                {
                    ApplicationArea = All;
                }
                field(Display;Rec.Display)
                {
                    ToolTip = 'This indicator filters which lines show on the QC Test form.';
                    ApplicationArea = All;
                }
                field(Comment;Rec.Comment)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CommentOnPush;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    ToolTip = 'Edit Comments';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        //This functionality was copied from page 50706. Unsupported part was commented. Please check it.
                        /*CurrPage.QCLine.PAGE.*/
                        _ShowComment;

                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        Rec."Line No." := xRec."Line No.";
    end;

    var
        TableNameV : Option "QC Header","QC Lines","QC Version";

    procedure _ShowComment();
    var
        QualSpecComment : Record QCLinesCommentLine_PQ;
    begin
        QualSpecComment.SETRANGE("Table Name",QualSpecComment."Table Name"::"QC Lines");
        QualSpecComment.SETRANGE("Item No.",Rec."Item No.");
        QualSpecComment.SETRANGE("Customer No.",Rec."Customer No.");
        QualSpecComment.SETRANGE(Type,Rec.Type);
        QualSpecComment.SETRANGE("Version Code",Rec."Version Code");
        QualSpecComment.SETRANGE("QC Line No.",Rec."Line No.");
        PAGE.RUN(PAGE::QualityControlComments_PQ,QualSpecComment);
    end;

    procedure ShowComment();
    var
        QualSpecComment : Record QCLinesCommentLine_PQ;
    begin
        QualSpecComment.SETRANGE("Table Name",QualSpecComment."Table Name"::"QC Lines");
        QualSpecComment.SETRANGE("Item No.",Rec."Item No.");
        QualSpecComment.SETRANGE("Customer No.",Rec."Customer No.");
        QualSpecComment.SETRANGE(Type,Rec.Type);
        QualSpecComment.SETRANGE("Version Code",Rec."Version Code");
        QualSpecComment.SETRANGE("QC Line No.",Rec."Line No.");
        PAGE.RUN(PAGE::QualityControlComments_PQ,QualSpecComment);
    end;

    local procedure CommentOnPush();
    begin
        ShowComment;
    end;
}

