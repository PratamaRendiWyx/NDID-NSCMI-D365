using PRODUCTIONQC.PRODUCTIONQC;

page 50769 "Detail NG List"
{
    ApplicationArea = Manufacturing;
    Caption = 'Detail NG List';
    PageType = List;
    SourceTable = "New Detail NG QT V1 PQ";
    // UsageCategory = Administration;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QT No."; Rec."QT No.")
                {
                    Caption = 'Test No.';
                    ApplicationArea = All;
                    TableRelation = QualityTestHeader_PQ."Test No.";
                    Enabled = false;
                    Visible = (Rec.Type = Rec.Type::QC);
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    Visible = Not (Rec.Type = Rec.Type::QC);
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    ApplicationArea = All;
                    Visible = Not (Rec.Type = Rec.Type::QC);
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
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
        area(processing)
        {
            action("T&ranslation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Assign NG Code';
                Image = ViewDetails;
                RunObject = Page "Detail Sub NG List";
                RunPageLink = "Detail Entry No." = field("Entry No."), "QT No." = field("QT No."), "Order No." = field("Order No."), "Order Line No." = field("Order Line No.");
            }
        }
    }
}

