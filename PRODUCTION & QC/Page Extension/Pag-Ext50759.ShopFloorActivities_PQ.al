pageextension 50759 ShopFloorActivities_PQ extends ShopFloorActivities_FT
{
    layout
    {
        // Add changes to page layout here
        addbefore("Prod. Ord. - FINISHED GOOD")
        {
               field("Prod. Ord. - CWS"; Rec."Prod. Ord. - CWS")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'COREWINDING STANDARD';
                    DrillDownPageID = "Released Production Orders";
                    ToolTip = 'Specifies the number of released production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                } 
                field("Prod. Ord. - CWBV"; Rec."Prod. Ord. - CWBV")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'COREWINDING BFA/VA';
                    DrillDownPageID = "Released Production Orders";
                    ToolTip = 'Specifies the number of released production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                } 
        }
    }
    
    actions
    {
        // Add changes to page actions here
    }
    
}