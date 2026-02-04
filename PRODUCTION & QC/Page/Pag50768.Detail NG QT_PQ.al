page 50768 "Detail NG QT"
{
    ApplicationArea = Manufacturing;
    Caption = 'Detail NG QT';
    PageType = List;
    SourceTable = "New Detail NG QT V1 PQ";
    // UsageCategory = Administration;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("QT No."; Rec."QT No.")
                {
                    Caption = 'Test No.';
                    ApplicationArea = All;
                    TableRelation = QualityTestHeader_PQ."Test No.";
                    Enabled = false;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    StyleExpr = DetailvsSub;
                }
                field("Sub. Quantity"; Rec."Sub. Quantity")
                {
                    ApplicationArea = All;
                    Enabled = false;
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
                RunPageLink = "Detail Entry No." = field("Entry No."), "QT No." = field("QT No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Clear(DetailvsSub);
        Rec.CalcFields("Sub. Quantity");
        if Rec."Sub. Quantity" <> Rec.Quantity then
            DetailvsSub := 'Unfavorable'
        else
            DetailvsSub := 'Favorable';
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        Rec.Type := Rec.Type::QC;
    end;

    var
        DetailvsSub: Text[30];
}

