pageextension 50745 ProductionBOMList_PQ extends "Production BOM List"
{

    layout
    {
        modify(Status)
        {
            Style = Strong;
            StyleExpr = TRUE;
        }
        addafter("Last Date Modified")
        {
            field(Comment; Rec.Comment)
            {
                ApplicationArea = All;
                Caption = 'Comments Exist';
            }
        }
    }
    actions
    {
        modify("Co&mments")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Process;
        }
        modify(Versions)
        {
            Promoted = true;
            PromotedIsBig = true;
        }
        modify("Ma&trix per Version")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Process;
        }
        modify("Where-used")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Process;
        }
    }
}

