page 50774 "Work Shifts VC"
{
    ApplicationArea = Manufacturing;
    Caption = 'Work Shifts (Include Vacum Cycle)';
    PageType = List;
    SourceTable = "Work Shift";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies a code to identify this work shift.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies a description of the work shift.';
                }
                field("Default Shift"; Rec."Default Shift")
                {
                    ApplicationArea = Manufacturing;
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
        area(processing)
        {
            action("T&ranslation1")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Shift Vacum Cycle';
                Image = ViewDetails;
                RunObject = Page "Work Shift Vacum Cycle";
                RunPageLink = "Shift Code" = field(Code);
            }
        }
    }
}

