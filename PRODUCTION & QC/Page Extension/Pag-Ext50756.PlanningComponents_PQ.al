pageextension 50756 PlanningComponents_PQ extends "Planning Components"
{

    PromotedActionCategories = 'New,Process,Report,Availability,Planning';
    layout
    {
        addafter(Description)
        {
            field("BOM No"; Rec."BOM No")
            {
                Caption = 'BOM No.';
                ApplicationArea = All;
            }
            field("Worksheet Template Name"; Rec."Worksheet Template Name")
            {
                Caption = 'Worksheet Template Name';
                ApplicationArea = All;
            }
        }
        addbefore("Expected Quantity")
        {
            field(Quantity; Rec.Quantity)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify("&Period")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category4;
        }
        modify("&Location")
        {
            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Category4;
        }
    }
}

