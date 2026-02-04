using Microsoft.Manufacturing.Document;
using PRODUCTIONQC.PRODUCTIONQC;

page 50770 "Detail NG Prod Order"
{
    ApplicationArea = Manufacturing;
    Caption = 'Detail NG Production';
    PageType = List;
    SourceTable = "New Detail NG QT V1 PQ";
    UsageCategory = Administration;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Order No."; Rec."Order No.")
                {
                    Caption = 'Order No.';
                    ApplicationArea = All;
                    TableRelation = "Production Order"."No." where(Status = const(Released));
                    Enabled = false;
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    Caption = 'Order Line No.';
                    Enabled = false;
                    ApplicationArea = All;
                    TableRelation = "Prod. Order Line"."Line No." where("Prod. Order No." = field("Order No."));
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
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
        // area(processing)
        // {
        //     action("T&ranslation")
        //     {
        //         ApplicationArea = Basic, Suite;
        //         Caption = 'Sub NG Code';
        //         Image = ViewDetails;
        //         RunObject = Page "Detail Sub NG List";
        //         RunPageLink = "Detail Entry No." = field("Entry No."), "Order No." = field("Order No."), "Order Line No." = field("Order Line No.");
        //     }
        // }
    }

    procedure setParameter(var iProdOrderNo: Code[20]; iLineNo: Integer)
    begin
        ProdOrderNo := iProdOrderNo;
        LineNo := iLineNo;
    end;

    var
        ProdOrderNo: Code[20];
        LineNo: Integer;

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
        Rec."Order No." := ProdOrderNo;
        Rec.Type := Rec.Type::Production;
        Rec."Order Line No." := LineNo;
    end;

    var
        DetailvsSub: Text[30];
}

