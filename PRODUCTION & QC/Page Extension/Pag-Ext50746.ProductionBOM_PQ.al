pageextension 50746 ProductionBOM_PQ extends "Production BOM"
{

    layout
    {
        addafter("Last Date Modified")
        {
            field(CCSComment; Rec.Comment)
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
        modify("Copy &BOM")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Process;
        }
        addafter("Copy &BOM")
        {
            action("Update Current Unit Cost")
            {
                ApplicationArea = All;
                Caption = 'Update Current Unit Cost';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
        }
    }
}

