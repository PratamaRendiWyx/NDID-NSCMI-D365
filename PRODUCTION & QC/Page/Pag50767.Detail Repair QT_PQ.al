page 50767 "Detail Repair QT"
{
    ApplicationArea = Manufacturing;
    Caption = 'Detail Repair QT';
    PageType = List;
    SourceTable = "Detail Repair QT PQ";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("QT No."; Rec."QT No.")
                {
                    ApplicationArea = All;
                    TableRelation = QualityTestHeader_PQ."Test No.";
                    Enabled = false;
                    Caption = 'Test No.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies a code to identify repair code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies a description for the Repair code.';
                }
                field(Quantity; Rec.Quantity)
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

