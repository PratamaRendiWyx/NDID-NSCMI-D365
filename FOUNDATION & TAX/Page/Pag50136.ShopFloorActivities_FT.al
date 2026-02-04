

page 50136 ShopFloorActivities_FT
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Manufacturing Cue";

    layout
    {
        area(content)
        {

            cuegroup(Production)
            {
                Caption = 'Released Prod. Orders';
                field("Production Orders All"; Rec."Released Prod. Orders - All")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'ALL';
                    DrillDownPageID = "Released Production Orders";
                    ToolTip = 'Specifies the number of released production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
            }

            cuegroup(PREPARATION)
            {
                Caption = 'Released Prod. Orders - Preparation';
                field("Prod. Ord. - PC"; Rec."Prod. Ord. - PC")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'PIPE CUTTING';
                    DrillDownPageID = "Released Production Orders";
                    ToolTip = 'Specifies the number of released production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Prod. Ord. - PT"; Rec."Prod. Ord. - PT")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'PRE TREATMENT';
                    DrillDownPageID = "Released Production Orders";
                    ToolTip = 'Specifies the number of released production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Prod. Ord. - AF"; Rec."Prod. Ord. - AF")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'ANTI FLOW';
                    DrillDownPageID = "Released Production Orders";
                    ToolTip = 'Specifies the number of released production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Prod. Ord. - BPML"; Rec."Prod. Ord. - BPM")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'BP MIX';
                    DrillDownPageID = "Released Production Orders";
                    ToolTip = 'Specifies the number of released production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }

            }
            cuegroup(FINISHING)
            {
                Caption = 'Released Prod. Orders - Finishing';

                field("Prod. Ord. - FINISHED GOOD"; Rec."Prod. Ord. - FINISHED GOOD")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'HEAT TREATMENT';
                    DrillDownPageID = "Released Production Orders";
                    ToolTip = 'Specifies the number of released production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field(NS; Rec.NS)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'NS';
                    DrillDownPageID = "Released Production Orders";
                    ToolTip = 'Specifies the number of released production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }

            }

        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        Rec.SetFilter("Date Filter", '<=%1', WorkDate());
        Rec.SetRange("User ID Filter", UserId());
    end;
}

