using PRODUCTIONQC.PRODUCTIONQC;

page 50773 "Work Shift Vacum Cycle"
{
    ApplicationArea = Manufacturing;
    Caption = 'Work Shift Vacum Cycle';
    PageType = List;
    SourceTable = "Work Shift Vacum Cycle";


    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Rec."Shift Code")
                {
                    ApplicationArea = Manufacturing;
                    Editable = false;
                }
                field(Cycle; Rec.Cycle)
                {
                    ApplicationArea = Manufacturing;
                }
                field("Starting Time"; Rec."Starting Time")
                {
                    ApplicationArea = All;
                }
                field("Ending Time"; Rec."Ending Time")
                {
                    ApplicationArea = All;
                }
                field("Default Run Time"; Rec."Default Run Time")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

